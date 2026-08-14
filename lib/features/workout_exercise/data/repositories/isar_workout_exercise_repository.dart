import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/repositories/workout_exercise_repository.dart';

class IsarWorkoutExerciseRepository
    implements WorkoutExerciseRepository {
  IsarWorkoutExerciseRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(
    String workoutGroupId,
  ) async {
    final records = await _isar.isarWorkoutExerciseRecords
        .filter()
        .workoutGroupIdEqualTo(workoutGroupId)
        .findAll();

    final workoutExercises = records
        .map(mapWorkoutExerciseFromRecord)
        .toList()
      ..sort(
        (left, right) => left.displayOrder
            .compareTo(right.displayOrder),
      );

    return List.unmodifiable(workoutExercises);
  }

  @override
  Future<WorkoutExercise?> getWorkoutExerciseById(
    String id,
  ) async {
    final record = await _isar.isarWorkoutExerciseRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (record == null) {
      return null;
    }

    return mapWorkoutExerciseFromRecord(record);
  }

  @override
  Future<void> saveWorkoutExercise(
    WorkoutExercise workoutExercise,
  ) async {
    final record =
        mapWorkoutExerciseToRecord(workoutExercise);
    final existing = await _isar.isarWorkoutExerciseRecords
        .filter()
        .idEqualTo(workoutExercise.id)
        .findFirst();

    if (existing != null) {
      record.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutExerciseRecords.put(
        record,
      );
    });
  }

  @override
  Future<void> deleteWorkoutExercise(String id) async {
    final existing = await _isar.isarWorkoutExerciseRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.isarWorkoutExerciseRecords.delete(
        existing.isarId,
      );
    });
  }

  @override
  Future<bool> isDisplayOrderInUse({
    required String workoutGroupId,
    required int displayOrder,
    String? excludingWorkoutExerciseId,
  }) async {
    final workoutExercises =
        await getWorkoutExercises(workoutGroupId);

    return workoutExercises.any(
      (exercise) =>
          exercise.displayOrder == displayOrder &&
          exercise.id != excludingWorkoutExerciseId,
    );
  }

  @override
  Future<int> getNextDisplayOrder(
    String workoutGroupId,
  ) async {
    final workoutExercises =
        await getWorkoutExercises(workoutGroupId);

    if (workoutExercises.isEmpty) {
      return 1;
    }

    final highestOrder = workoutExercises
        .map((exercise) => exercise.displayOrder)
        .reduce(
          (value, element) =>
              value > element ? value : element,
        );

    return highestOrder + 1;
  }
}
