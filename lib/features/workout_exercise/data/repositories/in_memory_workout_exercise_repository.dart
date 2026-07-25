import '../../domain/entities/workout_exercise.dart';
import '../../domain/repositories/workout_exercise_repository.dart';

class InMemoryWorkoutExerciseRepository
    implements WorkoutExerciseRepository {
  final List<WorkoutExercise> _workoutExercises = [];

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(
    String workoutGroupId,
  ) async {
    final exercises = _workoutExercises
        .where((e) => e.workoutGroupId == workoutGroupId)
        .toList()
      ..sort(
        (a, b) => a.displayOrder.compareTo(b.displayOrder),
      );

    return List.unmodifiable(exercises);
  }

  @override
  Future<WorkoutExercise?> getWorkoutExerciseById(
    String id,
  ) async {
    try {
      return _workoutExercises.firstWhere(
        (e) => e.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveWorkoutExercise(
    WorkoutExercise workoutExercise,
  ) async {
    final index = _workoutExercises.indexWhere(
      (e) => e.id == workoutExercise.id,
    );

    if (index >= 0) {
      _workoutExercises[index] = workoutExercise;
    } else {
      _workoutExercises.add(workoutExercise);
    }
  }

  @override
  Future<void> deleteWorkoutExercise(
    String id,
  ) async {
    _workoutExercises.removeWhere(
      (e) => e.id == id,
    );
  }

  @override
  Future<bool> isDisplayOrderInUse({
    required String workoutGroupId,
    required int displayOrder,
    String? excludingWorkoutExerciseId,
  }) async {
    return _workoutExercises.any(
      (exercise) =>
          exercise.workoutGroupId == workoutGroupId &&
          exercise.displayOrder == displayOrder &&
          exercise.id != excludingWorkoutExerciseId,
    );
  }

  @override
  Future<int> getNextDisplayOrder(
    String workoutGroupId,
  ) async {
    final exercises = _workoutExercises
        .where((e) => e.workoutGroupId == workoutGroupId);

    if (exercises.isEmpty) {
      return 1;
    }

    final highestOrder = exercises
        .map((e) => e.displayOrder)
        .reduce(
          (value, element) =>
              value > element ? value : element,
        );

    return highestOrder + 1;
  }
}