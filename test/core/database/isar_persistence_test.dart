import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:workout_companion_v1/core/database/isar_database.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/progress/domain/services/workout_progress_service.dart';
import 'package:workout_companion_v1/features/workout_day/data/repositories/isar_workout_day_repository.dart';
import 'package:workout_companion_v1/features/workout_day/domain/entities/workout_day.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/isar_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/tempo_type.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/weight_unit.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_group/data/repositories/isar_workout_group_repository.dart';
import 'package:workout_companion_v1/features/workout_group/domain/entities/workout_group.dart';
import 'package:workout_companion_v1/features/workout_history/data/repositories/isar_workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_plan/data/repositories/isar_workout_plan_repository.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/entities/workout_plan.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_difficulty.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_sequence_event.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_sequence_executor.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_session_builder.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/controllers/workout_session_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Isar persistence', () {
    _PersistenceHarness? testHarness;

    setUpAll(() async {
      await _initializeIsarCoreForTests();
    });

    setUp(() async {
      testHarness = await _PersistenceHarness.create();
    });

    tearDown(() async {
      await testHarness?.dispose();
      testHarness = null;
    });

    test(
      'workout plans survive reopen and updates persist',
      () async {
        final harness = testHarness!;

        await harness.planRepository.saveWorkoutPlan(
          _workoutPlan(
            id: 'plan-1',
            name: 'Strength Plan',
          ),
        );
        await harness.reopen();

        final savedPlan = await harness.planRepository
            .getWorkoutPlanById('plan-1');

        expect(savedPlan, isNotNull);
        expect(savedPlan!.id, 'plan-1');
        expect(savedPlan.name, 'Strength Plan');
        expect(
          savedPlan.estimatedDurationInMinutes,
          45,
        );
        expect(savedPlan.isArchived, isFalse);

        await harness.planRepository.saveWorkoutPlan(
          savedPlan.copyWith(
            name: 'Updated Strength Plan',
            description: 'Updated description',
          ),
        );
        await harness.reopen();

        final updatedPlan = await harness.planRepository
            .getWorkoutPlanById('plan-1');
        final allPlans =
            await harness.planRepository.getAllWorkoutPlans();

        expect(updatedPlan, isNotNull);
        expect(
          updatedPlan!.name,
          'Updated Strength Plan',
        );
        expect(
          updatedPlan.description,
          'Updated description',
        );
        expect(allPlans.map((plan) => plan.id), ['plan-1']);
      },
    );

    test(
      'workout days survive reopen with preserved relationships ordering and archive filtering',
      () async {
        final harness = testHarness!;

        await harness.planRepository.saveWorkoutPlan(
          _workoutPlan(id: 'plan-1', name: 'Plan 1'),
        );
        await harness.planRepository.saveWorkoutPlan(
          _workoutPlan(id: 'plan-2', name: 'Plan 2'),
        );

        await harness.dayRepository.saveWorkoutDay(
          _workoutDay(
            id: 'day-2',
            workoutPlanId: 'plan-1',
            dayNumber: 2,
            name: 'Day 2',
          ),
        );
        await harness.dayRepository.saveWorkoutDay(
          _workoutDay(
            id: 'day-1',
            workoutPlanId: 'plan-1',
            dayNumber: 1,
            name: 'Day 1',
          ),
        );
        await harness.dayRepository.saveWorkoutDay(
          _workoutDay(
            id: 'day-other-plan',
            workoutPlanId: 'plan-2',
            dayNumber: 1,
            name: 'Other Plan Day',
          ),
        );
        await harness.dayRepository.saveWorkoutDay(
          _workoutDay(
            id: 'day-archived',
            workoutPlanId: 'plan-1',
            dayNumber: 99,
            name: 'Archived Day',
          ),
        );
        await harness.dayRepository.deleteWorkoutDay(
          'day-archived',
        );

        await harness.reopen();

        final daysForPlan1 =
            await harness.dayRepository.getWorkoutDays(
          workoutPlanId: 'plan-1',
        );
        final day1 = await harness.dayRepository
            .getWorkoutDayById('day-1');
        final dayOtherPlan = await harness.dayRepository
            .getWorkoutDayById('day-other-plan');

        expect(
          daysForPlan1.map((day) => day.id).toList(),
          ['day-1', 'day-2'],
        );
        expect(day1, isNotNull);
        expect(day1!.workoutPlanId, 'plan-1');
        expect(dayOtherPlan, isNotNull);
        expect(dayOtherPlan!.workoutPlanId, 'plan-2');
        expect(
          daysForPlan1.every((day) => !day.isArchived),
          isTrue,
        );
      },
    );

    test(
      'workout groups and exercises survive reopen with ordering updates and legacy fields',
      () async {
        final harness = testHarness!;

        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-2',
            workoutDayId: 'day-1',
            displayOrder: 2,
            name: 'Second Group',
          ),
        );
        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-1',
            workoutDayId: 'day-1',
            displayOrder: 1,
            name: 'First Group',
          ),
        );
        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-archived',
            workoutDayId: 'day-1',
            displayOrder: 3,
            name: 'Archived Group',
          ),
        );
        await harness.groupRepository.deleteWorkoutGroup(
          'group-archived',
        );

        await harness.exerciseRepository.saveWorkoutExercise(
          _sequenceWorkoutExercise(
            id: 'exercise-sequence',
            workoutGroupId: 'group-1',
            displayOrder: 2,
            sessionRepetitions: 3,
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-legacy',
            workoutGroupId: 'group-1',
            displayOrder: 1,
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-default-round',
            workoutGroupId: 'group-2',
            displayOrder: 1,
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-delete-me',
            workoutGroupId: 'group-2',
            displayOrder: 2,
          ),
        );
        await harness.exerciseRepository.deleteWorkoutExercise(
          'exercise-delete-me',
        );

        await harness.reopen();

        final groups = await harness.groupRepository
            .getWorkoutGroups('day-1');
        final group1Exercises = await harness.exerciseRepository
            .getWorkoutExercises('group-1');
        final group2Exercises = await harness.exerciseRepository
            .getWorkoutExercises('group-2');
        final sequenceExercise =
            await harness.exerciseRepository
                .getWorkoutExerciseById(
          'exercise-sequence',
        );
        final deletedExercise =
            await harness.exerciseRepository
                .getWorkoutExerciseById(
          'exercise-delete-me',
        );

        expect(
          groups.map((group) => group.id).toList(),
          ['group-1', 'group-2'],
        );
        expect(
          group1Exercises
              .map((exercise) => exercise.id)
              .toList(),
          ['exercise-legacy', 'exercise-sequence'],
        );
        expect(
          group2Exercises
              .map((exercise) => exercise.id)
              .toList(),
          ['exercise-default-round'],
        );
        expect(sequenceExercise, isNotNull);
        expect(
          sequenceExercise!.sessionRepetitions,
          3,
        );
        expect(sequenceExercise.sequenceDefinition, isNotNull);
        expect(deletedExercise, isNull);

        final legacyExercise = group1Exercises.first;
        expect(legacyExercise.repetitions, 12);
        expect(legacyExercise.durationInSeconds, 30);
        expect(legacyExercise.restInSeconds, 15);
        expect(legacyExercise.sets, 4);
        expect(legacyExercise.weight, 20.5);
        expect(legacyExercise.weightUnit, WeightUnit.kilograms);
        expect(legacyExercise.rpe, 8);
        expect(legacyExercise.tempoType, TempoType.custom);
        expect(legacyExercise.customTempo, '3-1-1');
        expect(legacyExercise.notes, 'Focus on control');
        expect(
          group2Exercises.single.sessionRepetitions,
          1,
        );

        await harness.exerciseRepository.saveWorkoutExercise(
          sequenceExercise.copyWith(
            sessionRepetitions: 4,
            notes: 'Updated sequence notes',
          ),
        );
        await harness.reopen();

        final updatedSequenceExercise =
            await harness.exerciseRepository
                .getWorkoutExerciseById(
          'exercise-sequence',
        );

        expect(updatedSequenceExercise, isNotNull);
        expect(
          updatedSequenceExercise!.sessionRepetitions,
          4,
        );
        expect(
          updatedSequenceExercise.notes,
          'Updated sequence notes',
        );
      },
    );

    test(
      'mixed sequence definition round-trips exactly and still executes correctly after reopen',
      () async {
        final harness = testHarness!;
        final expectedDefinition = _mixedSequenceDefinition(
          counterRepetitions: 2,
        );

        await harness.exerciseRepository.saveWorkoutExercise(
          _sequenceWorkoutExercise(
            id: 'exercise-sequence',
            workoutGroupId: 'group-1',
            displayOrder: 1,
            sessionRepetitions: 3,
            sequenceDefinition: expectedDefinition,
          ),
        );
        await harness.reopen();

        final reloadedExercise =
            await harness.exerciseRepository
                .getWorkoutExerciseById(
          'exercise-sequence',
        );

        expect(reloadedExercise, isNotNull);
        expect(
          reloadedExercise!.sequenceDefinition,
          expectedDefinition,
        );
        expect(
          reloadedExercise.sessionRepetitions,
          3,
        );

        final events = const WorkoutSequenceExecutor().execute(
          workoutExercise: reloadedExercise,
          sequenceDefinition:
              reloadedExercise.sequenceDefinition!,
        );

        expect(
          events.where(
            (event) => event.type == WorkoutSequenceEventType.guide,
          ).map((event) => event.guideText),
          [
            'Get ready',
            'Lift',
            'Lift',
          ],
        );
        expect(
          events.where(
            (event) => event.type == WorkoutSequenceEventType.count,
          ).map((event) => event.countValue),
          [1, 2, 3, 2, 1, 2, 1],
        );
        expect(
          events.where(
            (event) => event.type == WorkoutSequenceEventType.relax,
          ).map((event) => event.durationInSeconds),
          [4, 4],
        );
        expect(
          events
              .where(
                (event) =>
                    event.type ==
                    WorkoutSequenceEventType.guide,
              )
              .skip(1)
              .map((event) => event.iterationNumber),
          [1, 2],
        );
        expect(events.last.type, WorkoutSequenceEventType.end);
      },
    );

    test(
      'Count and Count Seconds round-trip with distinct persisted step types',
      () async {
        final harness = testHarness!;
        final definition = WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.countSeconds(
              count: 3,
              direction: WorkoutCountDirection.descending,
            ),
            WorkoutSequenceStep.end(),
          ],
        );

        await harness.exerciseRepository.saveWorkoutExercise(
          _sequenceWorkoutExercise(
            id: 'count-seconds-exercise',
            workoutGroupId: 'group-1',
            displayOrder: 1,
            sequenceDefinition: definition,
          ),
        );
        await harness.reopen();

        final reloadedExercise = await harness.exerciseRepository
            .getWorkoutExerciseById('count-seconds-exercise');

        expect(reloadedExercise?.sequenceDefinition, definition);
        final events = const WorkoutSequenceExecutor().execute(
          workoutExercise: reloadedExercise!,
          sequenceDefinition: reloadedExercise.sequenceDefinition!,
        );
        expect(
          events.map((event) => event.type),
          [
            WorkoutSequenceEventType.count,
            WorkoutSequenceEventType.count,
            WorkoutSequenceEventType.countSeconds,
            WorkoutSequenceEventType.countSeconds,
            WorkoutSequenceEventType.countSeconds,
            WorkoutSequenceEventType.end,
          ],
        );
      },
    );

    test(
      'completed workout history survives reopen with metadata timestamps and counts',
      () async {
        final harness = testHarness!;
        final startedAt = DateTime.utc(2026, 8, 14, 8);
        final completedAt = DateTime.utc(2026, 8, 14, 8, 30);

        await harness.historyRepository.saveSession(
          CompletedWorkoutSession(
            id: 'session-1',
            workoutPlanId: 'plan-1',
            workoutPlanName: 'Strength Plan',
            workoutDayId: 'day-1',
            workoutDayName: 'Day 1',
            startedAt: startedAt,
            completedAt: completedAt,
            durationInSeconds: 1800,
            completedExercises: 2,
            totalExercises: 2,
            wasCompleted: true,
            notes: 'Felt strong',
          ),
        );
        await harness.reopen();

        final session = await harness.historyRepository
            .getSessionById('session-1');
        final allSessions = await harness.historyRepository
            .getCompletedSessions();

        expect(session, isNotNull);
        expect(session!.workoutPlanId, 'plan-1');
        expect(session.workoutPlanName, 'Strength Plan');
        expect(session.workoutDayId, 'day-1');
        expect(session.workoutDayName, 'Day 1');
        expect(session.startedAt, startedAt);
        expect(session.completedAt, completedAt);
        expect(session.durationInSeconds, 1800);
        expect(session.completedExercises, 2);
        expect(session.totalExercises, 2);
        expect(session.wasCompleted, isTrue);
        expect(session.notes, 'Felt strong');
        expect(allSessions, hasLength(1));
      },
    );

    test(
      'persistent repositories preserve Pack 10 day filtering and Pack 8 queue ordering',
      () async {
        final harness = testHarness!;
        await harness.planRepository.saveWorkoutPlan(
          _workoutPlan(id: 'plan-1', name: 'Plan 1'),
        );
        await harness.dayRepository.saveWorkoutDay(
          _workoutDay(
            id: 'day-1',
            workoutPlanId: 'plan-1',
            dayNumber: 1,
            name: 'Day 1',
          ),
        );
        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-2',
            workoutDayId: 'day-1',
            displayOrder: 2,
            name: 'Group 2',
          ),
        );
        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-1',
            workoutDayId: 'day-1',
            displayOrder: 1,
            name: 'Group 1',
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-2',
            workoutGroupId: 'group-1',
            displayOrder: 2,
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-1',
            workoutGroupId: 'group-1',
            displayOrder: 1,
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-4',
            workoutGroupId: 'group-2',
            displayOrder: 2,
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _legacyWorkoutExercise(
            id: 'exercise-3',
            workoutGroupId: 'group-2',
            displayOrder: 1,
          ),
        );
        await harness.reopen();

        final days = await harness.dayRepository.getWorkoutDays(
          workoutPlanId: 'plan-1',
        );
        final session = await WorkoutSessionBuilder(
          workoutGroupRepository: harness.groupRepository,
          workoutExerciseRepository:
              harness.exerciseRepository,
        ).build(
          workoutDayId: 'day-1',
          workoutPlanId: 'plan-1',
          workoutPlanName: 'Plan 1',
          workoutDayName: 'Day 1',
        );

        expect(days.map((day) => day.id), ['day-1']);
        expect(
          session.workoutExercises.map((exercise) => exercise.id),
          ['exercise-1', 'exercise-2', 'exercise-3', 'exercise-4'],
        );
        expect(session.workoutPlanId, 'plan-1');
        expect(session.workoutPlanName, 'Plan 1');
        expect(session.workoutDayId, 'day-1');
        expect(session.workoutDayName, 'Day 1');
      },
    );

    test(
      'reopened definitions complete once through sequence and legacy execution then derive history progress',
      () async {
        final harness = testHarness!;
        const planId = 'plan-journey';
        const dayId = 'day-journey';

        await harness.planRepository.saveWorkoutPlan(
          _workoutPlan(id: planId, name: 'Journey Plan'),
        );
        await harness.dayRepository.saveWorkoutDay(
          _workoutDay(
            id: dayId,
            workoutPlanId: planId,
            dayNumber: 1,
            name: 'Workout Day',
          ),
        );
        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-sequence',
            workoutDayId: dayId,
            displayOrder: 1,
            name: 'Sequence Group',
          ),
        );
        await harness.groupRepository.saveWorkoutGroup(
          _workoutGroup(
            id: 'group-legacy',
            workoutDayId: dayId,
            displayOrder: 2,
            name: 'Legacy Group',
          ),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          _sequenceWorkoutExercise(
            id: 'sequence-exercise',
            workoutGroupId: 'group-sequence',
            displayOrder: 1,
            sessionRepetitions: 2,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(text: 'Prepare'),
                WorkoutSequenceStep.count(
                  count: 2,
                  direction: WorkoutCountDirection.ascending,
                ),
                WorkoutSequenceStep.counter(repetitionCount: 2),
                WorkoutSequenceStep.guide(text: 'Lift'),
                WorkoutSequenceStep.relax(durationInSeconds: 0),
                WorkoutSequenceStep.sequenceBreak(),
                WorkoutSequenceStep.end(),
              ],
            ),
          ).copyWith(restInSeconds: 0),
        );
        await harness.exerciseRepository.saveWorkoutExercise(
          WorkoutExercise(
            id: 'legacy-exercise',
            workoutGroupId: 'group-legacy',
            exerciseId: 'exercise-legacy',
            displayOrder: 1,
            sets: 1,
            targetType: WorkoutTargetType.duration,
            durationInSeconds: 0,
            restInSeconds: 0,
          ),
        );

        await harness.reopen();

        final session = await WorkoutSessionBuilder(
          workoutGroupRepository: harness.groupRepository,
          workoutExerciseRepository: harness.exerciseRepository,
        ).build(
          workoutDayId: dayId,
          workoutPlanId: planId,
          workoutPlanName: 'Journey Plan',
          workoutDayName: 'Workout Day',
        );
        final sequenceExercise = session.workoutExercises.first;

        expect(
          session.workoutExercises.map((exercise) => exercise.id),
          ['sequence-exercise', 'legacy-exercise'],
        );
        expect(sequenceExercise.sessionRepetitions, 2);
        expect(
          sequenceExercise.sequenceDefinition!.steps[2].repetitionCount,
          2,
        );

        final speechEngine = _RecordingSpeechEngine();
        final controller = WorkoutSessionController(
          session: session,
          voiceCoach: VoiceCoachService(speechEngine: speechEngine),
        );
        var completionNotifications = 0;
        controller.addListener(() {
          if (controller.session.status == WorkoutSessionStatus.completed) {
            completionNotifications += 1;
          }
        });

        controller.startCountdown();
        await _flushAsyncWork();

        expect(controller.session.status, WorkoutSessionStatus.completed);
        expect(controller.completedExerciseCount, 2);
        expect(completionNotifications, 1);
        expect(
          speechEngine.spokenMessages,
          [
            'Prepare',
            '1',
            '2',
            '1',
            'Lift',
            '2',
            'Lift',
            'End of exercise.',
            'Prepare',
            '1',
            '2',
            '1',
            'Lift',
            '2',
            'Lift',
            'End of exercise.',
          ],
        );

        final completedAt = DateTime.utc(2026, 9, 2, 9);
        await harness.historyRepository.saveSession(
          CompletedWorkoutSession(
            id: 'journey-session-1',
            workoutPlanId: planId,
            workoutPlanName: 'Journey Plan',
            workoutDayId: dayId,
            workoutDayName: 'Workout Day',
            startedAt: completedAt.subtract(const Duration(minutes: 5)),
            completedAt: completedAt,
            durationInSeconds: 300,
            completedExercises: controller.completedExerciseCount,
            totalExercises: controller.totalExerciseCount,
            wasCompleted: true,
          ),
        );
        await harness.historyRepository.saveSession(
          CompletedWorkoutSession(
            id: 'journey-session-2',
            workoutPlanId: planId,
            workoutPlanName: 'Journey Plan',
            workoutDayId: dayId,
            workoutDayName: 'Workout Day',
            startedAt: completedAt,
            completedAt: completedAt.add(const Duration(minutes: 2)),
            durationInSeconds: 120,
            completedExercises: 2,
            totalExercises: 2,
            wasCompleted: true,
          ),
        );
        await harness.reopen();

        final progress = const WorkoutProgressService().calculate(
          workoutPlans: await harness.planRepository.getAllWorkoutPlans(),
          workoutDaysByPlanId: {
            planId: await harness.dayRepository.getWorkoutDays(
              workoutPlanId: planId,
            ),
          },
          workoutSessions: await harness.historyRepository
              .getCompletedSessions(),
        );

        expect(progress.overall.plannedWorkouts, 1);
        expect(progress.overall.completedPlannedWorkouts, 1);
        expect(progress.overall.actualSessions, 2);
        expect(progress.overall.totalDurationInSeconds, 420);
        expect(progress.overall.completionPercentage, 100);

        controller.dispose();
      },
    );
  });
}

