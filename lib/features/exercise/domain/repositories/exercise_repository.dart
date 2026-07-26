import '../entities/exercise.dart';

abstract class ExerciseRepository {
  /// Returns all active exercises.
  Future<List<Exercise>> getExercises();

  /// Returns a single exercise by its id.
  Future<Exercise?> getExerciseById(
    String id,
  );

  /// Creates or updates an exercise.
  Future<void> saveExercise(
    Exercise exercise,
  );

  /// Soft deletes an exercise.
  Future<void> deleteExercise(
    String id,
  );

  /// Returns true if another exercise already uses this name.
  Future<bool> isExerciseNameInUse(
    String name, {
    String? excludingExerciseId,
  });

  /// Returns built-in and custom exercises matching the query.
  Future<List<Exercise>> searchExercises(
    String query,
  );
}