import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/exercise/data/repositories/in_memory_exercise_repository.dart';
import 'package:workout_companion_v1/features/exercise/domain/entities/exercise.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/difficulty_level.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/equipment_type.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/muscle_group.dart';
import 'package:workout_companion_v1/features/workout_day/data/repositories/in_memory_workout_day_repository.dart';
import 'package:workout_companion_v1/features/workout_day/domain/entities/workout_day.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_group/data/repositories/in_memory_workout_group_repository.dart';
import 'package:workout_companion_v1/features/workout_group/domain/entities/workout_group.dart';
import 'package:workout_companion_v1/features/workout_group_workout_reference/data/repositories/in_memory_workout_group_workout_reference_repository.dart';
import 'package:workout_companion_v1/features/workout_group_workout_reference/domain/entities/workout_group_workout_reference.dart';
import 'package:workout_companion_v1/features/workout_plan/data/repositories/in_memory_workout_plan_repository.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/entities/workout_plan.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_difficulty.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/screens/start_training_screen.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/services/workout_day_training_launcher.dart';

void main() {
  testWidgets(
    'Training Terminal is read-only, preserves reference order, and launches the selected day',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final setup = await _TrainingSetup.create();
      final launcher = WorkoutDayTrainingLauncher(
        workoutGroupRepository: setup.groupRepository,
        workoutExerciseRepository: setup.workoutExerciseRepository,
        referenceRepository: setup.referenceRepository,
        executionScreenBuilder: (session) =>
            _SessionCaptureScreen(session: session),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StartTrainingScreen(
            workoutPlanRepository: setup.planRepository,
            workoutDayRepository: setup.dayRepository,
            workoutGroupRepository: setup.groupRepository,
            workoutExerciseRepository: setup.workoutExerciseRepository,
            referenceRepository: setup.referenceRepository,
            exerciseRepository: setup.exerciseRepository,
            trainingLauncher: launcher,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('START TRAINING'), findsWidgets);
      expect(find.text('TRAINING TERMINAL'), findsOneWidget);
      expect(find.text('TRAINING BRIEFING'), findsOneWidget);
      expect(find.text('SESSIONS'), findsOneWidget);
      expect(find.text('SESSION 01'), findsOneWidget);
      expect(find.text('Warm Up'), findsOneWidget);
      expect(find.text('Main Block'), findsOneWidget);
      expect(
        tester.getTopLeft(find.textContaining('First Workout')).dy,
        lessThan(tester.getTopLeft(find.textContaining('Second Workout')).dy),
      );
      expect(find.text('CREATE PLAN'), findsNothing);
      expect(find.text('CREATE DAY'), findsNothing);
      expect(find.text('ADD SESSION'), findsNothing);
      expect(find.text('ADD FROM WORKOUT LIBRARY'), findsNothing);

      await tester.tap(find.byKey(const Key('start-training-launch')));
      await tester.pumpAndSettle();

      expect(find.text('plan:plan-1'), findsOneWidget);
      expect(find.text('day:day-1'), findsOneWidget);
      expect(find.text('order:exercise-1,exercise-2'), findsOneWidget);
    },
  );

  testWidgets(
    'Training Terminal renders no-program, no-day, and rest-day states',
    (tester) async {
      final emptyPlans = InMemoryWorkoutPlanRepository();
      final dayRepository = InMemoryWorkoutDayRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: StartTrainingScreen(
            key: const ValueKey('no-programs'),
            workoutPlanRepository: emptyPlans,
            workoutDayRepository: dayRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('NO TRAINING PROGRAMS AVAILABLE'), findsOneWidget);

      final planRepository = InMemoryWorkoutPlanRepository();
      await planRepository.saveWorkoutPlan(_plan());
      await tester.pumpWidget(
        MaterialApp(
          home: StartTrainingScreen(
            key: const ValueKey('no-days'),
            workoutPlanRepository: planRepository,
            workoutDayRepository: dayRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('NO TRAINING DAYS AVAILABLE'), findsOneWidget);

      await dayRepository.saveWorkoutDay(
        const WorkoutDay(
          id: 'rest-day',
          workoutPlanId: 'plan-1',
          dayNumber: 1,
          name: 'Recovery',
          description: '',
          isRestDay: true,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: StartTrainingScreen(
            key: const ValueKey('rest-day'),
            workoutPlanRepository: planRepository,
            workoutDayRepository: dayRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('REST DAY'), findsOneWidget);
      expect(find.text('TRAINING NOT READY'), findsNothing);
    },
  );
}

class _TrainingSetup {
  _TrainingSetup({
    required this.planRepository,
    required this.dayRepository,
    required this.groupRepository,
    required this.workoutExerciseRepository,
    required this.referenceRepository,
    required this.exerciseRepository,
  });

  final InMemoryWorkoutPlanRepository planRepository;
  final InMemoryWorkoutDayRepository dayRepository;
  final InMemoryWorkoutGroupRepository groupRepository;
  final InMemoryWorkoutExerciseRepository workoutExerciseRepository;
  final InMemoryWorkoutGroupWorkoutReferenceRepository referenceRepository;
  final InMemoryExerciseRepository exerciseRepository;

  static Future<_TrainingSetup> create() async {
    final setup = _TrainingSetup(
      planRepository: InMemoryWorkoutPlanRepository(),
      dayRepository: InMemoryWorkoutDayRepository(),
      groupRepository: InMemoryWorkoutGroupRepository(),
      workoutExerciseRepository: InMemoryWorkoutExerciseRepository(),
      referenceRepository: InMemoryWorkoutGroupWorkoutReferenceRepository(),
      exerciseRepository: InMemoryExerciseRepository(),
    );
    await setup.planRepository.saveWorkoutPlan(_plan());
    await setup.dayRepository.saveWorkoutDay(
      const WorkoutDay(
        id: 'day-1',
        workoutPlanId: 'plan-1',
        dayNumber: 1,
        name: 'Push Day',
        description: '',
      ),
    );
    await setup.groupRepository.saveWorkoutGroup(
      const WorkoutGroup(
        id: 'group-main',
        workoutDayId: 'day-1',
        name: 'Main Block',
        displayOrder: 2,
      ),
    );
    await setup.groupRepository.saveWorkoutGroup(
      const WorkoutGroup(
        id: 'group-warmup',
        workoutDayId: 'day-1',
        name: 'Warm Up',
        displayOrder: 1,
      ),
    );
    await setup.exerciseRepository.saveExercise(
      _exercise('exercise-1', 'First Workout'),
    );
    await setup.exerciseRepository.saveExercise(
      _exercise('exercise-2', 'Second Workout'),
    );
    await setup.workoutExerciseRepository.saveWorkoutExercise(
      _workout('workout-1', 'exercise-1'),
    );
    await setup.workoutExerciseRepository.saveWorkoutExercise(
      _workout('workout-2', 'exercise-2'),
    );
    await setup.referenceRepository.saveReference(
      const WorkoutGroupWorkoutReference(
        id: 'reference-2',
        workoutGroupId: 'group-main',
        workoutExerciseId: 'workout-2',
        displayOrder: 1,
      ),
    );
    await setup.referenceRepository.saveReference(
      const WorkoutGroupWorkoutReference(
        id: 'reference-1',
        workoutGroupId: 'group-warmup',
        workoutExerciseId: 'workout-1',
        displayOrder: 1,
      ),
    );
    return setup;
  }
}

WorkoutPlan _plan() {
  return const WorkoutPlan(
    id: 'plan-1',
    name: 'Strength Program',
    description: '',
    category: WorkoutPlanCategory.generalFitness,
    difficulty: WorkoutPlanDifficulty.beginner,
    estimatedDurationInMinutes: 30,
  );
}

Exercise _exercise(String id, String name) {
  return Exercise(
    id: id,
    name: name,
    description: '',
    instructions: '',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.bodyweight,
    difficulty: DifficultyLevel.beginner,
  );
}

WorkoutExercise _workout(String id, String exerciseId) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: null,
    exerciseId: exerciseId,
    displayOrder: 0,
    sets: 3,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 10,
    restInSeconds: 15,
    sessionRepetitions: 1,
  );
}

class _SessionCaptureScreen extends StatelessWidget {
  const _SessionCaptureScreen({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('plan:${session.workoutPlanId}'),
          Text('day:${session.workoutDayId}'),
          Text(
            'order:${session.workoutExercises.map((workout) => workout.exerciseId).join(',')}',
          ),
        ],
      ),
    );
  }
}
