import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/settings/domain/entities/voice_preferences.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_sequence_event.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_timer_service.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_sequence_executor.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/controllers/workout_session_controller.dart';

void main() {
  group('WorkoutSessionController sequence execution', () {
    test('guide events are spoken in configured order', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.guide(text: 'First'),
              WorkoutSequenceStep.guide(text: 'Second'),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['First', 'Second', 'End of exercise.'],
      );
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('descending count 5 speaks 5 4 3 2 1 in order', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.count(
                count: 5,
                direction: WorkoutCountDirection.descending,
              ),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['5', '4', '3', '2', '1', 'End of exercise.'],
      );
    });

    test('ascending count 2 speaks 1 2', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.count(
                count: 2,
                direction: WorkoutCountDirection.ascending,
              ),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['1', '2', 'End of exercise.'],
      );
    });

    test('natural Count remains speech-paced and does not start a timer', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.count(
                count: 3,
                direction: WorkoutCountDirection.ascending,
              ),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(speechEngine.spokenMessages, ['1', '2', '3', 'End of exercise.']);
      expect(timerService.startCount, 0);
      expect(controller.session.status, WorkoutSessionStatus.completed);
    });

    test('Count Seconds ascending speaks immediately then once per timer tick', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.countSeconds(
                count: 3,
                direction: WorkoutCountDirection.ascending,
              ),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();
      expect(speechEngine.spokenMessages, ['1']);
      expect(timerService.startCount, 1);
      expect(controller.activeSequenceEvent?.type, WorkoutSequenceEventType.countSeconds);

      timerService.tick();
      await _flushAsyncWork();
      expect(speechEngine.spokenMessages, ['1', '2']);
      expect(timerService.startCount, 2);

      timerService.tick();
      await _flushAsyncWork();
      expect(speechEngine.spokenMessages, ['1', '2', '3']);
      expect(timerService.startCount, 3);

      timerService.tick();
      await _flushAsyncWork();
      expect(
        speechEngine.spokenMessages,
        ['1', '2', '3', 'End of exercise.'],
      );
      expect(controller.session.status, WorkoutSessionStatus.completed);
    });

    test('Count Seconds descending preserves its configured direction', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _sequenceExercise(
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
      );

      controller.startCountdown();
      await _flushAsyncWork();
      timerService.tick();
      await _flushAsyncWork();
      timerService.tick();
      await _flushAsyncWork();
      timerService.tick();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['3', '2', '1', 'End of exercise.'],
      );
      expect(controller.session.status, WorkoutSessionStatus.completed);
    });

    test('Count Seconds cadence ignores slow speech and Voice Pace', () async {
      for (final speechRate in [0.2, 0.8]) {
        final speechEngine = _FakeSpeechEngine(blockSpeaks: true);
        final timerService = _FakeWorkoutTimerService();
        final voiceCoach = VoiceCoachService(speechEngine: speechEngine);
        await voiceCoach.applyPreferences(
          VoicePreferences(speechRate: speechRate),
        );
        final controller = _controller(
          timerService: timerService,
          voiceCoach: voiceCoach,
          workoutExercise: _sequenceExercise(
            sequenceDefinition: WorkoutSequenceDefinition(
              steps: [
                WorkoutSequenceStep.countSeconds(
                  count: 2,
                  direction: WorkoutCountDirection.ascending,
                ),
                WorkoutSequenceStep.end(),
              ],
            ),
          ),
        );

        controller.startCountdown();
        await _flushAsyncWork();
        expect(speechEngine.spokenMessages, ['1']);

        timerService.tick();
        await _flushAsyncWork();
        expect(speechEngine.spokenMessages, ['1', '2']);
        expect(timerService.startCount, 2);
      }
    });

    test('Count Seconds remains timed when voice is disabled or speech fails', () async {
      final disabledTimer = _FakeWorkoutTimerService();
      final disabledSpeech = _FakeSpeechEngine();
      final disabledController = _controller(
        timerService: disabledTimer,
        voiceCoach: VoiceCoachService(
          speechEngine: disabledSpeech,
          isEnabled: false,
        ),
        workoutExercise: _countSecondsExercise(),
      );
      final failedTimer = _FakeWorkoutTimerService();
      final failedController = _controller(
        timerService: failedTimer,
        speechEngine: _FakeSpeechEngine(throwOnSpeak: true),
        workoutExercise: _countSecondsExercise(),
      );

      disabledController.startCountdown();
      failedController.startCountdown();
      await _flushAsyncWork();
      disabledTimer.tick();
      failedTimer.tick();
      await _flushAsyncWork();
      disabledTimer.tick();
      failedTimer.tick();
      await _flushAsyncWork();

      expect(disabledSpeech.spokenMessages, isEmpty);
      expect(disabledController.session.status, WorkoutSessionStatus.completed);
      expect(failedController.session.status, WorkoutSessionStatus.completed);
    });

    test('pause and resume exclude paused time from Count Seconds', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _countSecondsExercise(),
      );

      controller.startCountdown();
      await _flushAsyncWork();
      expect(speechEngine.spokenMessages, ['1']);

      controller.pause();
      timerService.tick();
      await _flushAsyncWork();
      expect(speechEngine.spokenMessages, ['1']);

      controller.resume();
      timerService.tick();
      await _flushAsyncWork();
      expect(speechEngine.spokenMessages, ['1', '2']);

      timerService.tick();
      await _flushAsyncWork();
      expect(controller.session.status, WorkoutSessionStatus.completed);
    });

    test('Count Seconds repeats inside Counter without changing its repetition count', () async {
      final events = const WorkoutSequenceExecutor().execute(
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: const [],
          ),
        ),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.counter(repetitionCount: 2),
            WorkoutSequenceStep.countSeconds(
              count: 2,
              direction: WorkoutCountDirection.descending,
            ),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(
        events
            .where((event) => event.type == WorkoutSequenceEventType.countSeconds)
            .map((event) => event.countValue),
        [2, 1, 2, 1],
      );
      expect(
        events
            .where((event) => event.type == WorkoutSequenceEventType.countSeconds)
            .map((event) => event.iterationNumber),
        [1, 1, 2, 2],
      );
    });

    test('counter 3 announces each iteration exactly once', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.counter(repetitionCount: 3),
              WorkoutSequenceStep.guide(text: 'Up'),
              WorkoutSequenceStep.sequenceBreak(),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['1', 'Up', '2', 'Up', '3', 'Up', 'End of exercise.'],
      );
    });

    test('counter block guide and count events execute in correct order', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.counter(repetitionCount: 2),
              WorkoutSequenceStep.guide(text: 'Up'),
              WorkoutSequenceStep.count(
                count: 2,
                direction: WorkoutCountDirection.ascending,
              ),
              WorkoutSequenceStep.sequenceBreak(),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['1', 'Up', '1', '2', '2', 'Up', '1', '2', 'End of exercise.'],
      );
    });

    test('relax is silent and duration is honored', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.guide(text: 'Prepare'),
              WorkoutSequenceStep.relax(durationInSeconds: 2),
              WorkoutSequenceStep.guide(text: 'Resume'),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(speechEngine.spokenMessages, ['Prepare']);
      expect(
        controller.activeSequenceEvent?.type,
        WorkoutSequenceEventType.relax,
      );
      expect(controller.session.remainingSeconds, 2);

      timerService.tick();
      await _flushAsyncWork();
      expect(controller.session.remainingSeconds, 1);
      expect(speechEngine.spokenMessages, ['Prepare']);

      timerService.tick();
      await _flushAsyncWork();
      expect(
        speechEngine.spokenMessages,
        ['Prepare', 'Resume', 'End of exercise.'],
      );
    });

    test('pause and resume during relax continue from the correct remaining time', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.guide(text: 'Prepare'),
              WorkoutSequenceStep.relax(durationInSeconds: 2),
              WorkoutSequenceStep.guide(text: 'Resume'),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      controller.pause();
      expect(
        controller.session.status,
        WorkoutSessionStatus.paused,
      );
      expect(timerService.isPaused, isTrue);

      timerService.tick();
      await _flushAsyncWork();
      expect(controller.session.remainingSeconds, 2);
      expect(speechEngine.spokenMessages, ['Prepare']);

      controller.resume();
      timerService.tick();
      await _flushAsyncWork();
      expect(controller.session.remainingSeconds, 1);

      timerService.tick();
      await _flushAsyncWork();
      expect(
        speechEngine.spokenMessages,
        ['Prepare', 'Resume', 'End of exercise.'],
      );
    });

    test('voice disabled skips speech but sequence still progresses', () async {
      final speechEngine = _FakeSpeechEngine();
      final voiceCoach = VoiceCoachService(
        speechEngine: speechEngine,
      );
      await voiceCoach.setEnabled(false);

      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _sequenceExercise(
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
        ),
        voiceCoach: voiceCoach,
        timerService: _FakeWorkoutTimerService(),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(speechEngine.spokenMessages, isEmpty);
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('tts failure does not abort the sequence', () async {
      final speechEngine = _FakeSpeechEngine(
        throwOnSpeak: true,
      );
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
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
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
      expect(speechEngine.spokenMessages, isEmpty);
    });

    test('sequence events do not duplicate because of listeners or state reads', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.guide(text: 'First'),
              WorkoutSequenceStep.guide(text: 'Second'),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.addListener(() {
        controller.activeSequenceEvent;
        controller.session;
        controller.activeSequenceIteration;
      });

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['First', 'Second', 'End of exercise.'],
      );
    });

    test('end completes the sequence exactly once', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        ['End of exercise.'],
      );
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('existing workout exercise with no sequence still follows legacy execution', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: _FakeSpeechEngine(),
        timerService: timerService,
        workoutExercise: _legacyExercise(),
      );

      controller.startCountdown(seconds: 3);

      expect(
        controller.session.status,
        WorkoutSessionStatus.countdown,
      );
      expect(controller.session.remainingSeconds, 3);

      timerService.finish();
      await _flushAsyncWork();

      expect(
        controller.session.status,
        WorkoutSessionStatus.exercising,
      );
      expect(controller.session.remainingSeconds, 5);

      timerService.finish();
      await _flushAsyncWork();

      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('bicep curl reference sequence produces the expected ordered guidance semantics', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = _controller(
        speechEngine: speechEngine,
        timerService: timerService,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.guide(text: 'One stop bicep curl'),
              WorkoutSequenceStep.guide(
                text: 'Be in position. Hold the dumbbell in position.',
              ),
              WorkoutSequenceStep.guide(
                text: 'Workout begins in 5 seconds',
              ),
              WorkoutSequenceStep.count(
                count: 5,
                direction: WorkoutCountDirection.descending,
              ),
              WorkoutSequenceStep.counter(repetitionCount: 2),
              WorkoutSequenceStep.guide(text: 'Up'),
              WorkoutSequenceStep.guide(text: 'Hold'),
              WorkoutSequenceStep.count(
                count: 2,
                direction: WorkoutCountDirection.ascending,
              ),
              WorkoutSequenceStep.guide(text: 'Squeeze'),
              WorkoutSequenceStep.guide(text: 'Release'),
              WorkoutSequenceStep.guide(text: 'Hold'),
              WorkoutSequenceStep.count(
                count: 2,
                direction: WorkoutCountDirection.ascending,
              ),
              WorkoutSequenceStep.guide(text: 'Release'),
              WorkoutSequenceStep.relax(durationInSeconds: 1),
              WorkoutSequenceStep.sequenceBreak(),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        [
          'One stop bicep curl',
          'Be in position. Hold the dumbbell in position.',
          'Workout begins in 5 seconds',
          '5',
          '4',
          '3',
          '2',
          '1',
          '1',
          'Up',
          'Hold',
          '1',
          '2',
          'Squeeze',
          'Release',
          'Hold',
          '1',
          '2',
          'Release',
        ],
      );

      timerService.finish();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages,
        [
          'One stop bicep curl',
          'Be in position. Hold the dumbbell in position.',
          'Workout begins in 5 seconds',
          '5',
          '4',
          '3',
          '2',
          '1',
          '1',
          'Up',
          'Hold',
          '1',
          '2',
          'Squeeze',
          'Release',
          'Hold',
          '1',
          '2',
          'Release',
          '2',
          'Up',
          'Hold',
          '1',
          '2',
          'Squeeze',
          'Release',
          'Hold',
          '1',
          '2',
          'Release',
        ],
      );

      timerService.finish();
      await _flushAsyncWork();

      expect(
        speechEngine.spokenMessages.last,
        'End of exercise.',
      );
      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
    });

    test('speech is serialized and later guide speech does not race ahead', () async {
      final speechEngine = _FakeSpeechEngine(
        blockSpeaks: true,
      );
      final controller = _controller(
        speechEngine: speechEngine,
        workoutExercise: _sequenceExercise(
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.guide(text: 'First'),
              WorkoutSequenceStep.guide(text: 'Second'),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(speechEngine.spokenMessages, ['First']);
      expect(speechEngine.pendingSpeakCount, 1);

      speechEngine.completeNextSpeak();
      await _flushAsyncWork();
      expect(
        speechEngine.spokenMessages,
        ['First', 'Second'],
      );

      speechEngine.completeNextSpeak();
      await _flushAsyncWork();
      expect(
        speechEngine.spokenMessages,
        ['First', 'Second', 'End of exercise.'],
      );
    });
  });

  group('WorkoutSessionController workout orchestration', () {
    test('workout with multiple exercises starts exercise 1', () {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _legacyExercise(durationInSeconds: 5),
            _legacyExercise(
              id: 'legacy-exercise-2',
              durationInSeconds: 7,
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
      );

      controller.startCountdown(seconds: 3);

      expect(controller.currentExerciseNumber, 1);
      expect(controller.totalExerciseCount, 2);
      expect(controller.completedExerciseCount, 0);
      expect(
        controller.session.status,
        WorkoutSessionStatus.countdown,
      );
      expect(controller.session.remainingSeconds, 3);
    });

    test('completing exercise 1 automatically starts exercise 2 and updates progress', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _legacyExercise(
              id: 'legacy-exercise-1',
              durationInSeconds: 5,
            ),
            _legacyExercise(
              id: 'legacy-exercise-2',
              durationInSeconds: 7,
            ),
            _legacyExercise(
              id: 'legacy-exercise-3',
              durationInSeconds: 9,
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.currentExerciseNumber, 1);
      expect(controller.completedExerciseCount, 0);

      timerService.finish();
      await _flushAsyncWork();

      expect(controller.currentExerciseNumber, 2);
      expect(controller.completedExerciseCount, 1);
      expect(controller.session.currentExercise.id, 'legacy-exercise-2');
      expect(
        controller.session.status,
        WorkoutSessionStatus.exercising,
      );
      expect(controller.session.remainingSeconds, 7);

      timerService.finish();
      await _flushAsyncWork();

      expect(controller.currentExerciseNumber, 3);
      expect(controller.completedExerciseCount, 2);
      expect(controller.session.currentExercise.id, 'legacy-exercise-3');
    });

    test('completing final exercise completes workout exactly once', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _legacyExercise(durationInSeconds: 5),
            _legacyExercise(
              id: 'legacy-exercise-2',
              durationInSeconds: 7,
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
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
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();

      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
      expect(controller.completedExerciseCount, 2);
      expect(completedNotifications, 1);
    });

    test('sequence to sequence transition works', () async {
      final speechEngine = _FakeSpeechEngine();
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _sequenceExercise(
              id: 'sequence-1',
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.guide(text: 'First'),
                  WorkoutSequenceStep.end(),
                ],
              ),
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
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: speechEngine,
        ),
        timerService: timerService,
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'sequence-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.completedExerciseCount, 1);
      expect(
        controller.activeSequenceEvent?.type,
        WorkoutSequenceEventType.relax,
      );
      expect(
        speechEngine.spokenMessages,
        ['First', 'End of exercise.', 'Second'],
      );
    });

    test('legacy to legacy transition works', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _legacyExercise(
              id: 'legacy-1',
              durationInSeconds: 4,
            ),
            _legacyExercise(
              id: 'legacy-2',
              durationInSeconds: 6,
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.completedExerciseCount, 1);
      expect(controller.session.remainingSeconds, 6);
    });

    test('sequence to legacy transition works', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _sequenceExercise(
              id: 'sequence-1',
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
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
      );

      controller.startCountdown();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.completedExerciseCount, 1);
      expect(controller.session.remainingSeconds, 6);
      expect(
        controller.session.status,
        WorkoutSessionStatus.exercising,
      );
    });

    test('legacy to sequence transition works', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _legacyExercise(
              id: 'legacy-1',
              durationInSeconds: 4,
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
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'sequence-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.completedExerciseCount, 1);
      expect(
        controller.activeSequenceEvent?.type,
        WorkoutSequenceEventType.relax,
      );
    });

    test('counter values remain independent across multiple sequence exercises', () async {
      final speechEngine = _FakeSpeechEngine();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _sequenceExercise(
              id: 'sequence-1',
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.counter(repetitionCount: 2),
                  WorkoutSequenceStep.guide(text: 'A'),
                  WorkoutSequenceStep.sequenceBreak(),
                  WorkoutSequenceStep.end(),
                ],
              ),
            ),
            _sequenceExercise(
              id: 'sequence-2',
              sequenceDefinition: WorkoutSequenceDefinition(
                steps: [
                  WorkoutSequenceStep.counter(repetitionCount: 3),
                  WorkoutSequenceStep.guide(text: 'B'),
                  WorkoutSequenceStep.sequenceBreak(),
                  WorkoutSequenceStep.end(),
                ],
              ),
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: speechEngine,
        ),
        timerService: _FakeWorkoutTimerService(),
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
          'B',
          '2',
          'B',
          '3',
          'B',
          'End of exercise.',
        ],
      );
    });

    test('pause and resume do not cause duplicate progression across exercises', () async {
      final timerService = _FakeWorkoutTimerService();
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [
            _legacyExercise(
              id: 'legacy-1',
              durationInSeconds: 4,
            ),
            _legacyExercise(
              id: 'legacy-2',
              durationInSeconds: 6,
            ),
          ],
        ),
        voiceCoach: VoiceCoachService(
          speechEngine: _FakeSpeechEngine(),
        ),
        timerService: timerService,
      );

      controller.startCountdown(seconds: 1);
      timerService.finish();
      await _flushAsyncWork();

      controller.pause();
      timerService.tick();
      await _flushAsyncWork();
      expect(controller.currentExerciseNumber, 1);
      expect(controller.completedExerciseCount, 0);

      controller.resume();
      timerService.finish();
      await _flushAsyncWork();

      expect(controller.session.currentExercise.id, 'legacy-2');
      expect(controller.currentExerciseNumber, 2);
      expect(controller.completedExerciseCount, 1);

      timerService.finish();
      await _flushAsyncWork();

      expect(
        controller.session.status,
        WorkoutSessionStatus.completed,
      );
      expect(controller.completedExerciseCount, 2);
    });

    test('voice-disabled session still progresses through all exercises', () async {
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
              id: 'sequence-1',
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
      expect(controller.completedExerciseCount, 2);
    });
  });
}

