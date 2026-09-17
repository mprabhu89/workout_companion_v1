import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/widgets/ritmo_hud_widgets.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/exercise/data/repositories/in_memory_exercise_repository.dart';
import 'package:workout_companion_v1/features/exercise/domain/entities/exercise.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/difficulty_level.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/equipment_type.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/muscle_group.dart';
import 'package:workout_companion_v1/features/workout_day/data/repositories/in_memory_workout_day_repository.dart';
import 'package:workout_companion_v1/features/workout_day/domain/entities/workout_day.dart';
import 'package:workout_companion_v1/features/workout_day/presentation/screens/workout_day_library_screen.dart';
import 'package:workout_companion_v1/features/workout_day/presentation/screens/workout_day_overview_screen.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_group/data/repositories/in_memory_workout_group_repository.dart';
import 'package:workout_companion_v1/features/workout_group/domain/entities/workout_group.dart';
import 'package:workout_companion_v1/features/workout_group_workout_reference/data/repositories/in_memory_workout_group_workout_reference_repository.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_history/domain/repositories/workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_plan/data/repositories/in_memory_workout_plan_repository.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/entities/workout_plan.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_difficulty.dart';
import 'package:workout_companion_v1/features/workout_plan/presentation/screens/workout_plan_library_screen.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/screens/workout_execution_screen.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/services/workout_day_training_launcher.dart';

