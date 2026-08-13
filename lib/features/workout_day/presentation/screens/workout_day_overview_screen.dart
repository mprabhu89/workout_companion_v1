import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
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
    this.workoutGroupRepository,
    this.workoutExerciseRepository,
    this.exerciseRepository,
    this.sessionBuilder,
    this.executionScreenBuilder,
  });

  final String workoutPlanId;
  final String workoutPlanName;
  final WorkoutDay workoutDay;
  final WorkoutGroupRepository? workoutGroupRepository;
  final WorkoutExerciseRepository? workoutExerciseRepository;
  final ExerciseRepository? exerciseRepository;
  final WorkoutSessionBuilder? sessionBuilder;
  final Widget Function(WorkoutSession session)?
      executionScreenBuilder;

  @override
  State<WorkoutDayOverviewScreen> createState() =>
      _WorkoutDayOverviewScreenState();
}

class _WorkoutDayOverviewScreenState
    extends State<WorkoutDayOverviewScreen> {
  late final WorkoutGroupRepository _workoutGroupRepository;
  late final WorkoutExerciseRepository
      _workoutExerciseRepository;
  late final ExerciseRepository _exerciseRepository;
  late final WorkoutSessionBuilder _sessionBuilder;

  bool _isLoading = true;
  bool _isStarting = false;
  List<_WorkoutGroupSection> _groupSections = const [];

  int get _totalExecutableExercises => _groupSections
      .fold<int>(
        0,
        (count, section) =>
            count + section.workoutExercises.length,
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
        widget.exerciseRepository ??
        RepositoryRegistry.exerciseRepository;
    _sessionBuilder =
        widget.sessionBuilder ??
        WorkoutSessionBuilder(
          workoutGroupRepository:
              _workoutGroupRepository,
          workoutExerciseRepository:
              _workoutExerciseRepository,
        );
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    final groups = await _workoutGroupRepository
        .getWorkoutGroups(widget.workoutDay.id);
    final exercises = await _exerciseRepository.getExercises();
    final exercisesById = {
      for (final exercise in exercises) exercise.id: exercise,
    };

    final sections = <_WorkoutGroupSection>[];

    for (final group in groups) {
      final workoutExercises =
          await _workoutExerciseRepository
              .getWorkoutExercises(group.id);
      final visibleExercises = workoutExercises
          .where((exercise) => !exercise.isArchived)
          .toList(growable: false);

      sections.add(
        _WorkoutGroupSection(
          workoutGroup: group,
          workoutExercises: visibleExercises,
          exercisesById: exercisesById,
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _groupSections = sections;
      _isLoading = false;
    });
  }

  Future<void> _startWorkout() async {
    if (!_canStartWorkout) {
      return;
    }

    setState(() {
      _isStarting = true;
    });

    final session = await _sessionBuilder.build(
      workoutDayId: widget.workoutDay.id,
      workoutPlanId: widget.workoutPlanId,
      workoutPlanName: widget.workoutPlanName,
      workoutDayName: widget.workoutDay.name,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isStarting = false;
    });

    if (session.workoutExercises.isEmpty) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            widget.executionScreenBuilder?.call(session) ??
            WorkoutExecutionScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutDay = widget.workoutDay;

    return Scaffold(
      appBar: AppBar(
        title: Text(workoutDay.name),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.workoutPlanName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Day ${workoutDay.dayNumber} • ${workoutDay.name}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                          if (workoutDay.description
                              .trim()
                              .isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              workoutDay.description.trim(),
                            ),
                          ],
                          if (workoutDay.isRestDay) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Rest Day',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'This day is marked as a rest day. No workout session will be started.',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!workoutDay.isRestDay &&
                      _groupSections.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No workout contents found for this day.',
                        ),
                      ),
                    ),
                  if (!workoutDay.isRestDay)
                    ..._groupSections.map(
                      (section) => _WorkoutGroupCard(
                        section: section,
                      ),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _canStartWorkout ? _startWorkout : null,
          icon: const Icon(Icons.play_arrow),
          label: Text(
            workoutDay.isRestDay
                ? 'Rest Day'
                : _totalExecutableExercises == 0
                    ? 'No Exercises Available'
                    : _isStarting
                        ? 'Starting Workout...'
                        : 'Start Workout',
          ),
        ),
      ),
    );
  }
}

class _WorkoutGroupCard extends StatelessWidget {
  const _WorkoutGroupCard({
    required this.section,
  });

  final _WorkoutGroupSection section;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.workoutGroup.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 12),
            if (section.workoutExercises.isEmpty)
              const Text('No exercises in this group.')
            else
              ...section.workoutExercises.map(
                (workoutExercise) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      section.exerciseNameFor(
                        workoutExercise,
                      ),
                    ),
                    subtitle: Text(
                      _buildExerciseSummary(
                        workoutExercise,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _buildExerciseSummary(
    WorkoutExercise workoutExercise,
  ) {
    final parts = <String>[];

    if (workoutExercise.sets != null) {
      parts.add('${workoutExercise.sets} Sets');
    }

    if (workoutExercise.repetitions != null) {
      parts.add(
        '${workoutExercise.repetitions} Reps',
      );
    }

    if (workoutExercise.durationInSeconds != null) {
      parts.add(
        '${workoutExercise.durationInSeconds} sec',
      );
    }

    if (workoutExercise.restInSeconds != null) {
      parts.add(
        'Rest ${workoutExercise.restInSeconds}s',
      );
    }

    if (workoutExercise.sessionRepetitions > 1) {
      parts.add(
        '${workoutExercise.sessionRepetitions} Rounds',
      );
    }

    return parts.isEmpty
        ? 'Workout exercise'
        : parts.join(' • ');
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

  String exerciseNameFor(
    WorkoutExercise workoutExercise,
  ) {
    return exercisesById[workoutExercise.exerciseId]
            ?.name ??
        'Unknown Exercise';
  }
}
