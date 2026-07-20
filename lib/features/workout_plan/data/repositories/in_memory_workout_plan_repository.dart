import '../../domain/entities/workout_plan.dart';
import '../../domain/repositories/workout_plan_repository.dart';

/// In-memory implementation of [WorkoutPlanRepository].
///
/// This implementation is intended for early development.
/// It can later be replaced with a Drift-backed implementation
/// without affecting the presentation layer.
class InMemoryWorkoutPlanRepository implements WorkoutPlanRepository {
  final List<WorkoutPlan> _workoutPlans = <WorkoutPlan>[];

  @override
  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    final workoutPlans = List<WorkoutPlan>.from(_workoutPlans);

    workoutPlans.sort(
      (left, right) =>
          left.name.toLowerCase().compareTo(
                right.name.toLowerCase(),
              ),
    );

    return workoutPlans;
  }

  @override
  Future<WorkoutPlan?> getWorkoutPlanById(String id) async {
    try {
      return _workoutPlans.firstWhere(
        (plan) => plan.id == id,
      );
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> saveWorkoutPlan(
    WorkoutPlan workoutPlan,
  ) async {
    final index = _workoutPlans.indexWhere(
      (plan) => plan.id == workoutPlan.id,
    );

    if (index >= 0) {
      _workoutPlans[index] = workoutPlan;
      return;
    }

    _workoutPlans.add(workoutPlan);
  }

  @override
  Future<void> deleteWorkoutPlan(String id) async {
    _workoutPlans.removeWhere(
      (plan) => plan.id == id,
    );
  }

  @override
  Future<bool> existsByName(String name) async {
    final normalizedName = name.trim().toLowerCase();

    return _workoutPlans.any(
      (plan) =>
          plan.name.trim().toLowerCase() ==
          normalizedName,
    );
  }
}