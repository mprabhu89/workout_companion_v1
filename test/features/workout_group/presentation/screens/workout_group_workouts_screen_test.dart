import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import 'package:workout_companion_v1/features/exercise/data/repositories/in_memory_exercise_repository.dart';
import 'package:workout_companion_v1/features/exercise/domain/entities/exercise.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/difficulty_level.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/equipment_type.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/muscle_group.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_group/presentation/screens/workout_group_workouts_screen.dart';
import 'package:workout_companion_v1/features/workout_group_workout_reference/data/repositories/in_memory_workout_group_workout_reference_repository.dart';

void main() {
  group('WorkoutGroupWorkoutsScreen refreshes Training Session membership', () {
    late Object originalExercises;
    late Object originalWorkouts;
    late Object originalReferences;
    late InMemoryExerciseRepository exercises;
    late InMemoryWorkoutExerciseRepository workouts;
    late InMemoryWorkoutGroupWorkoutReferenceRepository references;

    setUp(() {
      originalExercises = RepositoryRegistry.exerciseRepository;
      originalWorkouts = RepositoryRegistry.workoutExerciseRepository;
      originalReferences =
          RepositoryRegistry.workoutGroupWorkoutReferenceRepository;
      exercises = InMemoryExerciseRepository();
      workouts = InMemoryWorkoutExerciseRepository();
      references = InMemoryWorkoutGroupWorkoutReferenceRepository();
      RepositoryRegistry.exerciseRepository = exercises;
      RepositoryRegistry.workoutExerciseRepository = workouts;
      RepositoryRegistry.workoutGroupWorkoutReferenceRepository = references;
    });

    tearDown(() {
      RepositoryRegistry.exerciseRepository = originalExercises as dynamic;
      RepositoryRegistry.workoutExerciseRepository =
          originalWorkouts as dynamic;
      RepositoryRegistry.workoutGroupWorkoutReferenceRepository =
          originalReferences as dynamic;
    });

    testWidgets(
      'shows Library attachments immediately after the picker returns',
      (tester) async {
        await exercises.saveExercise(
          _exercise(id: 'exercise-library', name: 'Library Curl'),
        );
        await workouts.saveWorkoutExercise(
          _workout(id: 'workout-library', exerciseId: 'exercise-library'),
        );

        await _pumpSession(tester);

        await tester.tap(find.text('ADD FROM WORKOUT LIBRARY'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(CheckboxListTile, 'Library Curl'));
        await tester.pump();
        await tester.tap(find.text('ADD SELECTED WORKOUTS'));
        await tester.pumpAndSettle();

        expect(find.text('Library Curl'), findsOneWidget);
        expect(await references.getReferences('session-1'), hasLength(1));
      },
    );

    testWidgets(
      'shows a free-created workout immediately after the builder returns',
      (tester) async {
        await _pumpSession(tester);

        await tester.tap(find.text('CREATE NEW WORKOUT'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextField).first,
          'Evening Mobility',
        );
        await tester.tap(find.text('NEXT: DEFINE EXERCISE'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('NEXT: CONFIGURE'),
          180,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('NEXT: CONFIGURE'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('SAVE WORKOUT'));
        await tester.pumpAndSettle();

        expect(find.text('Evening Mobility'), findsOneWidget);
        expect(await workouts.getAllWorkoutExercises(), hasLength(1));
        expect(await references.getReferences('session-1'), hasLength(1));
      },
    );

    testWidgets('cancelling the Library picker leaves the Session unchanged', (
      tester,
    ) async {
      await exercises.saveExercise(
        _exercise(id: 'exercise-library', name: 'Library Curl'),
      );
      await workouts.saveWorkoutExercise(
        _workout(id: 'workout-library', exerciseId: 'exercise-library'),
      );
      await _pumpSession(tester);

      await tester.tap(find.text('ADD FROM WORKOUT LIBRARY'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('SESSION READY'), findsOneWidget);
      expect(find.text('Library Curl'), findsNothing);
      expect(await references.getReferences('session-1'), isEmpty);
    });
  });
}

Future<void> _pumpSession(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: WorkoutGroupWorkoutsScreen(
        workoutGroupId: 'session-1',
        workoutGroupName: 'Morning',
      ),
    ),
  );
  await tester.pumpAndSettle();
}

WorkoutExercise _workout({required String id, required String exerciseId}) {
  return WorkoutExercise(
    id: id,
    exerciseId: exerciseId,
    displayOrder: 0,
    targetType: WorkoutTargetType.repetitions,
    sets: 3,
    repetitions: 10,
    restInSeconds: 15,
  );
}

Exercise _exercise({required String id, required String name}) {
  return Exercise(
    id: id,
    name: name,
    description: '',
    instructions: '',
    muscleGroup: MuscleGroup.fullBody,
    equipment: EquipmentType.bodyweight,
    difficulty: DifficultyLevel.beginner,
    isCustom: true,
  );
}
