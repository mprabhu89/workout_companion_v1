import '../../domain/entities/tempo_type.dart';
import '../../domain/entities/weight_unit.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_target_type.dart';

class WorkoutExerciseMapper {
  const WorkoutExerciseMapper._();

  static WorkoutExercise create({
    required String id,
    required String workoutGroupId,
    required String exerciseId,
    required int displayOrder,
    required int sets,
    required WorkoutTargetType targetType,
    required String targetValue,
    required int restSeconds,
    required String notes,
  }) {
    int? repetitions;
    int? durationInSeconds;

    switch (targetType) {
      case WorkoutTargetType.repetitions:
        repetitions = int.tryParse(targetValue);
        break;

      case WorkoutTargetType.duration:
        durationInSeconds = int.tryParse(targetValue);
        break;

      // These target types will be supported in a future release.
      case WorkoutTargetType.distance:
      case WorkoutTargetType.calories:
      case WorkoutTargetType.custom:
        break;
    }

    return WorkoutExercise(
      id: id,
      workoutGroupId: workoutGroupId,
      exerciseId: exerciseId,
      displayOrder: displayOrder,
      sets: sets,
      targetType: targetType,
      repetitions: repetitions,
      durationInSeconds: durationInSeconds,
      restInSeconds: restSeconds,
      tempoType: TempoType.normal,
      customTempo: null,
      rpe: null,
      weight: null,
      weightUnit: WeightUnit.kilograms,
      notes: notes.trim(),
      isArchived: false,
    );
  }
}