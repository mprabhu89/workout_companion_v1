import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../seed/exercise_seed_data.dart';

class InMemoryExerciseRepository
    implements ExerciseRepository {
  InMemoryExerciseRepository()
      : _exercises = List<Exercise>.from(
          ExerciseSeedData.build(),
        );

  final List<Exercise> _exercises;

  @override
  Future<List<Exercise>> getExercises() async {
    return _exercises
        .where((exercise) => !exercise.isArchived)
        .toList()
      ..sort(
        (a, b) => a.name.compareTo(b.name),
      );
  }

  @override
  Future<Exercise?> getExerciseById(
    String id,
  ) async {
    try {
      return _exercises.firstWhere(
        (exercise) => exercise.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveExercise(
    Exercise exercise,
  ) async {
    final index = _exercises.indexWhere(
      (e) => e.id == exercise.id,
    );

    if (index == -1) {
      _exercises.add(exercise);
    } else {
      _exercises[index] = exercise;
    }
  }

  @override
  Future<void> deleteExercise(
    String id,
  ) async {
    final index = _exercises.indexWhere(
      (e) => e.id == id,
    );

    if (index == -1) {
      return;
    }

    _exercises[index] = _exercises[index].copyWith(
      isArchived: true,
    );
  }

  @override
  Future<bool> isExerciseNameInUse(
    String name, {
    String? excludingExerciseId,
  }) async {
    final normalizedName = name.trim().toLowerCase();

    return _exercises.any(
      (exercise) =>
          !exercise.isArchived &&
          exercise.id != excludingExerciseId &&
          exercise.name.trim().toLowerCase() ==
              normalizedName,
    );
  }

  @override
  Future<List<Exercise>> searchExercises(
    String query,
  ) async {
    final normalizedQuery =
        query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return getExercises();
    }

    return _exercises.where((exercise) {
      if (exercise.isArchived) {
        return false;
      }

      return exercise.name
              .toLowerCase()
              .contains(normalizedQuery) ||
          exercise.description
              .toLowerCase()
              .contains(normalizedQuery) ||
          exercise.instructions
              .toLowerCase()
              .contains(normalizedQuery);
    }).toList()
      ..sort(
        (a, b) => a.name.compareTo(b.name),
      );
  }
}