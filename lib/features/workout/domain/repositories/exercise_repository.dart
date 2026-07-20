import '../entities/exercise.dart';

/// Contract for managing exercises.
///
/// The presentation layer depends only on this interface.
/// Different implementations (memory, Drift, cloud) can be
/// provided without changing the UI.
abstract interface class ExerciseRepository {
  /// Returns all exercises sorted by name.
  Future<List<Exercise>> getAllExercises();

  /// Returns an exercise by its unique identifier.
  Future<Exercise?> getExerciseById(String id);

  /// Creates or updates an exercise.
  Future<void> saveExercise(Exercise exercise);

  /// Deletes an exercise.
  Future<void> deleteExercise(String id);

  /// Returns true if another exercise already exists
  /// with the same name (case-insensitive).
  Future<bool> existsByName(String name);
}