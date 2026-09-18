import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_history/domain/repositories/workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/controllers/workout_session_controller.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/screens/workout_execution_screen.dart';

void main() {
  testWidgets(
    'keeps the screen awake throughout active and paused training, then releases on disposal',
    (tester) async {
      final keepAwake = _FakeKeepAwake();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise()],
          status: WorkoutSessionStatus.exercising,
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: controller.session,
            controller: controller,
            voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
            workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
            enableKeepScreenAwake: keepAwake.enable,
            disableKeepScreenAwake: keepAwake.disable,
          ),
        ),
      );
      await tester.pump();

      expect(keepAwake.enableCount, 1);
      expect(keepAwake.disableCount, 0);

      await tester.tap(find.text('II  PAUSE'));
      await tester.pump();
      await tester.tap(find.text('RESUME TRAINING'));
      await tester.pump();

      expect(keepAwake.enableCount, 1);
      expect(keepAwake.disableCount, 0);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(keepAwake.disableCount, 1);
    },
  );

  testWidgets('releases keep-awake after completion replaces active training', (
    tester,
  ) async {
    final keepAwake = _FakeKeepAwake();

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: _completedSession(),
          voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
          workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          enableKeepScreenAwake: keepAwake.enable,
          disableKeepScreenAwake: keepAwake.disable,
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(keepAwake.enableCount, 1);
    expect(keepAwake.disableCount, 1);
    expect(find.text('Workout Complete'), findsOneWidget);
  });

  testWidgets('manual End Workout releases keep-awake after confirmation', (
    tester,
  ) async {
    final keepAwake = _FakeKeepAwake();
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [_exercise()],
        status: WorkoutSessionStatus.exercising,
      ),
      voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: controller.session,
          controller: controller,
          voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
          workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          enableKeepScreenAwake: keepAwake.enable,
          disableKeepScreenAwake: keepAwake.disable,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('II  PAUSE'));
    await tester.pump();
    await tester.tap(find.text('END WORKOUT').last);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('END WORKOUT'),
      ),
    );
    await tester.pumpAndSettle();

    expect(keepAwake.disableCount, 1);
    expect(find.text('Workout Complete'), findsOneWidget);
  });

  testWidgets('keep-awake platform failures do not interrupt active training', (
    tester,
  ) async {
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [_exercise()],
        status: WorkoutSessionStatus.exercising,
      ),
      voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: controller.session,
          controller: controller,
          voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
          workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          enableKeepScreenAwake: () => Future<void>.error('Unavailable'),
          disableKeepScreenAwake: () => Future<void>.error('Unavailable'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('RITMO // ACTIVE TRAINING'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the active training HUD and paused overlay', (
    tester,
  ) async {
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [_exercise(sessionRepetitions: 2)],
        currentExerciseRound: 2,
        status: WorkoutSessionStatus.exercising,
      ),
      voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: controller.session,
          controller: controller,
          voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
          workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('RITMO // ACTIVE TRAINING'), findsOneWidget);
    expect(find.text('VOICE // ON'), findsOneWidget);
    expect(find.text('WORKOUT PROGRESS'), findsOneWidget);
    expect(find.text('II  PAUSE'), findsOneWidget);

    await tester.tap(find.text('II  PAUSE'));
    await tester.pump();
    expect(find.text('TRAINING PAUSED'), findsOneWidget);
    expect(find.text('RESUME TRAINING'), findsOneWidget);

    await tester.tap(find.text('RESUME TRAINING'));
    await tester.pump();
    expect(find.text('TRAINING PAUSED'), findsNothing);
  });

  testWidgets(
    'keeps the active training HUD within a narrow portrait viewport',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise()],
          status: WorkoutSessionStatus.exercising,
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: controller.session,
            controller: controller,
            voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
            workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'renders Guide, timed count, and Counter iteration from runtime events',
    (tester) async {
      final guideSpeech = _PendingSpeechEngine();
      final guideController = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _exercise(
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.counter(repetitionCount: 2),
                  WorkoutSequenceStep.guide(text: 'Hold steady'),
                  WorkoutSequenceStep.sequenceBreak(),
                  WorkoutSequenceStep.end(),
                ],
              ),
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(speechEngine: guideSpeech),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: guideController.session,
            controller: guideController,
            voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
            workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          ),
        ),
      );
      guideController.startCountdown();
      await tester.pump();

      expect(find.text('GUIDANCE'), findsOneWidget);
      expect(find.text('Hold steady'), findsOneWidget);
      expect(find.text('REP 1 / 2  //  SEQUENCE LOOP ACTIVE'), findsOneWidget);

      guideSpeech.completeSpeech();
      guideController.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      final timedController = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _exercise(
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.countSeconds(
                    count: 3,
                    direction: WorkoutCountDirection.descending,
                  ),
                  WorkoutSequenceStep.end(),
                ],
              ),
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: timedController.session,
            controller: timedController,
            voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
            workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          ),
        ),
      );
      timedController.startCountdown();
      await tester.pump();

      expect(find.text('TIMED COUNT'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      timedController.dispose();
    },
  );

  testWidgets(
    'shows round progress when session repetition is greater than 1',
    (tester) async {
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise(sessionRepetitions: 3)],
          currentExerciseRound: 2,
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: controller.session,
            controller: controller,
            voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
            workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Round 2 of 3'), findsOneWidget);
    },
  );

  testWidgets(
    'history repository receives exactly one completed workout session',
    (tester) async {
      final historyRepository = _FakeWorkoutHistoryRepository();
      final voiceCoach = VoiceCoachService(speechEngine: _FakeSpeechEngine());
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise(sessionRepetitions: 3)],
          workoutPlanId: 'plan-1',
          workoutPlanName: 'Plan',
          workoutDayId: 'day-1',
          workoutDayName: 'Day 1',
          startedAt: DateTime(2026, 8, 13, 10, 0, 0),
          completedAt: DateTime(2026, 8, 13, 10, 5, 0),
          currentExerciseIndex: 0,
          currentExerciseRound: 3,
          status: WorkoutSessionStatus.completed,
        ),
        voiceCoach: voiceCoach,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: controller.session,
            controller: controller,
            voiceCoach: voiceCoach,
            workoutHistoryRepository: historyRepository,
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(historyRepository.savedSessions, hasLength(1));
      expect(historyRepository.savedSessions.single.completedExercises, 1);
      expect(historyRepository.savedSessions.single.totalExercises, 1);

      await tester.pump();
      expect(historyRepository.savedSessions, hasLength(1));
    },
  );

  testWidgets(
    'awaits the final completion announcement before saving and replacing',
    (tester) async {
      final historyRepository = _FakeWorkoutHistoryRepository();
      final speechEngine = _PendingSpeechEngine();
      final voiceCoach = VoiceCoachService(speechEngine: speechEngine);

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: _completedSession(),
            voiceCoach: voiceCoach,
            workoutHistoryRepository: historyRepository,
          ),
        ),
      );
      await tester.pump();

      expect(speechEngine.spokenMessages, ['Workout completed.']);
      expect(historyRepository.savedSessions, isEmpty);
      expect(speechEngine.stopCount, 0);

      speechEngine.completeSpeech();
      await tester.pump();
      await tester.pump();

      expect(historyRepository.savedSessions, hasLength(1));
    },
  );

  testWidgets('voice-off completion does not wait for an announcement', (
    tester,
  ) async {
    final historyRepository = _FakeWorkoutHistoryRepository();
    final speechEngine = _PendingSpeechEngine();
    final voiceCoach = VoiceCoachService(speechEngine: speechEngine);
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [_exercise()],
        status: WorkoutSessionStatus.exercising,
      ),
      voiceCoach: voiceCoach,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: controller.session,
          controller: controller,
          voiceCoach: voiceCoach,
          workoutHistoryRepository: historyRepository,
        ),
      ),
    );
    await tester.pump();
    await voiceCoach.setEnabled(false);
    controller.finishWorkout();
    await tester.pump();

    expect(speechEngine.spokenMessages, isEmpty);
    expect(historyRepository.savedSessions, hasLength(1));
  });

  testWidgets('failed final speech does not block completion', (tester) async {
    final historyRepository = _FakeWorkoutHistoryRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: _completedSession(),
          voiceCoach: VoiceCoachService(speechEngine: _ThrowingSpeechEngine()),
          workoutHistoryRepository: historyRepository,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(historyRepository.savedSessions, hasLength(1));
  });

  testWidgets('long Guide text remains readable on a narrow portrait screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const guide =
        'Keep your shoulders relaxed, lift slowly with control, and pause at the top before lowering with the same steady form.';
    final pendingSpeech = _PendingSpeechEngine();
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [
          _exercise(
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(text: guide),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
        ],
      ),
      voiceCoach: VoiceCoachService(speechEngine: pendingSpeech),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutExecutionScreen(
          session: controller.session,
          controller: controller,
          voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
          workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
        ),
      ),
    );
    controller.startCountdown();
    await tester.pump();

    expect(find.text(guide), findsOneWidget);
    expect(tester.takeException(), isNull);
    controller.dispose();
  });

  testWidgets('active workout requires confirmation before leaving', (
    tester,
  ) async {
    final keepAwake = _FakeKeepAwake();
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [_exercise()],
        status: WorkoutSessionStatus.exercising,
      ),
      voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutExecutionScreen(
                      session: controller.session,
                      controller: controller,
                      voiceCoach: VoiceCoachService(
                        speechEngine: _FakeSpeechEngine(),
                      ),
                      workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
                      enableKeepScreenAwake: keepAwake.enable,
                      disableKeepScreenAwake: keepAwake.disable,
                    ),
                  ),
                ),
                child: const Text('Open Workout'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open Workout'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('LEAVE TRAINING?'), findsOneWidget);

    await tester.tap(find.text('KEEP TRAINING'));
    await tester.pumpAndSettle();
    expect(find.text('Workout'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('LEAVE WORKOUT'));
    await tester.pumpAndSettle();

    expect(find.text('Open Workout'), findsOneWidget);
    expect(keepAwake.disableCount, 1);
  });
}