void main() {
  group('Workout plan start flow', () {
    testWidgets(
      'selecting a workout plan displays only its workout days in order and excludes archived days',
      (tester) async {
        final planRepository = InMemoryWorkoutPlanRepository();
        final dayRepository = InMemoryWorkoutDayRepository();

        await planRepository.saveWorkoutPlan(
          _plan(
            id: 'plan-a',
            name: 'Alpha Plan',
            description: 'Alpha description',
          ),
        );
        await planRepository.saveWorkoutPlan(
          _plan(
            id: 'plan-b',
            name: 'Beta Plan',
            description: 'Beta description',
          ),
        );

        await dayRepository.saveWorkoutDay(
          _day(
            id: 'day-2',
            workoutPlanId: 'plan-a',
            dayNumber: 2,
            name: 'Day Two',
          ),
        );
        await dayRepository.saveWorkoutDay(
          _day(
            id: 'day-1',
            workoutPlanId: 'plan-a',
            dayNumber: 1,
            name: 'Day One',
          ),
        );
        await dayRepository.saveWorkoutDay(
          _day(
            id: 'day-archived',
            workoutPlanId: 'plan-a',
            dayNumber: 3,
            name: 'Archived Day',
            isArchived: true,
          ),
        );
        await dayRepository.saveWorkoutDay(
          _day(
            id: 'day-other',
            workoutPlanId: 'plan-b',
            dayNumber: 1,
            name: 'Other Plan Day',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WorkoutPlanLibraryScreen(
              repository: planRepository,
              workoutDayScreenBuilder: (plan) => WorkoutDayLibraryScreen(
                workoutPlanId: plan.id,
                workoutPlanName: plan.name,
                workoutPlanDescription: plan.description,
                repository: dayRepository,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Alpha Plan'));
        await tester.pumpAndSettle();

        expect(find.text('Alpha description'), findsOneWidget);
        expect(find.text('Day One'), findsOneWidget);
        expect(find.text('Day Two'), findsOneWidget);
        expect(find.text('Other Plan Day'), findsNothing);
        expect(find.text('Archived Day'), findsNothing);

        expect(
          tester.getTopLeft(find.text('Day One')).dy,
          lessThan(tester.getTopLeft(find.text('Day Two')).dy),
        );
      },
    );

    testWidgets(
      'selecting a non-rest workout day opens the workout-day overview',
      (tester) async {
        final dayRepository = InMemoryWorkoutDayRepository();
        await dayRepository.saveWorkoutDay(
          _day(
            id: 'day-1',
            workoutPlanId: 'plan-1',
            dayNumber: 1,
            name: 'Push Day',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WorkoutDayLibraryScreen(
              workoutPlanId: 'plan-1',
              workoutPlanName: 'Plan',
              repository: dayRepository,
              workoutDayOverviewScreenBuilder: (day) =>
                  Scaffold(body: Text('Overview ${day.name}')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Push Day'));
        await tester.pumpAndSettle();

        expect(find.text('Overview Push Day'), findsOneWidget);
      },
    );

    testWidgets('rest day is displayed correctly and cannot start execution', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutDayOverviewScreen(
            workoutPlanId: 'plan-1',
            workoutPlanName: 'Plan',
            workoutDay: _day(
              id: 'rest-day',
              workoutPlanId: 'plan-1',
              dayNumber: 2,
              name: 'Recovery',
              description: 'Mobility and recovery',
              isRestDay: true,
            ),
            workoutGroupRepository: InMemoryWorkoutGroupRepository(),
            workoutExerciseRepository: InMemoryWorkoutExerciseRepository(),
            exerciseRepository: InMemoryExerciseRepository(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('REST DAY'), findsWidgets);
      expect(find.text('START WORKOUT'), findsNothing);
      expect(find.text('START TRAINING'), findsNothing);
    });

    testWidgets(
      'day overview manages existing WorkoutGroups as named Sessions',
      (tester) async {
        final groupRepository = InMemoryWorkoutGroupRepository();
        final referenceRepository =
            InMemoryWorkoutGroupWorkoutReferenceRepository();
        final workoutExerciseRepository = InMemoryWorkoutExerciseRepository();
        final exerciseRepository = InMemoryExerciseRepository();
        final day = _day(
          id: 'day-sessions',
          workoutPlanId: 'plan-1',
          dayNumber: 1,
          name: 'Training Day',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WorkoutDayOverviewScreen(
              workoutPlanId: 'plan-1',
              workoutPlanName: 'Plan',
              workoutDay: day,
              workoutGroupRepository: groupRepository,
              workoutExerciseRepository: workoutExerciseRepository,
              referenceRepository: referenceRepository,
              exerciseRepository: exerciseRepository,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('SESSIONS'), findsOneWidget);
        expect(find.text('NO SESSIONS YET'), findsOneWidget);
        expect(find.text('ADD SESSION'), findsOneWidget);
        expect(find.text('START TRAINING'), findsNothing);

        await tester.tap(find.text('ADD SESSION'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).first, 'Morning');
        await tester.tap(find.byType(RitmoActionButton));
        await tester.pumpAndSettle();

        expect(find.text('SESSION 01'), findsOneWidget);
        expect(find.text('Morning'), findsOneWidget);
        expect(await groupRepository.getWorkoutGroups(day.id), hasLength(1));

        await tester.tap(find.byTooltip('Session actions'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit Session'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).first, 'Evening');
        await tester.tap(find.byType(RitmoActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Evening'), findsOneWidget);
        await tester.tap(find.byTooltip('Session actions'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete Session').first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Delete Session'));
        await tester.pumpAndSettle();

        expect(find.text('NO SESSIONS YET'), findsOneWidget);
        expect(await groupRepository.getWorkoutGroups(day.id), isEmpty);
      },
    );

    testWidgets(
      'day overview displays ordered workout groups and exercises under the correct groups',
      (tester) async {
        final groupRepository = InMemoryWorkoutGroupRepository();
        final workoutExerciseRepository = InMemoryWorkoutExerciseRepository();
        final exerciseRepository = InMemoryExerciseRepository();

        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-1', name: 'Bench Press'),
        );
        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-2', name: 'Push Up'),
        );
        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-3', name: 'Squat'),
        );

        await groupRepository.saveWorkoutGroup(
          const WorkoutGroup(
            id: 'group-2',
            workoutDayId: 'day-1',
            name: 'Second Group',
            displayOrder: 2,
          ),
        );
        await groupRepository.saveWorkoutGroup(
          const WorkoutGroup(
            id: 'group-1',
            workoutDayId: 'day-1',
            name: 'First Group',
            displayOrder: 1,
          ),
        );

        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'exercise-link-2',
            workoutGroupId: 'group-1',
            exerciseId: 'exercise-2',
            displayOrder: 2,
            sessionRepetitions: 3,
          ),
        );
        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'exercise-link-1',
            workoutGroupId: 'group-1',
            exerciseId: 'exercise-1',
            displayOrder: 1,
          ),
        );
        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'exercise-link-3',
            workoutGroupId: 'group-2',
            exerciseId: 'exercise-3',
            displayOrder: 1,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WorkoutDayOverviewScreen(
              workoutPlanId: 'plan-1',
              workoutPlanName: 'Plan',
              workoutDay: _day(
                id: 'day-1',
                workoutPlanId: 'plan-1',
                dayNumber: 1,
                name: 'Push Day',
              ),
              workoutGroupRepository: groupRepository,
              workoutExerciseRepository: workoutExerciseRepository,
              exerciseRepository: exerciseRepository,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('First Group'), findsOneWidget);
        expect(find.text('Bench Press'), findsOneWidget);
        expect(find.text('Push Up'), findsOneWidget);
        await tester.scrollUntilVisible(find.text('Second Group'), 180);
        expect(find.text('Second Group'), findsOneWidget);
        expect(find.text('Squat'), findsOneWidget);
      },
    );

    testWidgets('empty non-rest day shows the authoring empty state', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutDayOverviewScreen(
            workoutPlanId: 'plan-1',
            workoutPlanName: 'Plan',
            workoutDay: _day(
              id: 'empty-day',
              workoutPlanId: 'plan-1',
              dayNumber: 1,
              name: 'Empty Day',
            ),
            workoutGroupRepository: InMemoryWorkoutGroupRepository(),
            workoutExerciseRepository: InMemoryWorkoutExerciseRepository(),
            exerciseRepository: InMemoryExerciseRepository(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('NO SESSIONS YET'), findsOneWidget);
      expect(find.text('START THIS TRAINING DAY'), findsNothing);
    });

    testWidgets(
      'day overview remains structural authoring and cannot launch training',
      (tester) async {
        final groupRepository = InMemoryWorkoutGroupRepository();
        final workoutExerciseRepository = InMemoryWorkoutExerciseRepository();
        final exerciseRepository = InMemoryExerciseRepository();

        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-1', name: 'Bench Press'),
        );
        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-2', name: 'Push Up'),
        );

        await groupRepository.saveWorkoutGroup(
          const WorkoutGroup(
            id: 'group-1',
            workoutDayId: 'day-1',
            name: 'Main Group',
            displayOrder: 1,
          ),
        );
        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'link-2',
            workoutGroupId: 'group-1',
            exerciseId: 'exercise-2',
            displayOrder: 2,
          ),
        );
        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'link-1',
            workoutGroupId: 'group-1',
            exerciseId: 'exercise-1',
            displayOrder: 1,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: WorkoutDayOverviewScreen(
              workoutPlanId: 'plan-1',
              workoutPlanName: 'Power Plan',
              workoutDay: _day(
                id: 'day-1',
                workoutPlanId: 'plan-1',
                dayNumber: 1,
                name: 'Push Day',
              ),
              workoutGroupRepository: groupRepository,
              workoutExerciseRepository: workoutExerciseRepository,
              exerciseRepository: exerciseRepository,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Main Group'), findsOneWidget);
        expect(find.text('START THIS TRAINING DAY'), findsNothing);
        expect(find.text('START TRAINING'), findsNothing);
      },
    );

    testWidgets(
      'shared training launcher uses existing execution and completion history behavior',
      (tester) async {
        final groupRepository = InMemoryWorkoutGroupRepository();
        final workoutExerciseRepository = InMemoryWorkoutExerciseRepository();
        final exerciseRepository = InMemoryExerciseRepository();
        final historyRepository = _FakeWorkoutHistoryRepository();
        final speechEngine = _FakeSpeechEngine();

        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-1', name: 'Sequence One'),
        );
        await exerciseRepository.saveExercise(
          _exercise(id: 'exercise-2', name: 'Sequence Two'),
        );

        await groupRepository.saveWorkoutGroup(
          const WorkoutGroup(
            id: 'group-1',
            workoutDayId: 'day-1',
            name: 'Main Group',
            displayOrder: 1,
          ),
        );
        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'link-1',
            workoutGroupId: 'group-1',
            exerciseId: 'exercise-1',
            displayOrder: 1,
            sessionRepetitions: 2,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [WorkoutSequenceStep.end()],
            ),
          ),
        );
        await workoutExerciseRepository.saveWorkoutExercise(
          _workoutExercise(
            id: 'link-2',
            workoutGroupId: 'group-1',
            exerciseId: 'exercise-2',
            displayOrder: 2,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [WorkoutSequenceStep.end()],
            ),
          ),
        );

        final launcher = WorkoutDayTrainingLauncher(
          workoutGroupRepository: groupRepository,
          workoutExerciseRepository: workoutExerciseRepository,
          executionScreenBuilder: (session) => WorkoutExecutionScreen(
            session: session,
            voiceCoach: VoiceCoachService(speechEngine: speechEngine),
            workoutHistoryRepository: historyRepository,
          ),
        );
        final day = _day(
          id: 'day-1',
          workoutPlanId: 'plan-1',
          dayNumber: 1,
          name: 'Push Day',
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => FilledButton(
                onPressed: () => launcher.launch(
                  context: context,
                  workoutPlanId: 'plan-1',
                  workoutPlanName: 'Power Plan',
                  workoutDay: day,
                ),
                child: const Text('START TRAINING'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('START TRAINING'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('START'));
        await tester.pump();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('Workout Complete'), findsOneWidget);
        expect(historyRepository.savedSessions, hasLength(1));
        expect(historyRepository.savedSessions.single.workoutPlanId, 'plan-1');
        expect(
          historyRepository.savedSessions.single.workoutPlanName,
          'Power Plan',
        );
        expect(historyRepository.savedSessions.single.workoutDayId, 'day-1');
        expect(
          historyRepository.savedSessions.single.workoutDayName,
          'Push Day',
        );
        expect(historyRepository.savedSessions.single.completedExercises, 2);
        expect(historyRepository.savedSessions.single.totalExercises, 2);
        expect(
          speechEngine.spokenMessages
              .where((message) => message == 'End of exercise.')
              .length,
          3,
        );

        await tester.tap(find.text('Back to Day Overview'));
        await tester.pumpAndSettle();

        expect(find.text('START TRAINING'), findsOneWidget);
        expect(historyRepository.savedSessions, hasLength(1));
      },
    );

    testWidgets('rest day overview has no execution action', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutDayOverviewScreen(
            workoutPlanId: 'plan-1',
            workoutPlanName: 'Plan',
            workoutDay: _day(
              id: 'rest-day',
              workoutPlanId: 'plan-1',
              dayNumber: 2,
              name: 'Recovery',
              isRestDay: true,
            ),
            workoutGroupRepository: InMemoryWorkoutGroupRepository(),
            workoutExerciseRepository: InMemoryWorkoutExerciseRepository(),
            exerciseRepository: InMemoryExerciseRepository(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('REST DAY'), findsOneWidget);
      expect(find.text('START THIS TRAINING DAY'), findsNothing);
    });
  });
}

