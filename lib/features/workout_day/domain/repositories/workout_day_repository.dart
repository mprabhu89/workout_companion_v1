import '../entities/workout_day.dart';

abstract class WorkoutDayRepository {
  Future<List<WorkoutDay>> getWorkoutDays({
    required String workoutPlanId,
  });

  Future<WorkoutDay?> getWorkoutDayById(String id);

  Future<void> saveWorkoutDay(WorkoutDay workoutDay);

  Future<void> deleteWorkoutDay(String id);

  Future<bool> existsByName({
    required String workoutPlanId,
    required String name,
  });
}