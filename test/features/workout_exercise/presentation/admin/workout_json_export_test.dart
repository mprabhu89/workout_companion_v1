import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/exercise/domain/entities/exercise.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/difficulty_level.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/equipment_type.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/muscle_group.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/tempo_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/ritmo_builtin_workouts.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/weight_unit.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/presentation/admin/workout_json_export.dart';

void main() {
  test('exports one workout, its linked exercise, and ordered sequence steps', () {
    final workout = WorkoutExercise(
      id: 'workout-1',
      workoutGroupId: null,
      exerciseId: 'exercise-1',
      displayOrder: 4,
      sets: 3,
      targetType: WorkoutTargetType.duration,
      durationInSeconds: 45,
      restInSeconds: 10,
      sessionRepetitions: 2,
      weight: 12.5,
      weightUnit: WeightUnit.pounds,
      rpe: 7,
      tempoType: TempoType.custom,
      customTempo: '3-1-1',
      notes: 'Keep control.',
      sequenceDefinition: WorkoutSequenceDefinition(
        steps: [
          WorkoutSequenceStep.guide(text: 'Begin'),
          WorkoutSequenceStep.count(
            count: 5,
            direction: WorkoutCountDirection.descending,
          ),
          WorkoutSequenceStep.countSeconds(
            count: 3,
            direction: WorkoutCountDirection.ascending,
          ),
          WorkoutSequenceStep.counter(repetitionCount: 10),
          WorkoutSequenceStep.relax(durationInSeconds: 20),
          WorkoutSequenceStep.sequenceBreak(),
          WorkoutSequenceStep.end(),
        ],
      ),
    );
    const exercise = Exercise(
      id: 'exercise-1',
      name: 'Push Up',
      description: 'A push movement.',
      instructions: 'Keep your core tight.',
      muscleGroup: MuscleGroup.chest,
      equipment: EquipmentType.bodyweight,
      difficulty: DifficultyLevel.beginner,
      isCustom: true,
    );

    final export = jsonDecode(
      WorkoutJsonExport.encode(
        workoutExercise: workout,
        linkedExercise: exercise,
      ),
    ) as Map<String, dynamic>;

    expect(
      export.keys,
      ['exportType', 'exportVersion', 'workoutExercise', 'linkedExercise'],
    );
    expect(export['workoutExercise']['id'], 'workout-1');
    expect(export['workoutExercise']['workoutGroupId'], isNull);
    expect(export['workoutExercise']['sessionRepetitions'], 2);
    expect(export['linkedExercise']['name'], 'Push Up');
    expect(export['linkedExercise']['isCustom'], isTrue);

    final steps = export['workoutExercise']['sequenceDefinition']['steps']
        as List<dynamic>;
    expect(
      steps.map((step) => step['type']).toList(),
      [
        'guide',
        'count',
        'countSeconds',
        'counter',
        'relax',
        'sequenceBreak',
        'end',
      ],
    );
    expect(
      steps.map((step) => step['order']).toList(),
      [0, 1, 2, 3, 4, 5, 6],
    );
    expect(steps[0]['text'], 'Begin');
    expect(steps[1]['countDirection'], 'descending');
    expect(steps[2]['countDirection'], 'ascending');
    expect(steps[3]['repetitionCount'], 10);
    expect(steps[4]['durationInSeconds'], 20);
  });

  test('does not include unrelated records when the linked exercise is absent', () {
    final export = jsonDecode(
      WorkoutJsonExport.encode(
        workoutExercise: WorkoutExercise(
          id: 'workout-only',
          exerciseId: 'missing-exercise',
          displayOrder: 1,
          targetType: WorkoutTargetType.repetitions,
        ),
        linkedExercise: null,
      ),
    ) as Map<String, dynamic>;

    expect(
      export.keys,
      ['exportType', 'exportVersion', 'workoutExercise', 'linkedExercise'],
    );
    expect(export['linkedExercise'], isNull);
    expect(export.containsKey('workoutPlans'), isFalse);
    expect(export.containsKey('workoutHistory'), isFalse);
  });

  test('exports the protected RITMO sample without mutating its definition', () {
    final workout = RitmoBuiltinWorkouts.oneStepBicepCurlWorkout();
    final originalSteps = List.of(workout.sequenceDefinition!.steps);

    final export = jsonDecode(
      WorkoutJsonExport.encode(
        workoutExercise: workout,
        linkedExercise: RitmoBuiltinWorkouts.oneStepBicepCurlExercise,
      ),
    ) as Map<String, dynamic>;

    expect(
      export['workoutExercise']['id'],
      RitmoBuiltinWorkouts.oneStepBicepCurlWorkoutId,
    );
    expect(
      export['linkedExercise']['id'],
      RitmoBuiltinWorkouts.oneStepBicepCurlExerciseId,
    );
    expect(
      export['workoutExercise']['sequenceDefinition']['steps'],
      hasLength(14),
    );
    expect(workout.sequenceDefinition!.steps, originalSteps);
  });
}