WorkoutPlan _plan({
  required String id,
  required String name,
  required String description,
}) {
  return WorkoutPlan(
    id: id,
    name: name,
    description: description,
    category: WorkoutPlanCategory.generalFitness,
    difficulty: WorkoutPlanDifficulty.beginner,
    estimatedDurationInMinutes: 30,
  );
}

WorkoutDay _day({
  required String id,
  required String workoutPlanId,
  required int dayNumber,
  required String name,
  String description = '',
  bool isRestDay = false,
  bool isArchived = false,
}) {
  return WorkoutDay(
    id: id,
    workoutPlanId: workoutPlanId,
    dayNumber: dayNumber,
    name: name,
    description: description,
    isRestDay: isRestDay,
    isArchived: isArchived,
  );
}

WorkoutExercise _workoutExercise({
  required String id,
  required String workoutGroupId,
  required String exerciseId,
  required int displayOrder,
  int sessionRepetitions = 1,
  WorkoutSequenceDefinition? sequenceDefinition,
}) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: workoutGroupId,
    exerciseId: exerciseId,
    displayOrder: displayOrder,
    sets: 3,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 10,
    restInSeconds: 0,
    sessionRepetitions: sessionRepetitions,
    sequenceDefinition: sequenceDefinition,
  );
}

Exercise _exercise({required String id, required String name}) {
  return Exercise(
    id: id,
    name: name,
    description: '$name description',
    instructions: '$name instructions',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.bodyweight,
    difficulty: DifficultyLevel.beginner,
  );
}

class _FakeSpeechEngine implements SpeechEngine {
  final List<String> spokenMessages = [];

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> setPitch(double pitch) async {}

  @override
  Future<void> setSpeechRate(double rate) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> speak(String text) async {
    spokenMessages.add(text);
  }

  @override
  Future<void> stop() async {}
}

class _FakeWorkoutHistoryRepository implements WorkoutHistoryRepository {
  final List<CompletedWorkoutSession> savedSessions = [];

  @override
  Future<void> deleteSession(String sessionId) async {}

  @override
  Future<List<CompletedWorkoutSession>> getCompletedSessions() async {
    return List.unmodifiable(savedSessions);
  }

  @override
  Future<CompletedWorkoutSession?> getSessionById(String sessionId) async {
    try {
      return savedSessions.firstWhere((session) => session.id == sessionId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveSession(CompletedWorkoutSession session) async {
    savedSessions.add(session);
  }
}
