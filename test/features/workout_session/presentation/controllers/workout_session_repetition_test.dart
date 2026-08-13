import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_sequence_event.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_timer_service.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/controllers/workout_session_controller.dart';

void main() {
  group('WorkoutSessionController session repetition', () {
    test('repetition 1 executes exercise once', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            durationInSeconds: 5,
            sessionRepetitions: 1,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();

      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
      expect(controller.completedExerciseCount, 1);
      expect(controller.currentExerciseRound, 1);
    });

    test('repetition 3 executes same exercise three complete times', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            durationInSeconds: 5,
            sessionRepetitions: 3,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 2);
      expect(controller.completedExerciseCount, 0);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 3);
      expect(controller.completedExerciseCount, 0);

      timerService.finish();
      await _flushAsyncWork();
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
      expect(controller.completedExerciseCount, 1);
    });

    test('exercise queue does not advance until all repetitions finish', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            id: 'legacy-1',
            durationInSeconds: 5,
            sessionRepetitions: 3,
          ),
          _legacyExercise(
            id: 'legacy-2',
            durationInSeconds: 7,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.session.currentExercise.id, 'legacy-1');
      expect(controller.currentExerciseRound, 2);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.session.currentExercise.id, 'legacy-1');
      expect(controller.currentExerciseRound, 3);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseRound, 1);
    });

    test('completedExerciseCount increments only once after all repetitions', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            durationInSeconds: 5,
            sessionRepetitions: 3,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.completedExerciseCount, 0);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.completedExerciseCount, 0);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.completedExerciseCount, 1);
    });

    test('current repetition progresses 1 2 3', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            durationInSeconds: 5,
            sessionRepetitions: 3,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      expect(controller.currentExerciseRound, 1);

      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 2);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 3);
    });

    test('repetition resets to 1 on next workout exercise', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            id: 'legacy-1',
            durationInSeconds: 5,
            sessionRepetitions: 2,
          ),
          _legacyExercise(
            id: 'legacy-2',
            durationInSeconds: 7,
            sessionRepetitions: 3,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 2);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseRound, 1);
      expect(controller.totalRoundsForCurrentExercise, 3);
    });

    test('sequence exercise restarts sequence definition from beginning each round', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercises: [
          _sequenceExercise(
            sessionRepetitions: 2,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(text: 'First'),
                WorkoutSequenceStep.count(
                  count: 2,
                  direction: WorkoutCountDirection.ascending,
                ),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
        ],
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        [
          'First',
          '1',
          '2',
          'End of exercise.',
          'First',
          '1',
          '2',
          'End of exercise.',
        ],
      );
    });

    test('counter repetitionCount remains independent across multiple session rounds', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercises: [
          _sequenceExercise(
            sessionRepetitions: 3,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.counter(repetitionCount: 2),
                WorkoutSequenceStep.guide(text: 'A'),
                WorkoutSequenceStep.sequenceBreak(),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
        ],
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        [
          '1',
          'A',
          '2',
          'A',
          'End of exercise.',
          '1',
          'A',
          '2',
          'A',
          'End of exercise.',
          '1',
          'A',
          '2',
          'A',
          'End of exercise.',
        ],
      );
    });

    test('counter 2 and session repetition 3 does not mutate to counter 6', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercises: [
          _sequenceExercise(
            sessionRepetitions: 3,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.counter(repetitionCount: 2),
                WorkoutSequenceStep.guide(text: 'A'),
                WorkoutSequenceStep.sequenceBreak(),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
        ],
      );

      controller.startCountdown();
      await _flushAsyncWork();

      final iterationAnnouncements = speechEngine.spokenMessages
          .where((message) => message == '1' || message == '2')
          .toList();
      expect(
        iterationAnnouncements,
        ['1', '2', '1', '2', '1', '2'],
      );
    });

    test('legacy exercise repetition works', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            durationInSeconds: 4,
            sessionRepetitions: 3,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.session.remainingSeconds, 4);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 2);
      expect(controller.session.remainingSeconds, 4);

      timerService.finish();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 3);
      expect(controller.session.remainingSeconds, 4);
    });

    test('sequence to legacy transition after repetitions works', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _sequenceExercise(
            id: 'sequence-1',
            sessionRepetitions: 2,
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(text: 'Sequence'),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
          _legacyExercise(
            id: 'legacy-2',
            durationInSeconds: 6,
          ),
        ],
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.currentExerciseRound, 1);
      expect(controller.completedExerciseCount, 1);
      expect(controller.session.remainingSeconds, 6);
    });

    test('legacy to sequence transition after repetitions works', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            id: 'legacy-1',
            durationInSeconds: 4,
            sessionRepetitions: 2,
          ),
          _sequenceExercise(
            id: 'sequence-2',
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.guide(text: 'Second'),
                WorkoutSequenceStep.relax(durationInSeconds: 2),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'sequence-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.currentExerciseRound, 1);
      expect(controller.completedExerciseCount, 1);
      expect(
        controller.activeSequenceEvent?.type,
        WorkoutSequenceEventType.relax,
      );
    });

    test('pause and resume does not duplicate or restart a session repetition', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            durationInSeconds: 4,
            sessionRepetitions: 2,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      controller.pause();
      timerService.tick();
      await _flushAsyncWork();
      expect(controller.currentExerciseRound, 1);

      controller.resume();
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.currentExerciseRound, 2);
      expect(controller.completedExerciseCount, 0);

      timerService.finish();
      await _flushAsyncWork();
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('manual next clears remaining repetitions', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            id: 'legacy-1',
            durationInSeconds: 4,
            sessionRepetitions: 3,
          ),
          _legacyExercise(
            id: 'legacy-2',
            durationInSeconds: 6,
          ),
        ],
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      controller.nextExercise();

      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseRound, 1);
      expect(controller.completedExerciseCount, 1);
    });

    test('voice disabled does not affect repetition progression', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final voiceCoach = VoiceCoachService(
        speechEngine: speechEngine,
      );
      await voiceCoach.setEnabled(false);

      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _sequenceExercise(
              sessionRepetitions: 2,
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.guide(text: 'First'),
                  WorkoutSequenceStep.end(),
                ],
              ),
            ),
            _legacyExercise(
              id: 'legacy-2',
              durationInSeconds: 6,
            ),
          ],
        ),
        voiceCoach: voiceCoach,
        timerService: timerService,
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.completedExerciseCount, 1);
      expect(speechEngine.spokenMessages, isEmpty);

      timerService.finish();
      await _flushAsyncWork();
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('final workout completion occurs once after all exercises and repetitions', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        timerService: timerService,
        workoutExercises: [
          _legacyExercise(
            id: 'legacy-1',
            durationInSeconds: 4,
            sessionRepetitions: 2,
          ),
          _legacyExercise(
            id: 'legacy-2',
            durationInSeconds: 6,
            sessionRepetitions: 3,
          ),
        ],
      );

      var completedNotifications = 0;
      controller.addListener(() {
        if (controller.session.status ==
            WorkoutSessionStatus.completed) {
          completedNotifications += 1;
        }
      });

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      for (var index = 0; index < 5; index += 1) {
        timerService.finish();
        await _flushAsyncWork();
      }

      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
      expect(controller.completedExerciseCount, 2);
      expect(completedNotifications, 1);
    });
  });
}

