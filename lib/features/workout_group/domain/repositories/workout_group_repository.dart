import '../entities/workout_group.dart';

abstract class WorkoutGroupRepository {
  Future<List<WorkoutGroup>> getWorkoutGroups(
    String workoutDayId,
  );

  Future<WorkoutGroup?> getWorkoutGroupById(
    String id,
  );

  Future<void> saveWorkoutGroup(
    WorkoutGroup workoutGroup,
  );

  Future<void> deleteWorkoutGroup(
    String id,
  );

  Future<bool> existsByName(
    String workoutDayId,
    String name,
  );
}