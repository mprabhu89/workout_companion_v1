import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../entities/workout_session.dart';

class WorkoutSessionBuilder {
  WorkoutSessionBuilder({
    required this._workoutGroupRepository,
    required this._workoutExerciseRepository,
  });

  final WorkoutGroupRepository _workoutGroupRepository;
  final WorkoutExerciseRepository _workoutExerciseRepository;

  Future<WorkoutSession> build({
    required String workoutDayId,
    String? workoutPlanId,
    String? workoutPlanName,
    String? workoutDayName,
  }) async {
    final List<WorkoutGroup> groups =
        await _workoutGroupRepository.getWorkoutGroups(workoutDayId);

    final List<WorkoutExercise> exercises = [];

    for (final group in groups) {
      exercises.addAll(
        await _workoutExerciseRepository.getWorkoutExercises(group.id),
      );
    }

    return WorkoutSession(
      workoutExercises: List.unmodifiable(exercises),
      workoutPlanId: workoutPlanId,
      workoutPlanName: workoutPlanName,
      workoutDayId: workoutDayId,
      workoutDayName: workoutDayName,
    );
  }
}