WorkoutSessionController _controller({
  _FakeSpeechEngine? speechEngine,
  WorkoutTimerService? timerService,
  required List<WorkoutExercise> workoutExercises,
}) {
  return WorkoutSessionController(
    session: WorkoutSession(
      workoutExercises: workoutExercises,
    ),
    voiceCoach: VoiceCoachService(
      speechEngine:
          speechEngine ?? _FakeSpeechEngine(),
    ),
    timerService: timerService,
  );
}

WorkoutExercise _sequenceExercise({
  String id = 'sequence-exercise',
  int sessionRepetitions = 1,
  required WorkoutSequenceDefinition sequenceDefinition,
}) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 1,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 12,
    restInSeconds: 0,
    sessionRepetitions: sessionRepetitions,
    sequenceDefinition: sequenceDefinition,
  );
}

WorkoutExercise _legacyExercise({
  String id = 'legacy-exercise',
  int durationInSeconds = 5,
  int sessionRepetitions = 1,
}) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 1,
    targetType: WorkoutTargetType.duration,
    durationInSeconds: durationInSeconds,
    restInSeconds: 0,
    sessionRepetitions: sessionRepetitions,
  );
}

Future<void> _flushAsyncWork() async {
  for (var index = 0; index < 10; index += 1) {
    await Future<void>.delayed(Duration.zero);
  }
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

class _FakeWorkoutTimerService extends WorkoutTimerService {
  bool _isRunning = false;
  bool _isPaused = false;
  int _remainingSeconds = 0;
  TimerTickCallback? _onTick;
  TimerFinishedCallback? _onFinished;

  @override
  bool get isRunning => _isRunning;

  @override
  bool get isPaused => _isPaused;

  @override
  int get remainingSeconds => _remainingSeconds;

  @override
  void start({
    required int seconds,
    required TimerTickCallback onTick,
    required TimerFinishedCallback onFinished,
  }) {
    _isRunning = true;
    _isPaused = false;
    _remainingSeconds = seconds;
    _onTick = onTick;
    _onFinished = onFinished;
    _onTick?.call(_remainingSeconds);
  }

  @override
  void pause() {
    if (!_isRunning) {
      return;
    }

    _isRunning = false;
    _isPaused = true;
  }

  @override
  void resume() {
    if (!_isPaused) {
      return;
    }

    _isPaused = false;
    _isRunning = true;
  }

  @override
  void stop() {
    _isRunning = false;
    _isPaused = false;
    _remainingSeconds = 0;
    _onTick = null;
    _onFinished = null;
  }

  void tick() {
    if (!_isRunning) {
      return;
    }

    _remainingSeconds -= 1;

    if (_remainingSeconds <= 0) {
      _isRunning = false;
      _remainingSeconds = 0;
      _onFinished?.call();
      return;
    }

    _onTick?.call(_remainingSeconds);
  }

  void finish() {
    if (!_isRunning) {
      return;
    }

    _isRunning = false;
    _remainingSeconds = 0;
    _onFinished?.call();
  }
}
