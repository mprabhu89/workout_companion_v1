import '../entities/workout_plan.dart';

/// Contract for managing workout plans.
///
/// The presentation layer depends only on this interface.
/// Different implementations (memory, Drift, cloud)
/// can be provided without changing the UI.
abstract interface class WorkoutPlanRepository {
  /// Returns all workout plans sorted by name.
  Future<List<WorkoutPlan>> getAllWorkoutPlans();

  /// Returns a workout plan by its unique identifier.
  Future<WorkoutPlan?> getWorkoutPlanById(String id);

  /// Creates or updates a workout plan.
  Future<void> saveWorkoutPlan(WorkoutPlan workoutPlan);

  /// Deletes a workout plan.
  Future<void> deleteWorkoutPlan(String id);

  /// Returns true if another workout plan already exists
  /// with the same name (case-insensitive).
  Future<bool> existsByName(String name);
}