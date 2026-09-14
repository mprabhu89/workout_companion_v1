import '../../domain/entities/workout_group_workout_reference.dart';
import '../../domain/repositories/workout_group_workout_reference_repository.dart';

class InMemoryWorkoutGroupWorkoutReferenceRepository
    implements WorkoutGroupWorkoutReferenceRepository {
  final List<WorkoutGroupWorkoutReference> _references = [];

  @override
  Future<List<WorkoutGroupWorkoutReference>> getReferences(String workoutGroupId) async {
    final references = _references
        .where((reference) => reference.workoutGroupId == workoutGroupId && !reference.isArchived)
        .toList()
      ..sort((left, right) => left.displayOrder.compareTo(right.displayOrder));
    return List.unmodifiable(references);
  }

  @override
  Future<void> saveReference(WorkoutGroupWorkoutReference reference) async {
    final duplicate = _references.any((existing) =>
        existing.workoutGroupId == reference.workoutGroupId &&
        existing.workoutExerciseId == reference.workoutExerciseId &&
        existing.id != reference.id &&
        !existing.isArchived);
    if (duplicate) throw StateError('Workout is already in this group.');
    final index = _references.indexWhere((existing) => existing.id == reference.id);
    if (index >= 0) { _references[index] = reference; } else { _references.add(reference); }
  }

  @override
  Future<void> archiveReference(String id) async {
    final index = _references.indexWhere((reference) => reference.id == id);
    if (index >= 0) _references[index] = _references[index].copyWith(isArchived: true);
  }

  @override
  Future<bool> hasReference({required String workoutGroupId, required String workoutExerciseId}) async =>
      _references.any((reference) => reference.workoutGroupId == workoutGroupId && reference.workoutExerciseId == workoutExerciseId && !reference.isArchived);

  @override
  Future<int> getNextDisplayOrder(String workoutGroupId) async {
    final references = await getReferences(workoutGroupId);
    return references.isEmpty ? 1 : references.last.displayOrder + 1;
  }
}
