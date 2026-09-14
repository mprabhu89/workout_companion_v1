import '../entities/workout_group_workout_reference.dart';

abstract interface class WorkoutGroupWorkoutReferenceRepository {
  Future<List<WorkoutGroupWorkoutReference>> getReferences(String workoutGroupId);
  Future<void> saveReference(WorkoutGroupWorkoutReference reference);
  Future<void> archiveReference(String id);
  Future<bool> hasReference({
    required String workoutGroupId,
    required String workoutExerciseId,
  });
  Future<int> getNextDisplayOrder(String workoutGroupId);
}