class _PersistenceHarness {
  _PersistenceHarness._({
    required this._directory,
    required this._databaseName,
  });

  static int _databaseCounter = 0;

  final Directory _directory;
  final String _databaseName;

  IsarDatabase? _database;
  late IsarWorkoutPlanRepository planRepository;
  late IsarWorkoutDayRepository dayRepository;
  late IsarWorkoutGroupRepository groupRepository;
  late IsarWorkoutExerciseRepository exerciseRepository;
  late IsarWorkoutHistoryRepository historyRepository;

  static Future<_PersistenceHarness> create() async {
    final directory = await Directory.systemTemp.createTemp(
      'workout_companion_pack11_',
    );
    final harness = _PersistenceHarness._(
      directory: directory,
      databaseName:
          'pack11_test_${_databaseCounter++}',
    );
    await harness.open();
    return harness;
  }

  Future<void> open() async {
    _database = await IsarDatabase.open(
      directoryPath: _directory.path,
      name: _databaseName,
    );

    final isar = _database!.isar;
    planRepository = IsarWorkoutPlanRepository(isar);
    dayRepository = IsarWorkoutDayRepository(isar);
    groupRepository = IsarWorkoutGroupRepository(isar);
    exerciseRepository =
        IsarWorkoutExerciseRepository(isar);
    historyRepository = IsarWorkoutHistoryRepository(isar);
  }

