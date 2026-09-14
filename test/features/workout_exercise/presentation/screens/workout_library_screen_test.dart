import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import 'package:workout_companion_v1/core/services/workout_export_permission.dart';
import 'package:workout_companion_v1/features/exercise/data/repositories/in_memory_exercise_repository.dart';
import 'package:workout_companion_v1/features/exercise/domain/entities/exercise.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/difficulty_level.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/equipment_type.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/muscle_group.dart';
import 'package:workout_companion_v1/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/repositories/workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/presentation/screens/workout_library_screen.dart';

void main() {
  late ExerciseRepository originalExerciseRepository;
  late WorkoutExerciseRepository originalWorkoutExerciseRepository;

  setUp(() async {
    originalExerciseRepository = RepositoryRegistry.exerciseRepository;
    originalWorkoutExerciseRepository =
        RepositoryRegistry.workoutExerciseRepository;
    RepositoryRegistry.exerciseRepository = InMemoryExerciseRepository();
    RepositoryRegistry.workoutExerciseRepository =
        InMemoryWorkoutExerciseRepository();
    await RepositoryRegistry.exerciseRepository.saveExercise(
      const Exercise(
        id: 'library-exercise',
        name: 'Library Workout',
        description: '',
        instructions: '',
        muscleGroup: MuscleGroup.biceps,
        equipment: EquipmentType.dumbbell,
        difficulty: DifficultyLevel.beginner,
        isCustom: true,
      ),
    );
    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      WorkoutExercise(
        id: 'library-workout',
        workoutGroupId: null,
        exerciseId: 'library-exercise',
        displayOrder: 0,
        targetType: WorkoutTargetType.repetitions,
      ),
    );
  });

  tearDown(() {
    RepositoryRegistry.exerciseRepository = originalExerciseRepository;
    RepositoryRegistry.workoutExerciseRepository = originalWorkoutExerciseRepository;
  });

  testWidgets('normal users cannot see the workout JSON export action', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutLibraryScreen(exportPermission: _DeniedExportPermission()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Workout actions'), findsNothing);
    expect(find.text('Export Workout JSON'), findsNothing);
    expect(find.byTooltip('Export Debug JSON'), findsNothing);
  });

  testWidgets('authorized debug access exposes the JSON export action', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutLibraryScreen(exportPermission: _AllowedExportPermission()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Workout actions'));
    await tester.pumpAndSettle();

    expect(find.text('Export Workout JSON'), findsOneWidget);
  });
}

class _AllowedExportPermission implements WorkoutExportPermission {
  const _AllowedExportPermission();

  @override
  bool get canExportWorkoutJson => true;
}

class _DeniedExportPermission implements WorkoutExportPermission {
  const _DeniedExportPermission();

  @override
  bool get canExportWorkoutJson => false;
}
