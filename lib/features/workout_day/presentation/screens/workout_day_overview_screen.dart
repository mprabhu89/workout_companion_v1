import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_delete_confirmation_dialog.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../../../workout_group/presentation/screens/create_workout_group_screen.dart';
import '../../../workout_group/presentation/screens/workout_group_workouts_screen.dart';
import '../../../workout_group_workout_reference/domain/repositories/workout_group_workout_reference_repository.dart';
import '../../../workout_plan/presentation/widgets/training_program_hud_widgets.dart';
import '../../domain/entities/workout_day.dart';

class WorkoutDayOverviewScreen extends StatefulWidget {
  const WorkoutDayOverviewScreen({
    super.key,
    required this.workoutPlanId,
    required this.workoutPlanName,
    required this.workoutDay,
    this.workoutGroupRepository,
    this.workoutExerciseRepository,
    this.referenceRepository,
    this.exerciseRepository,
  });

  final String workoutPlanId;
  final String workoutPlanName;
  final WorkoutDay workoutDay;
  final WorkoutGroupRepository? workoutGroupRepository;
  final WorkoutExerciseRepository? workoutExerciseRepository;
  final WorkoutGroupWorkoutReferenceRepository? referenceRepository;
  final ExerciseRepository? exerciseRepository;
  @override
  State<WorkoutDayOverviewScreen> createState() =>
      _WorkoutDayOverviewScreenState();
}

class _WorkoutDayOverviewScreenState extends State<WorkoutDayOverviewScreen> {
  late final WorkoutGroupRepository _workoutGroupRepository;
  late final WorkoutExerciseRepository _workoutExerciseRepository;
  late final ExerciseRepository _exerciseRepository;
  late final WorkoutGroupWorkoutReferenceRepository _referenceRepository;
  bool _isLoading = true;
  List<_WorkoutGroupSection> _groupSections = const [];

  @override
  void initState() {
    super.initState();
    _workoutGroupRepository =
        widget.workoutGroupRepository ??
        RepositoryRegistry.workoutGroupRepository;
    _workoutExerciseRepository =
        widget.workoutExerciseRepository ??
        RepositoryRegistry.workoutExerciseRepository;
    _exerciseRepository =
        widget.exerciseRepository ?? RepositoryRegistry.exerciseRepository;
    _referenceRepository =
        widget.referenceRepository ??
        RepositoryRegistry.workoutGroupWorkoutReferenceRepository;
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    final groups = await _workoutGroupRepository.getWorkoutGroups(
      widget.workoutDay.id,
    );
    final exercises = await _exerciseRepository.getExercises();
    final exercisesById = {
      for (final exercise in exercises) exercise.id: exercise,
    };
    final sections = <_WorkoutGroupSection>[];
    for (final group in groups) {
      final references = await _referenceRepository.getReferences(group.id);
      final workoutExercises = references.isEmpty
          ? await _workoutExerciseRepository.getWorkoutExercises(group.id)
          : (await Future.wait(
              references.map(
                (reference) => _workoutExerciseRepository
                    .getWorkoutExerciseById(reference.workoutExerciseId),
              ),
            )).whereType<WorkoutExercise>().toList(growable: false);
      sections.add(
        _WorkoutGroupSection(
          workoutGroup: group,
          workoutExercises: workoutExercises
              .where((exercise) => !exercise.isArchived)
              .toList(growable: false),
          exercisesById: exercisesById,
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      _groupSections = sections;
      _isLoading = false;
    });
  }

  Future<void> _createSession() async {
    final session = await Navigator.of(context).push<WorkoutGroup>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutGroupScreen(
          workoutDayId: widget.workoutDay.id,
          existingNames: _groupSections
              .map((section) => section.workoutGroup.name)
              .toList(growable: false),
        ),
      ),
    );
    if (session == null) return;
    await _workoutGroupRepository.saveWorkoutGroup(session);
    await _loadOverview();
  }

  Future<void> _editSession(WorkoutGroup session) async {
    final updated = await Navigator.of(context).push<WorkoutGroup>(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutGroupScreen(
          workoutDayId: widget.workoutDay.id,
          workoutGroup: session,
          existingNames: _groupSections
              .map((section) => section.workoutGroup.name)
              .toList(growable: false),
        ),
      ),
    );
    if (updated == null) return;
    await _workoutGroupRepository.saveWorkoutGroup(updated);
    await _loadOverview();
  }

  Future<void> _deleteSession(WorkoutGroup session) async {
    final confirmed = await AppDeleteConfirmationDialog.show(
      context,
      title: 'Delete Session',
      message: 'Delete "${session.name}" from this training day?',
      deleteButtonText: 'Delete Session',
    );
    if (!confirmed) return;
    await _workoutGroupRepository.deleteWorkoutGroup(session.id);
    await _loadOverview();
  }

  Future<void> _moveSession(int index, int direction) async {
    final target = index + direction;
    if (target < 0 || target >= _groupSections.length) return;
    final current = _groupSections[index].workoutGroup;
    final other = _groupSections[target].workoutGroup;
    await _workoutGroupRepository.saveWorkoutGroup(
      current.copyWith(displayOrder: other.displayOrder),
    );
    await _workoutGroupRepository.saveWorkoutGroup(
      other.copyWith(displayOrder: current.displayOrder),
    );
    await _loadOverview();
  }

  Future<void> _openSession(WorkoutGroup session) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutGroupWorkoutsScreen(
          workoutGroupId: session.id,
          workoutGroupName: session.name,
        ),
      ),
    );
    if (mounted) await _loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.workoutDay;
    return Scaffold(
      appBar: AppBar(title: Text(day.name)),
      body: RitmoCyberpunkBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: ritmoCyan))
            : SafeArea(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    const RitmoHudSectionHeading(title: 'TRAINING STAGE'),
                    const SizedBox(height: 8),
                    const RitmoHierarchyPath(
                      items: ['PROGRAM', 'DAY', 'SESSIONS'],
                    ),
                    const SizedBox(height: 16),
                    RitmoHudPanel(
                      glowStrength: 0.28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.workoutPlanName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: ritmoCyan,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'DAY ${day.dayNumber.toString().padLeft(2, '0')} / ${day.name}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          if (day.description.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(day.description.trim()),
                          ],
                          if (day.isRestDay) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'REST DAY',
                              style: TextStyle(
                                color: ritmoOrange,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'This stage is set aside for recovery. No workout session will start.',
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (!day.isRestDay && _groupSections.isEmpty)
                      const RitmoHudPanel(
                        glowStrength: 0.18,
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
                              'Create a Session to organize the workouts you want to perform during this Day.',
                            ),
                          ],
                        ),
                      ),
                    if (!day.isRestDay)
                      ..._groupSections.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _WorkoutGroupCard(
                            section: entry.value,
                            position: entry.key + 1,
                            onOpen: () =>
                                _openSession(entry.value.workoutGroup),
                            onEdit: () =>
                                _editSession(entry.value.workoutGroup),
                            onDelete: () =>
                                _deleteSession(entry.value.workoutGroup),
                            onMoveUp: () => _moveSession(entry.key, -1),
                            onMoveDown: () => _moveSession(entry.key, 1),
                            isFirst: entry.key == 0,
                            isLast: entry.key == _groupSections.length - 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: day.isRestDay
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: RitmoActionButton(
                label: 'ADD SESSION',
                onPressed: _createSession,
              ),
            ),
    );
  }
}

