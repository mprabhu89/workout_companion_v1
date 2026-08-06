import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../entities/workout_session.dart';

class WorkoutSessionBuilder {
  WorkoutSessionBuilder({
    required WorkoutGroupRepository workoutGroupRepository,
    required WorkoutExerciseRepository workoutExerciseRepository,
  })  : _workoutGroupRepository = workoutGroupRepository,
        _workoutExerciseRepository = workoutExerciseRepository;

  final WorkoutGroupRepository _workoutGroupRepository;
  final WorkoutExerciseRepository _workoutExerciseRepository;

  Future<WorkoutSession> build({
    required String workoutDayId,
  }) async {
    final List<WorkoutGroup> groups =
        await _workoutGroupRepository.getWorkoutGroups(
      workoutDayId,
    );

    final List<WorkoutExercise> exercises = [];

    for (final group in groups) {
      final groupExercises =
          await _workoutExerciseRepository
              .getWorkoutExercises(group.id);

      exercises.addAll(groupExercises);
    }

    return WorkoutSession(
      workoutExercises: List.unmodifiable(exercises),
    );
  }
}