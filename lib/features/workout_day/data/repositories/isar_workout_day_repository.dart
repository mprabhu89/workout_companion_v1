import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/workout_day.dart';
import '../../domain/repositories/workout_day_repository.dart';

class IsarWorkoutDayRepository
    implements WorkoutDayRepository {
  IsarWorkoutDayRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<WorkoutDay>> getWorkoutDays({
    required String workoutPlanId,
  }) async {
    final records = await _isar.isarWorkoutDayRecords
        .filter()
        .workoutPlanIdEqualTo(workoutPlanId)
        .and()
        .isArchivedEqualTo(false)
        .findAll();

    final workoutDays = records
        .map(mapWorkoutDayFromRecord)
        .toList()
      ..sort(
        (left, right) =>
            left.dayNumber.compareTo(right.dayNumber),
      );

    return List.unmodifiable(workoutDays);
  }

  @override
  Future<WorkoutDay?> getWorkoutDayById(String id) async {
    final record = await _isar.isarWorkoutDayRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (record == null) {
      return null;
    }

    return mapWorkoutDayFromRecord(record);
  }

  @override
  Future<void> saveWorkoutDay(WorkoutDay workoutDay) async {
    final record = mapWorkoutDayToRecord(workoutDay);
    final existing = await _isar.isarWorkoutDayRecords
        .filter()
        .idEqualTo(workoutDay.id)
        .findFirst();

    if (existing != null) {
      record.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutDayRecords.put(record);
    });
  }

  @override
  Future<void> deleteWorkoutDay(String id) async {
    final existing = await _isar.isarWorkoutDayRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    existing.isArchived = true;

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutDayRecords.put(existing);
    });
  }

  @override
  Future<bool> existsByName({
    required String workoutPlanId,
    required String name,
  }) async {
    final normalizedName = name.trim().toLowerCase();
    final workoutDays = await getWorkoutDays(
      workoutPlanId: workoutPlanId,
    );

    return workoutDays.any(
      (day) =>
          day.name.trim().toLowerCase() ==
          normalizedName,
    );
  }
}