class _WorkoutGroupCard extends StatelessWidget {
  const _WorkoutGroupCard({
    required this.section,
    required this.position,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.isFirst,
    required this.isLast,
  });

  final _WorkoutGroupSection section;
  final int position;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: 0.2,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SESSION ${position.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: ritmoOrange,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  section.workoutGroup.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${section.workoutExercises.length} ${section.workoutExercises.length == 1 ? 'WORKOUT' : 'WORKOUTS'}',
                ),
                const SizedBox(height: 12),
                if (section.workoutExercises.isEmpty)
                  const Text(
                    'SESSION READY\nAdd workouts from your Workout Library or create a new workout.',
                  )
                else
                  ...section.workoutExercises.map(
                    (workout) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: const Color(0x6617252B),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.exerciseNameFor(workout),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFD8FCFF),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(_buildExerciseSummary(workout)),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<_SessionAction>(
                    tooltip: 'Session actions',
                    icon: const Icon(Icons.more_horiz, color: ritmoCyan),
                    onSelected: (action) {
                      switch (action) {
                        case _SessionAction.edit:
                          onEdit();
                          break;
                        case _SessionAction.delete:
                          onDelete();
                          break;
                        case _SessionAction.moveUp:
                          onMoveUp();
                          break;
                        case _SessionAction.moveDown:
                          onMoveDown();
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: _SessionAction.edit,
                        child: Text('Edit Session'),
                      ),
                      PopupMenuItem(
                        value: _SessionAction.moveUp,
                        enabled: !isFirst,
                        child: const Text('Move Up'),
                      ),
                      PopupMenuItem(
                        value: _SessionAction.moveDown,
                        enabled: !isLast,
                        child: const Text('Move Down'),
                      ),
                      const PopupMenuItem(
                        value: _SessionAction.delete,
                        child: Text('Delete Session'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildExerciseSummary(WorkoutExercise workout) {
    final parts = <String>[];
    if (workout.sets != null) {
      parts.add('${workout.sets} SETS');
    }
    if (workout.repetitions != null) {
      parts.add('${workout.repetitions} REPS');
    }
    if (workout.durationInSeconds != null) {
      parts.add('${workout.durationInSeconds}s');
    }
    if (workout.restInSeconds != null) {
      parts.add('${workout.restInSeconds}s REST');
    }
    if (workout.sequenceDefinition != null) {
      parts.add('${workout.sequenceDefinition!.steps.length} STEPS');
    }
    return parts.isEmpty ? 'WORKOUT CONFIGURED' : parts.join(' / ');
  }
}

enum _SessionAction { edit, moveUp, moveDown, delete }

class _WorkoutGroupSection {
  const _WorkoutGroupSection({
    required this.workoutGroup,
    required this.workoutExercises,
    required this.exercisesById,
  });

  final WorkoutGroup workoutGroup;
  final List<WorkoutExercise> workoutExercises;
  final Map<String, Exercise> exercisesById;

  String exerciseNameFor(WorkoutExercise workout) =>
      exercisesById[workout.exerciseId]?.name ?? 'Unknown Workout';
}
