import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/workout_group_workout_reference.dart';
import '../../domain/repositories/workout_group_workout_reference_repository.dart';

class IsarWorkoutGroupWorkoutReferenceRepository
    implements WorkoutGroupWorkoutReferenceRepository {
  IsarWorkoutGroupWorkoutReferenceRepository(this._isar);
  final Isar _isar;

  @override
  Future<List<WorkoutGroupWorkoutReference>> getReferences(String workoutGroupId) async {
    final records = await _isar.isarWorkoutGroupWorkoutReferenceRecords
        .filter().workoutGroupIdEqualTo(workoutGroupId).isArchivedEqualTo(false).findAll();
    final references = records.map(mapWorkoutGroupWorkoutReferenceFromRecord).toList()
      ..sort((left, right) => left.displayOrder.compareTo(right.displayOrder));
    return List.unmodifiable(references);
  }

  @override
  Future<void> saveReference(WorkoutGroupWorkoutReference reference) async {
    if (await hasReference(workoutGroupId: reference.workoutGroupId, workoutExerciseId: reference.workoutExerciseId)) {
      final existing = await _isar.isarWorkoutGroupWorkoutReferenceRecords.filter()
          .workoutGroupIdEqualTo(reference.workoutGroupId)
          .workoutExerciseIdEqualTo(reference.workoutExerciseId)
          .isArchivedEqualTo(false).findFirst();
      if (existing?.id != reference.id) throw StateError('Workout is already in this group.');
    }
    final record = mapWorkoutGroupWorkoutReferenceToRecord(reference);
    final existing = await _isar.isarWorkoutGroupWorkoutReferenceRecords.filter().idEqualTo(reference.id).findFirst();
    if (existing != null) record.isarId = existing.isarId;
    await _isar.writeTxn(() => _isar.isarWorkoutGroupWorkoutReferenceRecords.put(record));
  }

  @override
  Future<void> archiveReference(String id) async {
    final existing = await _isar.isarWorkoutGroupWorkoutReferenceRecords.filter().idEqualTo(id).findFirst();
    if (existing == null) return;
    existing.isArchived = true;
    await _isar.writeTxn(() => _isar.isarWorkoutGroupWorkoutReferenceRecords.put(existing));
  }

  @override
  Future<bool> hasReference({required String workoutGroupId, required String workoutExerciseId}) async =>
      await _isar.isarWorkoutGroupWorkoutReferenceRecords.filter().workoutGroupIdEqualTo(workoutGroupId).workoutExerciseIdEqualTo(workoutExerciseId).isArchivedEqualTo(false).findFirst() != null;

  @override
  Future<int> getNextDisplayOrder(String workoutGroupId) async {
    final references = await getReferences(workoutGroupId);
    return references.isEmpty ? 1 : references.last.displayOrder + 1;
  }
}
