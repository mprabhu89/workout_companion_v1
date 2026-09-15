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
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/ritmo_builtin_workouts.dart';
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
    await _saveExercise(
      const Exercise(
        id: 'library-exercise',
        name: 'Library Workout',
        description: 'A controlled custom workout',
        instructions: '',
        muscleGroup: MuscleGroup.biceps,
        equipment: EquipmentType.dumbbell,
        difficulty: DifficultyLevel.beginner,
        isCustom: true,
      ),
    );
    await _saveExercise(
      const Exercise(
        id: 'duration-exercise',
        name: 'Timed Hold',
        description: 'A duration workout',
        instructions: '',
        muscleGroup: MuscleGroup.core,
        equipment: EquipmentType.bodyweight,
        difficulty: DifficultyLevel.beginner,
        isCustom: true,
      ),
    );
    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      const WorkoutExercise(
        id: 'library-workout',
        workoutGroupId: null,
        exerciseId: 'library-exercise',
        displayOrder: 0,
        sets: 3,
        targetType: WorkoutTargetType.repetitions,
        repetitions: 10,
        restInSeconds: 15,
      ),
    );
    await RepositoryRegistry.workoutExerciseRepository.saveWorkoutExercise(
      const WorkoutExercise(
        id: 'duration-workout',
        workoutGroupId: null,
        exerciseId: 'duration-exercise',
        displayOrder: 1,
        targetType: WorkoutTargetType.duration,
        durationInSeconds: 45,
      ),
    );
  });

  tearDown(() {
    RepositoryRegistry.exerciseRepository = originalExerciseRepository;
    RepositoryRegistry.workoutExerciseRepository =
        originalWorkoutExerciseRepository;
  });

  testWidgets(
    'renders the Training Arsenal header, real count, filters, and metadata',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: WorkoutLibraryScreen()));
      await tester.pumpAndSettle();

      expect(find.text('WORKOUT LIBRARY'), findsOneWidget);
      expect(find.text('TRAINING ARSENAL'), findsOneWidget);
      expect(find.text('2 WORKOUTS AVAILABLE'), findsOneWidget);
      expect(find.text('ALL'), findsOneWidget);
      expect(find.text('RITMO'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('workout-library-filter-CUSTOM')),
        findsOneWidget,
      );
      expect(find.text('RECENT'), findsNothing);
      expect(find.text('3 SETS'), findsOneWidget);
      expect(find.text('10 REPS'), findsOneWidget);
      expect(find.text('15s REST'), findsOneWidget);
      expect(find.text('45s DURATION'), findsOneWidget);
    },
  );

  testWidgets(
    'search and Custom filter keep using the active canonical library data',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: WorkoutLibraryScreen()));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('workout-library-filter-CUSTOM')),
      );
      await tester.pumpAndSettle();
      expect(find.text('2 WORKOUTS AVAILABLE'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hold');
      await tester.pumpAndSettle();
      expect(find.text('Timed Hold'), findsOneWidget);
      expect(find.text('Library Workout'), findsNothing);
      expect(find.text('1 WORKOUT AVAILABLE'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'missing');
      await tester.pumpAndSettle();
      expect(find.text('NO MATCH FOUND'), findsOneWidget);
      expect(find.text('Try another workout name.'), findsOneWidget);
    },
  );

  testWidgets(
    'RITMO filter retains the protected sample badge and hides custom workouts',
    (tester) async {
      RepositoryRegistry.workoutExerciseRepository = _SampleWorkoutRepository();

      await tester.pumpWidget(const MaterialApp(home: WorkoutLibraryScreen()));
      await tester.pumpAndSettle();

      expect(find.text('RITMO SAMPLE'), findsOneWidget);
      await tester.tap(find.text('RITMO'));
      await tester.pumpAndSettle();
      expect(find.text('1 WORKOUT AVAILABLE'), findsOneWidget);
      expect(find.text('RITMO SAMPLE'), findsOneWidget);

      await tester.tap(find.text('Unknown workout'));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(find.text('RITMO Sample Workout'), findsOneWidget);
      expect(
        find.text('This RITMO-provided workout is read-only.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('narrow portrait layout renders without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: WorkoutLibraryScreen()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('+ CREATE WORKOUT'), findsOneWidget);
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

    expect(find.text('Export Workout JSON'), findsNothing);
    expect(find.byTooltip('Export Debug JSON'), findsNothing);
  });

  testWidgets('authorized debug access exposes the JSON export action', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutLibraryScreen(
          exportPermission: _AllowedExportPermission(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Workout actions').first);
    await tester.pumpAndSettle();

    expect(find.text('Export Workout JSON'), findsOneWidget);
  });

  testWidgets('create workout keeps the existing free-creation route', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WorkoutLibraryScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('+ CREATE WORKOUT'));
    await tester.pumpAndSettle();

    expect(find.text('Name Your Workout'), findsOneWidget);
    expect(find.text('Next: Define Exercise'), findsOneWidget);
  });
}

Future<void> _saveExercise(Exercise exercise) =>
    RepositoryRegistry.exerciseRepository.saveExercise(exercise);

class _SampleWorkoutRepository implements WorkoutExerciseRepository {
  final WorkoutExercise _sample =
      RitmoBuiltinWorkouts.oneStepBicepCurlWorkout();

  @override
  Future<void> deleteWorkoutExercise(String id) async {}

  @override
  Future<List<WorkoutExercise>> getAllWorkoutExercises() async => [_sample];

  @override
  Future<int> getNextDisplayOrder(String workoutGroupId) async => 1;

  @override
  Future<WorkoutExercise?> getWorkoutExerciseById(String id) async =>
      id == _sample.id ? _sample : null;

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(
    String workoutGroupId,
  ) async => const [];

  @override
  Future<bool> isDisplayOrderInUse({
    required String workoutGroupId,
    required int displayOrder,
    String? excludingWorkoutExerciseId,
  }) async => false;

  @override
  Future<void> saveWorkoutExercise(WorkoutExercise workoutExercise) async {}
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
