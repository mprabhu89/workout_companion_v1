import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../seed/exercise_seed_data.dart';

class IsarExerciseRepository implements ExerciseRepository {
  IsarExerciseRepository(this._isar);

  final Isar _isar;

  static Future<void> seedIfEmpty(Isar isar) async {
    final collection = isar.isarExerciseRecords;
    final count = await collection.count();

    if (count > 0) {
      return;
    }

    final records = ExerciseSeedData.build()
        .map(mapExerciseToRecord)
        .toList();

    await isar.writeTxn(() async {
      await collection.putAll(records);
    });
  }

  @override
  Future<List<Exercise>> getExercises() async {
    final records =
        await _isar.isarExerciseRecords.where().findAll();

    final exercises = records
        .map(mapExerciseFromRecord)
        .where((exercise) => !exercise.isArchived)
        .toList()
      ..sort((left, right) => left.name.compareTo(right.name));

    return List.unmodifiable(exercises);
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    final record = await _isar.isarExerciseRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (record == null) {
      return null;
    }

    return mapExerciseFromRecord(record);
  }

  @override
  Future<void> saveExercise(Exercise exercise) async {
    final record = mapExerciseToRecord(exercise);
    final existing = await _isar.isarExerciseRecords
        .filter()
        .idEqualTo(exercise.id)
        .findFirst();

    if (existing != null) {
      record.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar.isarExerciseRecords.put(record);
    });
  }

  @override
  Future<void> deleteExercise(String id) async {
    final existing = await _isar.isarExerciseRecords
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    existing.isArchived = true;

    await _isar.writeTxn(() async {
      await _isar.isarExerciseRecords.put(existing);
    });
  }

  @override
  Future<bool> isExerciseNameInUse(
    String name, {
    String? excludingExerciseId,
  }) async {
    final normalizedName = name.trim().toLowerCase();
    final exercises = await getExercises();

    return exercises.any(
      (exercise) =>
          exercise.id != excludingExerciseId &&
          exercise.name.trim().toLowerCase() ==
              normalizedName,
    );
  }

  @override
  Future<List<Exercise>> searchExercises(String query) async {
    final normalizedQuery =
        query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return getExercises();
    }

    final exercises = await getExercises();

    final matches = exercises.where((exercise) {
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
      ..sort((left, right) => left.name.compareTo(right.name));

    return List.unmodifiable(matches);
  }
}