  Future<void> reopen() async {
    await close();
    await open();
  }

  Future<void> close() async {
    final database = _database;
    _database = null;
    await database?.close();
  }

  Future<void> dispose() async {
    await close();

    if (await _directory.exists()) {
      await _directory.delete(recursive: true);
    }
  }
}

WorkoutPlan _workoutPlan({
  required String id,
  required String name,
}) {
  return WorkoutPlan(
    id: id,
    name: name,
    description: '$name description',
    category: WorkoutPlanCategory.strength,
    difficulty: WorkoutPlanDifficulty.intermediate,
    estimatedDurationInMinutes: 45,
  );
}

Future<void> _initializeIsarCoreForTests() async {
  if (!Platform.isWindows) {
    await Isar.initializeIsarCore(download: true);
    return;
  }

  final localAppData = Platform.environment['LOCALAPPDATA'];

  if (localAppData == null || localAppData.isEmpty) {
    throw StateError(
      'LOCALAPPDATA is required to locate the Isar test library.',
    );
  }

  final libraryPath = [
    localAppData,
    'Pub',
    'Cache',
    'hosted',
    'pub.dev',
    'isar_community_flutter_libs-3.3.2',
    'windows',
    'libisar.dll',
  ].join(Platform.pathSeparator);

  if (!File(libraryPath).existsSync()) {
    throw StateError(
      'Isar test library not found at $libraryPath.',
    );
  }

  await Isar.initializeIsarCore(
    libraries: {
      Abi.windowsX64: libraryPath,
    },
  );
}

