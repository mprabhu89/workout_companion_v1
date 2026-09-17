import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_group/presentation/screens/workout_group_library_screen.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';
import '../../../workout_plan/presentation/widgets/plan_sharing_placeholder.dart';
import '../../../workout_plan/presentation/widgets/training_program_hud_widgets.dart';
import '../../domain/entities/workout_day.dart';
import '../../domain/repositories/workout_day_repository.dart';
import '../controllers/workout_day_library_controller.dart';
import 'create_workout_day_screen.dart';
import 'workout_day_overview_screen.dart';

class WorkoutDayLibraryScreen extends StatefulWidget {
  const WorkoutDayLibraryScreen({
    super.key,
    required this.workoutPlanId,
    required this.workoutPlanName,
    this.workoutPlanDescription = '',
    this.workoutPlanCategory,
    this.repository,
    this.workoutDayOverviewScreenBuilder,
  });

  final String workoutPlanId;
  final String workoutPlanName;
  final String workoutPlanDescription;
  final WorkoutPlanCategory? workoutPlanCategory;
  final WorkoutDayRepository? repository;
  final Widget Function(WorkoutDay workoutDay)? workoutDayOverviewScreenBuilder;

  @override
  State<WorkoutDayLibraryScreen> createState() =>
      _WorkoutDayLibraryScreenState();
}

class _WorkoutDayLibraryScreenState extends State<WorkoutDayLibraryScreen> {
  late final WorkoutDayLibraryController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WorkoutDayLibraryController(
            repository:
                widget.repository ?? RepositoryRegistry.workoutDayRepository,
            workoutPlanId: widget.workoutPlanId,
          )
          ..addListener(_refresh)
          ..loadWorkoutDays();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _createWorkoutDay() async {
    final day = await Navigator.of(context).push<WorkoutDay>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutDayScreen(
          workoutPlanId: widget.workoutPlanId,
          existingNames: _controller.workoutDays
              .map((day) => day.name)
              .toList(),
        ),
      ),
    );
    if (day != null) await _controller.saveWorkoutDay(day);
  }

  Future<void> _editWorkoutDay(WorkoutDay day) async {
    final updated = await Navigator.of(context).push<WorkoutDay>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutDayScreen(
          workoutPlanId: widget.workoutPlanId,
          workoutDay: day,
          existingNames: _controller.workoutDays
              .map((item) => item.name)
              .toList(),
        ),
      ),
    );
    if (updated != null) await _controller.saveWorkoutDay(updated);
  }

  Future<void> _deleteWorkoutDay(WorkoutDay day) =>
      _controller.deleteWorkoutDay(day.id);

  Future<void> _openWorkoutGroups(WorkoutDay day) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutGroupLibraryScreen(
          workoutDayId: day.id,
          workoutDayName: day.name,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openWorkoutDayOverview(WorkoutDay day) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            widget.workoutDayOverviewScreenBuilder?.call(day) ??
            WorkoutDayOverviewScreen(
              workoutPlanId: widget.workoutPlanId,
              workoutPlanName: widget.workoutPlanName,
              workoutDay: day,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutPlanName),
        actions: [
          IconButton(
            tooltip: 'Export Plan',
            icon: const Icon(Icons.ios_share_outlined, color: ritmoCyan),
            onPressed: () => PlanSharingPlaceholder.show(context),
          ),
        ],
      ),
      body: RitmoCyberpunkBackground(child: _buildBody()),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: RitmoActionButton(
          label: 'CREATE DAY',
          onPressed: _createWorkoutDay,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator(color: ritmoCyan));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        const RitmoHudSectionHeading(title: 'PROGRAM CONTROL'),
        const SizedBox(height: 8),
        const RitmoHierarchyPath(items: ['PROGRAM', 'DAYS']),
        if (widget.workoutPlanDescription.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          RitmoHudPanel(child: Text(widget.workoutPlanDescription.trim())),
        ],
        const SizedBox(height: 18),
        if (_controller.isEmpty)
          const RitmoHudPanel(
            glowStrength: 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NO TRAINING DAYS YET',
                  style: TextStyle(
                    color: Color(0xFFD8FCFF),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 6),
                Text('Create a training day to build this program.'),
              ],
            ),
          )
        else
          ..._controller.workoutDays.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TrainingDayCard(
                day: entry.value,
                onOpen: () => _openWorkoutDayOverview(entry.value),
                onEdit: () => _editWorkoutDay(entry.value),
                onDelete: () => _deleteWorkoutDay(entry.value),
                onManageGroups: () => _openWorkoutGroups(entry.value),
              ),
            ),
          ),
      ],
    );
  }
}

class _TrainingDayCard extends StatelessWidget {
  const _TrainingDayCard({
    required this.day,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    required this.onManageGroups,
  });

  final WorkoutDay day;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageGroups;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DayCounts>(
      future: _loadCounts(day.id),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? const _DayCounts();
        return RitmoTrainingCard(
          systemLabel: day.isRestDay
              ? 'REST DAY'
              : 'DAY ${day.dayNumber.toString().padLeft(2, '0')}',
          title: day.name,
          summary: day.description.trim().isEmpty
              ? (day.isRestDay
                    ? 'Recovery and reset.'
                    : 'Open this training stage.')
              : day.description.trim(),
          metrics: day.isRestDay
              ? const ['REST DAY']
              : [
                  '${counts.groups} ${counts.groups == 1 ? 'SESSION' : 'SESSIONS'}',
                  '${counts.workouts} ${counts.workouts == 1 ? 'WORKOUT' : 'WORKOUTS'}',
                ],
          onTap: onOpen,
          trailing: PopupMenuButton<_DayAction>(
            tooltip: 'Training day actions',
            icon: const Icon(Icons.more_horiz, color: ritmoCyan),
            onSelected: (action) {
              switch (action) {
                case _DayAction.edit:
                  onEdit();
                  break;
                case _DayAction.delete:
                  onDelete();
                  break;
                case _DayAction.manageGroups:
                  onManageGroups();
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: _DayAction.manageGroups,
                child: Text('Manage Sessions'),
              ),
              PopupMenuItem(value: _DayAction.edit, child: Text('Edit day')),
              PopupMenuItem(
                value: _DayAction.delete,
                child: Text('Delete day'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_DayCounts> _loadCounts(String dayId) async {
    final groups = await RepositoryRegistry.workoutGroupRepository
        .getWorkoutGroups(dayId);
    var workouts = 0;
    for (final group in groups) {
      final references = await RepositoryRegistry
          .workoutGroupWorkoutReferenceRepository
          .getReferences(group.id);
      workouts += references.isEmpty
          ? (await RepositoryRegistry.workoutExerciseRepository
                    .getWorkoutExercises(group.id))
                .where((workout) => !workout.isArchived)
                .length
          : references.length;
    }
    return _DayCounts(groups: groups.length, workouts: workouts);
  }
}

class _DayCounts {
  const _DayCounts({this.groups = 0, this.workouts = 0});

  final int groups;
  final int workouts;
}

enum _DayAction { edit, delete, manageGroups }
