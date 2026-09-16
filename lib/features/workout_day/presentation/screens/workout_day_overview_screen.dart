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
