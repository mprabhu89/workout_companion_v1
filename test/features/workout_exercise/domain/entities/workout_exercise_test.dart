import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';

void main() {
  group('WorkoutExercise', () {
    test(
      'preserves sequence definition through copy behavior',
      () {
        final original = _workoutExercise();
        final sequenceDefinition = WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.guide(text: 'Up'),
            WorkoutSequenceStep.end(),
          ],
        );

        final updated = original.copyWith(
          sequenceDefinition: sequenceDefinition,
          notes: 'Controlled curl',
        );

        expect(updated.sequenceDefinition, sequenceDefinition);
        expect(updated.notes, 'Controlled curl');
        expect(updated.repetitions, original.repetitions);
      },
    );

    test(
      'remains valid when no sequence definition is present',
      () {
        final workoutExercise = _workoutExercise();

        expect(workoutExercise.sequenceDefinition, isNull);
        expect(workoutExercise.repetitions, 10);
        expect(
          workoutExercise.targetType,
          WorkoutTargetType.repetitions,
        );
      },
    );
  });
}

WorkoutExercise _workoutExercise() {
  return const WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 3,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 10,
    restInSeconds: 60,
    notes: 'Initial notes',
  );
}