WorkoutSessionController _controller({
  _FakeSpeechEngine? speechEngine,
  VoiceCoachService? voiceCoach,
  WorkoutTimerService? timerService,
  required WorkoutExercise workoutExercise,
}) {
  return WorkoutSessionController(
    session: WorkoutSession(
      workoutExercises: [workoutExercise],
    ),
    voiceCoach:
        voiceCoach ?? VoiceCoachService(speechEngine: speechEngine ?? _FakeSpeechEngine()),
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

WorkoutExercise _countSecondsExercise() {
  return _sequenceExercise(
    sequenceDefinition: WorkoutSequenceDefinition(
      steps: [
        WorkoutSequenceStep.countSeconds(
          count: 2,
          direction: WorkoutCountDirection.ascending,
        ),
        WorkoutSequenceStep.end(),
      ],
    ),
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
  _FakeSpeechEngine({
    this.throwOnSpeak = false,
    this.blockSpeaks = false,
  });

  final bool throwOnSpeak;
  final bool blockSpeaks;
  final List<String> spokenMessages = [];
  final List<Completer<void>> _pendingSpeaks = [];
  int pauseCount = 0;
  int resumeCount = 0;
  int stopCount = 0;

  int get pendingSpeakCount => _pendingSpeaks.length;

  @override
  Future<void> speak(String text) async {
    if (throwOnSpeak) {
      throw StateError('TTS unavailable');
    }

    spokenMessages.add(text);

    if (!blockSpeaks) {
      return;
    }

    final completer = Completer<void>();
    _pendingSpeaks.add(completer);
    await completer.future;
  }

  void completeNextSpeak() {
    if (_pendingSpeaks.isEmpty) {
      return;
    }

    _pendingSpeaks.removeAt(0).complete();
  }

  @override
  Future<void> stop() async {
    stopCount += 1;
    while (_pendingSpeaks.isNotEmpty) {
      _pendingSpeaks.removeAt(0).complete();
    }
  }

  @override
  Future<void> pause() async {
    pauseCount += 1;
  }

  @override
  Future<void> resume() async {
    resumeCount += 1;
  }

  @override
  Future<void> setPitch(double pitch) async {}

  @override
  Future<void> setSpeechRate(double rate) async {}

  @override
  Future<void> setVolume(double volume) async {}
}

class _FakeWorkoutTimerService extends WorkoutTimerService {
  bool _isRunning = false;
  bool _isPaused = false;
  int _remainingSeconds = 0;
  int startCount = 0;
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
    startCount += 1;
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
