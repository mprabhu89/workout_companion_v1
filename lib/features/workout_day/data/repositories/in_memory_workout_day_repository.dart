import '../../domain/entities/workout_day.dart';
import '../../domain/repositories/workout_day_repository.dart';

class InMemoryWorkoutDayRepository implements WorkoutDayRepository {
  final List<WorkoutDay> _workoutDays = [];

  @override
  Future<List<WorkoutDay>> getWorkoutDays({
    required String workoutPlanId,
  }) async {
    final days = _workoutDays
        .where(
          (day) =>
              day.workoutPlanId == workoutPlanId &&
              !day.isArchived,
        )
        .toList()
      ..sort(
        (a, b) => a.dayNumber.compareTo(b.dayNumber),
      );

    return List.unmodifiable(days);
  }

  @override
  Future<WorkoutDay?> getWorkoutDayById(String id) async {
    try {
      return _workoutDays.firstWhere(
        (day) => day.id == id,
      );
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> saveWorkoutDay(
    WorkoutDay workoutDay,
  ) async {
    final index = _workoutDays.indexWhere(
      (day) => day.id == workoutDay.id,
    );

    if (index == -1) {
      _workoutDays.add(workoutDay);
    } else {
      _workoutDays[index] = workoutDay;
    }
  }

  @override
  Future<void> deleteWorkoutDay(String id) async {
    final index = _workoutDays.indexWhere(
      (day) => day.id == id,
    );

    if (index == -1) {
      return;
    }

    _workoutDays[index] = _workoutDays[index].copyWith(
      isArchived: true,
    );
  }

  @override
  Future<bool> existsByName({
    required String workoutPlanId,
    required String name,
  }) async {
    final normalized = name.trim().toLowerCase();

    return _workoutDays.any(
      (day) =>
          day.workoutPlanId == workoutPlanId &&
          !day.isArchived &&
          day.name.trim().toLowerCase() == normalized,
    );
  }
}