class _FakeKeepAwake {
  var enableCount = 0;
  var disableCount = 0;

  Future<void> enable() async {
    enableCount += 1;
  }

  Future<void> disable() async {
    disableCount += 1;
  }
}

WorkoutExercise _exercise({
  int sessionRepetitions = 1,
  WorkoutSequenceDefinition? sequenceDefinition,
}) {
  return WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 1,
    targetType: WorkoutTargetType.duration,
    durationInSeconds: 30,
    restInSeconds: 0,
    sessionRepetitions: sessionRepetitions,
    sequenceDefinition: sequenceDefinition,
  );
}

WorkoutSession _completedSession() {
  return WorkoutSession(
    workoutExercises: [_exercise()],
    workoutPlanId: 'plan-1',
    workoutPlanName: 'Plan',
    workoutDayId: 'day-1',
    workoutDayName: 'Day 1',
    startedAt: DateTime(2026, 8, 13, 10, 0, 0),
    completedAt: DateTime(2026, 8, 13, 10, 5, 0),
    currentExerciseIndex: 0,
    status: WorkoutSessionStatus.completed,
  );
}

class _FakeSpeechEngine implements SpeechEngine {
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
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}

class _PendingSpeechEngine implements SpeechEngine {
  final List<String> spokenMessages = [];
  final Completer<void> _speechCompleter = Completer<void>();
  var stopCount = 0;

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
    await _speechCompleter.future;
  }

  @override
  Future<void> stop() async {
    stopCount += 1;
  }

  void completeSpeech() {
    if (!_speechCompleter.isCompleted) {
      _speechCompleter.complete();
    }
  }
}

class _ThrowingSpeechEngine extends _FakeSpeechEngine {
  @override
  Future<void> speak(String text) async {
    throw StateError('TTS unavailable');
  }
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
