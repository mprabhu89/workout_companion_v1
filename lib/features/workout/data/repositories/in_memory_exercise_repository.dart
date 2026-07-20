import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

/// In-memory implementation of [ExerciseRepository].
///
/// This implementation is intended for early development.
/// It can later be replaced with a Drift-backed implementation
/// without affecting the presentation layer.
class InMemoryExerciseRepository implements ExerciseRepository {
  InMemoryExerciseRepository();

  final List<Exercise> _exercises = <Exercise>[];

  @override
  Future<List<Exercise>> getAllExercises() async {
    final exercises = List<Exercise>.from(_exercises);

    exercises.sort(
      (left, right) => left.name.toLowerCase().compareTo(
            right.name.toLowerCase(),
          ),
    );

    return exercises;
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    try {
      return _exercises.firstWhere(
        (exercise) => exercise.id == id,
      );
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> saveExercise(Exercise exercise) async {
    final index = _exercises.indexWhere(
      (item) => item.id == exercise.id,
    );

    if (index >= 0) {
      _exercises[index] = exercise;
      return;
    }

    _exercises.add(exercise);
  }

  @override
  Future<void> deleteExercise(String id) async {
    _exercises.removeWhere(
      (exercise) => exercise.id == id,
    );
  }

  @override
  Future<bool> existsByName(String name) async {
    final normalizedName = name.trim().toLowerCase();

    return _exercises.any(
      (exercise) =>
          exercise.name.trim().toLowerCase() == normalizedName,
    );
  }
}