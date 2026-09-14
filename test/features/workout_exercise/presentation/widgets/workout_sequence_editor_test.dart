import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/presentation/widgets/workout_sequence_editor.dart';

void main() {
  group('WorkoutSequenceEditor', () {
    testWidgets('can represent the bicep curl reference sequence', (
      tester,
    ) async {
      await tester.pumpWidget(
        _testApp(
          WorkoutSequenceEditor(
            workoutExercise: _workoutExercise(),
            sequenceDefinition: _bicepCurlSequence(),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Guide'), findsNWidgets(3));
      expect(find.text('One stop bicep curl'), findsOneWidget);
      expect(
        find.text('Be in position. Hold the dumbbell in position.'),
        findsOneWidget,
      );
      expect(find.text('Workout begins in 5 seconds'), findsOneWidget);
      expect(find.text('5 to 1'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('10 repetitions'),
        300,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reps - Counter'), findsOneWidget);
      expect(find.text('10 repetitions'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('2 seconds'),
        300,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      expect(find.text('Relax'), findsOneWidget);
      expect(find.text('2 seconds'), findsOneWidget);
      expect(find.text('Break'), findsOneWidget);
      expect(find.text('End'), findsOneWidget);
    });

    testWidgets('preserves the configured step order', (tester) async {
      await tester.pumpWidget(
        _testApp(
          WorkoutSequenceEditor(
            workoutExercise: _workoutExercise(),
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(text: 'First'),
                WorkoutSequenceStep.count(
                  count: 2,
                  direction: WorkoutCountDirection.ascending,
                ),
                WorkoutSequenceStep.relax(durationInSeconds: 3),
              ],
            ),
            onChanged: (_) {},
          ),
        ),
      );

      final firstY = tester.getTopLeft(find.text('First')).dy;
      final secondY = tester.getTopLeft(find.text('1 to 2')).dy;
      final thirdY = tester.getTopLeft(find.text('3 seconds')).dy;

      expect(firstY, lessThan(secondY));
      expect(secondY, lessThan(thirdY));
    });

    testWidgets('invalid guide values cannot be saved from the editor', (
      tester,
    ) async {
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
        find.byKey(const Key('sequence_editor_add_step_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('sequence_step_save_button')));
      await tester.pumpAndSettle();

      expect(find.text('Guide text is required.'), findsOneWidget);
      expect(savedSequence, isNull);
    });

    testWidgets('invalid counter values cannot be saved from the editor', (
      tester,
    ) async {
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
        find.byKey(const Key('sequence_editor_add_step_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('sequence_step_type_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reps - Counter').last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('sequence_step_counter_field')),
        '0',
      );
      await tester.tap(find.byKey(const Key('sequence_step_save_button')));
      await tester.pumpAndSettle();

      expect(find.text('Reps must be greater than zero.'), findsOneWidget);
      expect(savedSequence, isNull);
    });

    testWidgets('adds Count Seconds with count and direction controls', (
      tester,
    ) async {
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
        find.byKey(const Key('sequence_editor_add_step_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sequence_step_type_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Count Seconds').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('sequence_step_count_field')),
        '3',
      );
      await tester.tap(find.byKey(const Key('sequence_step_save_button')));
      await tester.pumpAndSettle();

      expect(savedSequence, isNotNull);
      expect(
        savedSequence!.steps.single.type,
        WorkoutSequenceStepType.countSeconds,
      );
      expect(savedSequence!.steps.single.count, 3);
      expect(
        savedSequence!.steps.single.countDirection,
        WorkoutCountDirection.ascending,
      );
    });

    testWidgets(
      'edits a Reps - Counter without changing its internal step type',
      (tester) async {
        WorkoutSequenceDefinition? savedSequence;
        final sequenceDefinition = WorkoutSequenceDefinition(
          steps: [WorkoutSequenceStep.counter(repetitionCount: 10)],
        );

        await tester.pumpWidget(
          _testApp(
            WorkoutSequenceEditor(
              workoutExercise: _workoutExercise(),
              sequenceDefinition: sequenceDefinition,
              onChanged: (value) {
                savedSequence = value;
              },
            ),
          ),
        );

        expect(
          sequenceDefinition.steps.single.type,
          WorkoutSequenceStepType.counter,
        );
        expect(find.text('Reps - Counter'), findsOneWidget);
        expect(find.text('10 repetitions'), findsOneWidget);

        await tester.tap(find.byTooltip('Edit Step'));
        await tester.pumpAndSettle();
        expect(find.text('Reps - Counter').last, findsOneWidget);
        expect(find.text('Reps'), findsOneWidget);

        await tester.enterText(
          find.byKey(const Key('sequence_step_counter_field')),
          '12',
        );
        await tester.tap(find.byKey(const Key('sequence_step_save_button')));
        await tester.pumpAndSettle();

        expect(savedSequence, isNotNull);
        expect(
          savedSequence!.steps.single.type,
          WorkoutSequenceStepType.counter,
        );
        expect(savedSequence!.steps.single.repetitionCount, 12);
      },
    );

    test('save validation rejects invalid counter break structure', () {
      final workoutExercise = _workoutExercise();
      final message = validateWorkoutSequenceDefinitionForEditor(
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
    });

    testWidgets('uses readable primary and secondary text on a narrow phone', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _testApp(
          WorkoutSequenceEditor(
            workoutExercise: _workoutExercise(),
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(
                  text: 'Begin with a controlled movement and keep breathing.',
                ),
                WorkoutSequenceStep.countSeconds(
                  count: 3,
                  direction: WorkoutCountDirection.descending,
                ),
                WorkoutSequenceStep.counter(repetitionCount: 10),
              ],
            ),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Guide'), findsOneWidget);
      expect(
        find.text('Begin with a controlled movement and keep breathing.'),
        findsOneWidget,
      );
      expect(find.text('Count Seconds'), findsOneWidget);
      expect(find.text('3 to 1 seconds'), findsOneWidget);
      expect(find.text('10 repetitions'), findsOneWidget);

      final guideSummary = tester.widget<Text>(
        find.byKey(const Key('sequence_step_summary_0')),
      );
      final countType = tester.widget<Text>(
        find.byKey(const Key('sequence_step_type_1')),
      );
      expect(guideSummary.maxLines, 2);
      expect(guideSummary.overflow, TextOverflow.ellipsis);
      expect(countType.maxLines, 1);
      expect(countType.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    });
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
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
      WorkoutSequenceStep.guide(text: 'Workout begins in 5 seconds'),
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
