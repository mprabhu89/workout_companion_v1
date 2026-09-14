import 'package:isar_community/isar.dart';

import 'isar_models.dart';

/// Converts legacy group-owned workout records into canonical library records
/// with ordered memberships. It is safe to run on every startup.
Future<void> migrateLegacyWorkoutExercisesToLibrary(Isar isar) async {
  final legacyRecords = await isar.isarWorkoutExerciseRecords
      .filter().workoutGroupIdIsNotNull().findAll();
  if (legacyRecords.isEmpty) return;

  await isar.writeTxn(() async {
    for (final workout in legacyRecords) {
      final referenceId = 'legacy-${workout.id}-${workout.workoutGroupId}';
      final reference = await isar.isarWorkoutGroupWorkoutReferenceRecords
          .filter().idEqualTo(referenceId).findFirst();
      if (reference == null) {
        await isar.isarWorkoutGroupWorkoutReferenceRecords.put(
          IsarWorkoutGroupWorkoutReferenceRecord()
            ..id = referenceId
            ..workoutGroupId = workout.workoutGroupId!
            ..workoutExerciseId = workout.id
            ..displayOrder = workout.displayOrder,
        );
      }
      workout.workoutGroupId = null;
      await isar.isarWorkoutExerciseRecords.put(workout);
    }
  });
}
