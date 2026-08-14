import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/presentation/widgets/workout_exercise_form.dart';

void main() {
  testWidgets('Reps does not show a repetitions input or Session Rounds', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('Session Rounds'), findsNothing);
    expect(find.text('Repetitions'), findsNothing);
    expect(find.text('Reps'), findsOneWidget);
  });

  testWidgets('Rest Between Sets includes 5 and 10 seconds', (tester) async {
    await tester.pumpWidget(_testApp());

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();

    expect(find.text('5 sec'), findsOneWidget);
    expect(find.text('10 sec'), findsOneWidget);
  });
}

Widget _testApp() {
  final workoutExercise = WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 3,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 10,
    restInSeconds: 60,
    sessionRepetitions: 3,
  );

  return MaterialApp(
    home: Scaffold(
      body: WorkoutExerciseForm(
        workoutExercise: workoutExercise,
        exerciseName: 'Bicep Curl',
        sets: 3,
        restSeconds: 60,
        targetType: WorkoutTargetType.repetitions,
        targetValueController: TextEditingController(text: '10'),
        notesController: TextEditingController(),
        sequenceDefinition: null,
        onSetsChanged: (_) {},
        onRestChanged: (_) {},
        onTargetTypeChanged: (_) {},
        onSequenceChanged: (_) {},
      ),
    ),
  );
}
