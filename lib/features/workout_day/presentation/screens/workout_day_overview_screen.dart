import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../../../workout_group_workout_reference/domain/repositories/workout_group_workout_reference_repository.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';
import '../../../workout_plan/presentation/widgets/training_program_hud_widgets.dart';
import '../../../workout_session/domain/entities/workout_session.dart';
import '../../../workout_session/domain/services/workout_session_builder.dart';
import '../../../workout_session/presentation/screens/workout_execution_screen.dart';
import '../../domain/entities/workout_day.dart';

class WorkoutDayOverviewScreen extends StatefulWidget {
  const WorkoutDayOverviewScreen({
    super.key,
    required this.workoutPlanId,
    required this.workoutPlanName,
    required this.workoutDay,
    this.workoutPlanCategory,
    this.workoutGroupRepository,
    this.workoutExerciseRepository,
    this.referenceRepository,
    this.exerciseRepository,
    this.sessionBuilder,
    this.executionScreenBuilder,
  });

  final String workoutPlanId;
  final String workoutPlanName;
  final WorkoutPlanCategory? workoutPlanCategory;
  final WorkoutDay workoutDay;
  final WorkoutGroupRepository? workoutGroupRepository;
  final WorkoutExerciseRepository? workoutExerciseRepository;
  final WorkoutGroupWorkoutReferenceRepository? referenceRepository;
  final ExerciseRepository? exerciseRepository;
  final WorkoutSessionBuilder? sessionBuilder;
  final Widget Function(WorkoutSession session)? executionScreenBuilder;

  /// The shared launch path for Day Overview and Dashboard Quick Start.
  static Future<bool> startWorkoutForDay({
    required BuildContext context,
    required String workoutPlanId,
    required String workoutPlanName,
    required WorkoutDay workoutDay,
    WorkoutPlanCategory? workoutPlanCategory,
    WorkoutSessionBuilder? sessionBuilder,
    Widget Function(WorkoutSession session)? executionScreenBuilder,
  }) async {
    if (workoutDay.isRestDay) return false;
    final builder =
        sessionBuilder ??
        WorkoutSessionBuilder(
          workoutGroupRepository: RepositoryRegistry.workoutGroupRepository,
          workoutExerciseRepository:
              RepositoryRegistry.workoutExerciseRepository,
          referenceRepository:
              RepositoryRegistry.workoutGroupWorkoutReferenceRepository,
        );
    final session = await builder.build(
      workoutDayId: workoutDay.id,
      workoutPlanId: workoutPlanId,
      workoutPlanName: workoutPlanName,
      workoutPlanCategory: workoutPlanCategory,
      workoutDayName: workoutDay.name,
    );
    if (!context.mounted || session.workoutExercises.isEmpty) return false;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            executionScreenBuilder?.call(session) ??
            WorkoutExecutionScreen(session: session),
      ),
    );
    return true;
  }

  @override
  State<WorkoutDayOverviewScreen> createState() =>
      _WorkoutDayOverviewScreenState();
}

class _WorkoutDayOverviewScreenState extends State<WorkoutDayOverviewScreen> {
  late final WorkoutGroupRepository _workoutGroupRepository;
  late final WorkoutExerciseRepository _workoutExerciseRepository;
  late final ExerciseRepository _exerciseRepository;
  late final WorkoutGroupWorkoutReferenceRepository _referenceRepository;
  late final WorkoutSessionBuilder _sessionBuilder;

  bool _isLoading = true;
  bool _isStarting = false;
  List<_WorkoutGroupSection> _groupSections = const [];

  int get _totalExecutableExercises => _groupSections.fold<int>(
    0,
    (count, section) => count + section.workoutExercises.length,
  );

  bool get _canStartWorkout =>
      !widget.workoutDay.isRestDay &&
      _totalExecutableExercises > 0 &&
      !_isStarting;

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
    _sessionBuilder =
        widget.sessionBuilder ??
        WorkoutSessionBuilder(
          workoutGroupRepository: _workoutGroupRepository,
          workoutExerciseRepository: _workoutExerciseRepository,
          referenceRepository: _referenceRepository,
        );
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

  Future<void> _startWorkout() async {
    if (!_canStartWorkout) return;
    setState(() => _isStarting = true);
    final started = await WorkoutDayOverviewScreen.startWorkoutForDay(
      context: context,
      workoutPlanId: widget.workoutPlanId,
      workoutPlanName: widget.workoutPlanName,
      workoutPlanCategory: widget.workoutPlanCategory,
      workoutDay: widget.workoutDay,
      sessionBuilder: _sessionBuilder,
      executionScreenBuilder: widget.executionScreenBuilder,
    );
    if (!mounted) return;
    setState(() => _isStarting = false);
    if (!started && !widget.workoutDay.isRestDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No executable workouts are available for this training day.',
          ),
        ),
      );
    }
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
                      items: ['PROGRAM', 'DAY', 'GROUPS'],
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
                        child: Text(
                          'NO TRAINING BLOCKS YET\nAdd groups and workouts to prepare this day.',
                        ),
                      ),
                    if (!day.isRestDay)
                      ..._groupSections.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _WorkoutGroupCard(
                            section: entry.value,
                            position: entry.key + 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: RitmoActionButton(
          label: day.isRestDay
              ? 'REST DAY'
              : _totalExecutableExercises == 0
              ? 'NO WORKOUTS AVAILABLE'
              : _isStarting
              ? 'STARTING TRAINING...'
              : 'START THIS TRAINING DAY',
          onPressed: _canStartWorkout ? _startWorkout : null,
        ),
      ),
    );
  }
}

class _WorkoutGroupCard extends StatelessWidget {
  const _WorkoutGroupCard({required this.section, required this.position});

  final _WorkoutGroupSection section;
  final int position;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GROUP ${position.toString().padLeft(2, '0')}',
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
            const Text('No active workouts in this training block.')
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
        ],
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
