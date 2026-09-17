import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_plan/presentation/widgets/training_program_hud_widgets.dart';
import '../../domain/entities/workout_group.dart';
import '../controllers/workout_group_controller.dart';
import 'create_workout_group_screen.dart';
import 'workout_group_workouts_screen.dart';

class WorkoutGroupLibraryScreen extends StatefulWidget {
  const WorkoutGroupLibraryScreen({
    super.key,
    required this.workoutDayId,
    required this.workoutDayName,
  });

  final String workoutDayId;
  final String workoutDayName;

  @override
  State<WorkoutGroupLibraryScreen> createState() =>
      _WorkoutGroupLibraryScreenState();
}

class _WorkoutGroupLibraryScreenState extends State<WorkoutGroupLibraryScreen> {
  late final WorkoutGroupController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkoutGroupController(
      repository: RepositoryRegistry.workoutGroupRepository,
      workoutDayId: widget.workoutDayId,
    )..loadWorkoutGroups();
  }

  Future<void> _openWorkoutExercises(WorkoutGroup group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutGroupWorkoutsScreen(
          workoutGroupId: group.id,
          workoutGroupName: group.name,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _createWorkoutGroup() async {
    final group = await Navigator.of(context).push<WorkoutGroup>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutGroupScreen(
          workoutDayId: widget.workoutDayId,
          existingNames: _controller.workoutGroups
              .map((group) => group.name)
              .toList(),
        ),
      ),
    );
    if (group == null) return;
    await _controller.saveWorkoutGroup(group);
  }

  Future<void> _editWorkoutGroup(WorkoutGroup group) async {
    final updated = await Navigator.of(context).push<WorkoutGroup>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutGroupScreen(
          workoutDayId: widget.workoutDayId,
          workoutGroup: group,
          existingNames: _controller.workoutGroups
              .map((item) => item.name)
              .toList(),
        ),
      ),
    );
    if (updated != null) await _controller.saveWorkoutGroup(updated);
  }

  Future<void> _deleteWorkoutGroup(WorkoutGroup group) async {
    final confirmed = await AppDeleteConfirmationDialog.show(
      context,
      title: 'Delete Session',
      message: 'Delete "${group.name}" from this training day?',
    );
    if (confirmed) await _controller.deleteWorkoutGroup(group.id);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutDayName)),
        body: RitmoCyberpunkBackground(
          child: _controller.isLoading
              ? const Center(child: CircularProgressIndicator(color: ritmoCyan))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    const RitmoHudSectionHeading(title: 'TRAINING STAGE'),
                    const SizedBox(height: 8),
                    const RitmoHierarchyPath(items: ['DAY', 'SESSIONS']),
                    const SizedBox(height: 18),
                    if (_controller.workoutGroups.isEmpty)
                      const RitmoHudPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NO SESSIONS YET',
                              style: TextStyle(
                                color: Color(0xFFD8FCFF),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Create a Session to organize this training day.',
                            ),
                          ],
                        ),
                      )
                    else
                      ..._controller.workoutGroups.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TrainingGroupCard(
                            group: entry.value,
                            position: entry.key + 1,
                            onOpen: () => _openWorkoutExercises(entry.value),
                            onEdit: () => _editWorkoutGroup(entry.value),
                            onDelete: () => _deleteWorkoutGroup(entry.value),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: RitmoActionButton(
            label: 'ADD SESSION',
            onPressed: _createWorkoutGroup,
          ),
        ),
      ),
    );
  }
}

class _TrainingGroupCard extends StatelessWidget {
  const _TrainingGroupCard({
    required this.group,
    required this.position,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final WorkoutGroup group;
  final int position;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _workoutCount(),
      builder: (context, snapshot) => RitmoTrainingCard(
        systemLabel: 'SESSION ${position.toString().padLeft(2, '0')}',
        title: group.name,
        summary: 'Open this training Session to organize its workouts.',
        metrics: [
          '${snapshot.data ?? 0} ${(snapshot.data ?? 0) == 1 ? 'WORKOUT' : 'WORKOUTS'}',
        ],
        onTap: onOpen,
        trailing: PopupMenuButton<_GroupAction>(
          tooltip: 'Training Session actions',
          icon: const Icon(Icons.more_horiz, color: ritmoCyan),
          onSelected: (action) {
            if (action == _GroupAction.edit) onEdit();
            if (action == _GroupAction.delete) onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: _GroupAction.edit,
              child: Text('Edit Session'),
            ),
            PopupMenuItem(
              value: _GroupAction.delete,
              child: Text('Delete Session'),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _workoutCount() async {
    final references = await RepositoryRegistry
        .workoutGroupWorkoutReferenceRepository
        .getReferences(group.id);
    if (references.isNotEmpty) return references.length;
    return (await RepositoryRegistry.workoutExerciseRepository
            .getWorkoutExercises(group.id))
        .where((workout) => !workout.isArchived)
        .length;
  }
}

enum _GroupAction { edit, delete }
