import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/repositories/workout_plan_repository.dart';

class IsarWorkoutPlanRepository
    implements WorkoutPlanRepository {
  IsarWorkoutPlanRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    final records = await _isar.isarWorkoutPlanRecords
        .where()
        .findAll();

    final workoutPlans = records
        .map(mapWorkoutPlanFromRecord)
        .toList()
      ..sort(
        (left, right) => left.name
            .toLowerCase()
            .compareTo(right.name.toLowerCase()),
      );

    return List.unmodifiable(workoutPlans);
  }

  @override
  Future<WorkoutPlan?> getWorkoutPlanById(String id) async {
    final record = await _isar.isarWorkoutPlanRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (record == null) {
      return null;
    }

    return mapWorkoutPlanFromRecord(record);
  }

  @override
  Future<void> saveWorkoutPlan(
    WorkoutPlan workoutPlan,
  ) async {
    final record = mapWorkoutPlanToRecord(workoutPlan);
    final existing = await _isar.isarWorkoutPlanRecords
        .filter()
        .idEqualTo(workoutPlan.id)
        .findFirst();

    if (existing != null) {
      record.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutPlanRecords.put(record);
    });
  }

  @override
  Future<void> deleteWorkoutPlan(String id) async {
    final existing = await _isar.isarWorkoutPlanRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutPlanRecords.delete(
        existing.isarId,
      );
    });
  }

  @override
  Future<bool> existsByName(String name) async {
    final normalizedName = name.trim().toLowerCase();
    final workoutPlans = await getAllWorkoutPlans();

    return workoutPlans.any(
      (plan) =>
          plan.name.trim().toLowerCase() ==
          normalizedName,
    );
  }
}
