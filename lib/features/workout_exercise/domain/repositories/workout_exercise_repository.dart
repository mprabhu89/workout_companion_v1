import '../entities/workout_exercise.dart';

abstract interface class WorkoutExerciseRepository {
  /// Returns all workout exercises for a workout group.
  Future<List<WorkoutExercise>> getWorkoutExercises(
    String workoutGroupId,
  );

  /// Returns a workout exercise by id.
  Future<WorkoutExercise?> getWorkoutExerciseById(
    String id,
  );

  /// Creates or updates a workout exercise.
  Future<void> saveWorkoutExercise(
    WorkoutExercise workoutExercise,
  );

  /// Deletes a workout exercise.
  Future<void> deleteWorkoutExercise(
    String id,
  );

  /// Checks whether another workout exercise already exists
  /// with the same display order inside the workout group.
  Future<bool> isDisplayOrderInUse({
    required String workoutGroupId,
    required int displayOrder,
    String? excludingWorkoutExerciseId,
  });

  /// Returns the next available display order.
  Future<int> getNextDisplayOrder(
    String workoutGroupId,
  );
}