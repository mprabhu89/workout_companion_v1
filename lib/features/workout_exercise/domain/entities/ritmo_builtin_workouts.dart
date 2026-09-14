import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/enums/difficulty_level.dart';
import '../../../exercise/domain/enums/equipment_type.dart';
import '../../../exercise/domain/enums/muscle_group.dart';
import 'tempo_type.dart';
import 'weight_unit.dart';
import 'workout_exercise.dart';
import 'workout_sequence_definition.dart';
import 'workout_sequence_step.dart';
import 'workout_target_type.dart';

final class RitmoBuiltinWorkouts {
  RitmoBuiltinWorkouts._();

  static const oneStepBicepCurlExerciseId =
      'ritmo-sample-exercise-one-step-bicep-curl';
  static const oneStepBicepCurlWorkoutId =
      'ritmo-sample-workout-one-step-bicep-curl';

  static bool isBuiltinExerciseId(String id) =>
      id == oneStepBicepCurlExerciseId;

  static bool isBuiltinWorkoutId(String id) => id == oneStepBicepCurlWorkoutId;

  static const Exercise oneStepBicepCurlExercise = Exercise(
    id: oneStepBicepCurlExerciseId,
    name: 'One Step Bicep Curl',
    description: 'One step bicep curl for building bicep in a controlled manner',
    instructions: 'Sample',
    muscleGroup: MuscleGroup.fullBody,
    equipment: EquipmentType.bodyweight,
    difficulty: DifficultyLevel.beginner,
    isCustom: true,
    isArchived: false,
  );

  static WorkoutExercise oneStepBicepCurlWorkout() => WorkoutExercise(
        id: oneStepBicepCurlWorkoutId,
        workoutGroupId: null,
        exerciseId: oneStepBicepCurlExerciseId,
        displayOrder: 0,
        sets: 3,
        targetType: WorkoutTargetType.repetitions,
        repetitions: 10,
        durationInSeconds: null,
        restInSeconds: 15,
        sessionRepetitions: 1,
        weight: null,
        weightUnit: WeightUnit.kilograms,
        rpe: null,
        tempoType: TempoType.normal,
        customTempo: null,
        notes: '',
        isArchived: false,
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.guide(
              text: 'Hold the dumbbell firm. Be ready in position,',
            ),
            WorkoutSequenceStep.guide(text: 'Exercise begins in 5 seconds'),
            WorkoutSequenceStep.countSeconds(
              count: 5,
              direction: WorkoutCountDirection.descending,
            ),
            WorkoutSequenceStep.guide(text: 'Rep'),
            WorkoutSequenceStep.counter(repetitionCount: 2),
            WorkoutSequenceStep.guide(
              text: 'Pull up and hold in 90 degrees',
            ),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.guide(text: 'Up by 45 degrees and hold'),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.guide(
              text: 'Squeeze and release back to 90 degrees',
            ),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.guide(text: 'Down'),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.end(),
          ],
        ),
      );
}
