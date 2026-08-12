import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/presentation/widgets/workout_sequence_editor.dart';

void main() {
  group('WorkoutSequenceEditor', () {
    testWidgets(
      'can represent the bicep curl reference sequence',
      (tester) async {
        await tester.pumpWidget(
          _testApp(
            WorkoutSequenceEditor(
              workoutExercise: _workoutExercise(),
              sequenceDefinition: _bicepCurlSequence(),
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          find.text('Guide - One stop bicep curl'),
          findsOneWidget,
        );
        expect(
          find.text(
            'Guide - Be in position. Hold the dumbbell in position.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('Guide - Workout begins in 5 seconds'),
          findsOneWidget,
        );
        expect(
          find.text('Count - 5 descending'),
          findsOneWidget,
        );

        await tester.scrollUntilVisible(
          find.text(
            'Counter - 10 repetitions',
          ),
          300,
          scrollable: find.byType(Scrollable),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Counter - 10 repetitions',
          ),
          findsOneWidget,
        );

        await tester.scrollUntilVisible(
          find.text('Relax - 2 sec'),
          300,
          scrollable: find.byType(Scrollable),
        );
        await tester.pumpAndSettle();

        expect(find.text('Relax - 2 sec'), findsOneWidget);
        expect(find.text('Break'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);
      },
    );

    testWidgets(
      'preserves the configured step order',
      (tester) async {
        await tester.pumpWidget(
          _testApp(
            WorkoutSequenceEditor(
              workoutExercise: _workoutExercise(),
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.guide(text: 'First'),
                  WorkoutSequenceStep.count(
                    count: 2,
                    direction:
                        WorkoutCountDirection.ascending,
                  ),
                  WorkoutSequenceStep.relax(
                    durationInSeconds: 3,
                  ),
                ],
              ),
              onChanged: (_) {},
            ),
          ),
        );

        final firstY = tester
            .getTopLeft(find.text('Guide - First'))
            .dy;
        final secondY = tester
            .getTopLeft(find.text('Count - 2 ascending'))
            .dy;
        final thirdY = tester
            .getTopLeft(find.text('Relax - 3 sec'))
            .dy;

        expect(firstY, lessThan(secondY));
        expect(secondY, lessThan(thirdY));
      },
    );

    testWidgets(
      'invalid guide values cannot be saved from the editor',
      (tester) async {
        WorkoutSequenceDefinition? savedSequence;

        await tester.pumpWidget(
          _testApp(
            WorkoutSequenceEditor(
              workoutExercise: _workoutExercise(),
              sequenceDefinition: null,
              onChanged: (value) {
                savedSequence = value;
              },
            ),
          ),
        );

        await tester.tap(
          find.byKey(
            const Key('sequence_editor_add_step_button'),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(
            const Key('sequence_step_save_button'),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Guide text is required.'),
          findsOneWidget,
        );
        expect(savedSequence, isNull);
      },
    );

    testWidgets(
      'invalid counter values cannot be saved from the editor',
      (tester) async {
        WorkoutSequenceDefinition? savedSequence;

        await tester.pumpWidget(
          _testApp(
            WorkoutSequenceEditor(
              workoutExercise: _workoutExercise(),
              sequenceDefinition: null,
              onChanged: (value) {
                savedSequence = value;
              },
            ),
          ),
        );

        await tester.tap(
          find.byKey(
            const Key('sequence_editor_add_step_button'),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(
            const Key('sequence_step_type_dropdown'),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Counter').last);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(
            const Key('sequence_step_counter_field'),
          ),
          '0',
        );
        await tester.tap(
          find.byKey(
            const Key('sequence_step_save_button'),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Counter repetition count must be greater than zero.',
          ),
          findsOneWidget,
        );
        expect(savedSequence, isNull);
      },
    );

    test(
      'save validation rejects invalid counter break structure',
      () {
        final workoutExercise = _workoutExercise();
        final message =
            validateWorkoutSequenceDefinitionForEditor(
          workoutExercise: workoutExercise,
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.counter(repetitionCount: 2),
              WorkoutSequenceStep.guide(text: 'Up'),
              WorkoutSequenceStep.end(),
            ],
          ),
        );

        expect(message, isNotNull);
        expect(message, contains('Counter'));
      },
    );
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
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
  );
}

WorkoutSequenceDefinition _bicepCurlSequence() {
  return WorkoutSequenceDefinition(
    steps: [
      WorkoutSequenceStep.guide(text: 'One stop bicep curl'),
      WorkoutSequenceStep.guide(
        text: 'Be in position. Hold the dumbbell in position.',
      ),
      WorkoutSequenceStep.guide(
        text: 'Workout begins in 5 seconds',
      ),
      WorkoutSequenceStep.count(
        count: 5,
        direction: WorkoutCountDirection.descending,
      ),
      WorkoutSequenceStep.counter(repetitionCount: 10),
      WorkoutSequenceStep.guide(text: 'Up'),
      WorkoutSequenceStep.guide(text: 'Hold'),
      WorkoutSequenceStep.count(
        count: 2,
        direction: WorkoutCountDirection.ascending,
      ),
      WorkoutSequenceStep.guide(text: 'Squeeze'),
      WorkoutSequenceStep.guide(text: 'Release'),
      WorkoutSequenceStep.guide(text: 'Hold'),
      WorkoutSequenceStep.count(
        count: 2,
        direction: WorkoutCountDirection.ascending,
      ),
      WorkoutSequenceStep.guide(text: 'Release'),
      WorkoutSequenceStep.relax(durationInSeconds: 2),
      WorkoutSequenceStep.sequenceBreak(),
      WorkoutSequenceStep.end(),
    ],
  );
}
