import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/exercise/data/repositories/in_memory_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/presentation/screens/create_workout_flow_screen.dart';

void main() {
  group('Create workout flow', () {
    testWidgets('starts with free workout naming instead of Select Exercise', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CreateWorkoutFlowScreen(
            exerciseRepository: InMemoryExerciseRepository(),
            workoutExerciseRepository: InMemoryWorkoutExerciseRepository(),
          ),
        ),
      );

      expect(find.text('Name Your Workout'), findsOneWidget);
      expect(find.text('Next: Define Exercise'), findsOneWidget);
      expect(find.text('Select Exercise'), findsNothing);
    });

    testWidgets('requires a workout name before defining an exercise', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CreateWorkoutFlowScreen(
            exerciseRepository: InMemoryExerciseRepository(),
            workoutExerciseRepository: InMemoryWorkoutExerciseRepository(),
          ),
        ),
      );

      await tester.tap(find.text('Next: Define Exercise'));
      await tester.pump();

      expect(find.text('Workout name is required.'), findsOneWidget);
      expect(find.text('Define Exercise'), findsNothing);
    });

    testWidgets('creates a custom exercise and canonical workout only after save', (tester) async {
      final exercises = InMemoryExerciseRepository();
      final workouts = InMemoryWorkoutExerciseRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: CreateWorkoutFlowScreen(
            exerciseRepository: exercises,
            workoutExerciseRepository: workouts,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'My Karate Punch Drill');
      await tester.tap(find.text('Next: Define Exercise'));
      await tester.pumpAndSettle();
      expect(find.text('Define Exercise'), findsOneWidget);
      expect(find.text('My Karate Punch Drill'), findsOneWidget);

      await tester.tap(find.text('Next: Configure Workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Workout Exercise'));
      await tester.pumpAndSettle();

      final savedWorkout = (await workouts.getAllWorkoutExercises()).single;
      final savedExercise = (await exercises.getExercises())
          .singleWhere((exercise) => exercise.name == 'My Karate Punch Drill');
      expect(savedExercise.name, 'My Karate Punch Drill');
      expect(savedExercise.isCustom, isTrue);
      expect(savedWorkout.exerciseId, savedExercise.id);
      expect(savedWorkout.workoutGroupId, isNull);
    });

    testWidgets('cancelling before save does not create an exercise or workout', (tester) async {
      final exercises = InMemoryExerciseRepository();
      final workouts = InMemoryWorkoutExerciseRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: CreateWorkoutFlowScreen(
            exerciseRepository: exercises,
            workoutExerciseRepository: workouts,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Morning Push-up');
      await tester.tap(find.text('Next: Define Exercise'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(
        (await exercises.getExercises())
            .where((exercise) => exercise.name == 'Morning Push-up'),
        isEmpty,
      );
      expect(await workouts.getAllWorkoutExercises(), isEmpty);
    });
  });
}