WorkoutDay _workoutDay({
  required String id,
  required String workoutPlanId,
  required int dayNumber,
  required String name,
}) {
  return WorkoutDay(
    id: id,
    workoutPlanId: workoutPlanId,
    dayNumber: dayNumber,
    name: name,
    description: '$name description',
  );
}

WorkoutGroup _workoutGroup({
  required String id,
  required String workoutDayId,
  required int displayOrder,
  required String name,
}) {
  return WorkoutGroup(
    id: id,
    workoutDayId: workoutDayId,
    name: name,
    displayOrder: displayOrder,
  );
}

WorkoutExercise _legacyWorkoutExercise({
  required String id,
  required String workoutGroupId,
  required int displayOrder,
}) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: workoutGroupId,
    exerciseId: 'exercise_$id',
    displayOrder: displayOrder,
    sets: 4,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 12,
    durationInSeconds: 30,
    restInSeconds: 15,
    weight: 20.5,
    weightUnit: WeightUnit.kilograms,
    rpe: 8,
    tempoType: TempoType.custom,
    customTempo: '3-1-1',
    notes: 'Focus on control',
  );
}

WorkoutExercise _sequenceWorkoutExercise({
  required String id,
  required String workoutGroupId,
  required int displayOrder,
  int sessionRepetitions = 1,
  WorkoutSequenceDefinition? sequenceDefinition,
}) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: workoutGroupId,
    exerciseId: 'exercise_$id',
    displayOrder: displayOrder,
    sets: 1,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 99,
    restInSeconds: 5,
    sessionRepetitions: sessionRepetitions,
    sequenceDefinition:
        sequenceDefinition ??
        _mixedSequenceDefinition(
          counterRepetitions: 2,
        ),
  );
}

WorkoutSequenceDefinition _mixedSequenceDefinition({
  required int counterRepetitions,
}) {
  return WorkoutSequenceDefinition(
    steps: [
      WorkoutSequenceStep.guide(text: 'Get ready'),
      WorkoutSequenceStep.count(
        count: 3,
        direction: WorkoutCountDirection.ascending,
      ),
      WorkoutSequenceStep.counter(
        repetitionCount: counterRepetitions,
      ),
      WorkoutSequenceStep.guide(text: 'Lift'),
      WorkoutSequenceStep.count(
        count: 2,
        direction: WorkoutCountDirection.descending,
      ),
      WorkoutSequenceStep.relax(durationInSeconds: 4),
      WorkoutSequenceStep.sequenceBreak(),
      WorkoutSequenceStep.end(),
    ],
  );
}

Future<void> _flushAsyncWork() async {
  for (var index = 0; index < 12; index += 1) {
    await Future<void>.delayed(Duration.zero);
  }
}

class _RecordingSpeechEngine implements SpeechEngine {
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
