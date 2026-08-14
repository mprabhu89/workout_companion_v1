import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/workout_group.dart';
import '../../domain/repositories/workout_group_repository.dart';

class IsarWorkoutGroupRepository
    implements WorkoutGroupRepository {
  IsarWorkoutGroupRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<WorkoutGroup>> getWorkoutGroups(
    String workoutDayId,
  ) async {
    final records = await _isar.isarWorkoutGroupRecords
        .filter()
        .workoutDayIdEqualTo(workoutDayId)
        .and()
        .isArchivedEqualTo(false)
        .findAll();

    final workoutGroups = records
        .map(mapWorkoutGroupFromRecord)
        .toList()
      ..sort(
        (left, right) => left.displayOrder
            .compareTo(right.displayOrder),
      );

    return List.unmodifiable(workoutGroups);
  }

  @override
  Future<WorkoutGroup?> getWorkoutGroupById(
    String id,
  ) async {
    final record = await _isar.isarWorkoutGroupRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (record == null) {
      return null;
    }

    return mapWorkoutGroupFromRecord(record);
  }

  @override
  Future<void> saveWorkoutGroup(
    WorkoutGroup workoutGroup,
  ) async {
    final record = mapWorkoutGroupToRecord(workoutGroup);
    final existing = await _isar.isarWorkoutGroupRecords
        .filter()
        .idEqualTo(workoutGroup.id)
        .findFirst();

    if (existing != null) {
      record.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutGroupRecords.put(record);
    });
  }

  @override
  Future<void> deleteWorkoutGroup(String id) async {
    final existing = await _isar.isarWorkoutGroupRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    existing.isArchived = true;

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutGroupRecords.put(existing);
    });
  }

  @override
  Future<bool> existsByName(
    String workoutDayId,
    String name,
  ) async {
    final normalizedName = name.trim().toLowerCase();
    final workoutGroups =
        await getWorkoutGroups(workoutDayId);

    return workoutGroups.any(
      (group) =>
          group.name.trim().toLowerCase() ==
          normalizedName,
    );
  }
}
