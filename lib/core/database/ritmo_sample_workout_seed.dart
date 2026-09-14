import 'package:isar_community/isar.dart';

import '../../features/workout_exercise/domain/entities/ritmo_builtin_workouts.dart';
import 'isar_mappers.dart';
import 'isar_models.dart';

/// Adds the RITMO-owned sample only when its stable IDs are absent.
Future<void> seedRitmoSampleWorkout(Isar isar) async {
  final existingExercise = await isar.isarExerciseRecords
      .filter()
      .idEqualTo(RitmoBuiltinWorkouts.oneStepBicepCurlExerciseId)
      .findFirst();
  final existingWorkout = await isar.isarWorkoutExerciseRecords
      .filter()
      .idEqualTo(RitmoBuiltinWorkouts.oneStepBicepCurlWorkoutId)
      .findFirst();

  if (existingExercise != null && existingWorkout != null) {
    return;
  }

  await isar.writeTxn(() async {
    if (existingExercise == null) {
      await isar.isarExerciseRecords.put(
        mapExerciseToRecord(RitmoBuiltinWorkouts.oneStepBicepCurlExercise),
      );
    }
    if (existingWorkout == null) {
      await isar.isarWorkoutExerciseRecords.put(
        mapWorkoutExerciseToRecord(
          RitmoBuiltinWorkouts.oneStepBicepCurlWorkout(),
        ),
      );
    }
  });
}
