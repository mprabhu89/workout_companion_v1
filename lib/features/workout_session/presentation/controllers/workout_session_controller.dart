import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_sequence_event.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/services/voice_coach_service.dart';
import '../../domain/services/workout_engine.dart';
import '../../domain/services/workout_sequence_executor.dart';
import '../../domain/services/workout_timer_service.dart';

class WorkoutSessionController extends ChangeNotifier {
  WorkoutSessionController({
    required WorkoutSession session,
    VoiceCoachService? voiceCoach,
    WorkoutTimerService? timerService,
    WorkoutSequenceExecutor? sequenceExecutor,
  })  : _session = session,
        _engine = WorkoutEngine(session: session),
        // ignore: prefer_initializing_formals
        _voiceCoach = voiceCoach,
        _timerService = timerService ?? WorkoutTimerService(),
        _sequenceExecutor =
            sequenceExecutor ?? const WorkoutSequenceExecutor();

  WorkoutSession _session;

  final WorkoutEngine _engine;
  final VoiceCoachService? _voiceCoach;
  final WorkoutTimerService _timerService;
  final WorkoutSequenceExecutor _sequenceExecutor;

  WorkoutSessionStatus? _statusBeforePause;
  WorkoutSequenceEvent? _activeSequenceEvent;
  int? _lastAnnouncedIterationNumber;
  int _sequenceExecutionToken = 0;
  Completer<void>? _sequencePauseCompleter;
  Completer<void>? _sequenceWaitCompleter;
  bool _isSequenceExecutionRunning = false;

  WorkoutSession get session => _session;

  int get totalExerciseCount => _session.totalExercises;

  int get currentExerciseNumber =>
      _session.currentExerciseNumber;

  int get completedExerciseCount =>
      _session.completedExerciseCount;

  bool get isPaused =>
      _session.status == WorkoutSessionStatus.paused;

  bool get isSequenceExerciseInProgress =>
      _isSequenceExecutionRunning &&
      _activeSequenceEvent != null;

  WorkoutSequenceEvent? get activeSequenceEvent =>
      _activeSequenceEvent;

  int? get activeSequenceIteration =>
      _activeSequenceEvent?.iterationNumber;

  int? get activeSequenceIterationTotal =>
      _activeSequenceEvent?.iterationTotal;

  void _syncSession() {
    _session = _engine.session;
    notifyListeners();
  }

  void startCountdown({
    int seconds = 3,
  }) {
    if (_session.workoutExercises.isEmpty) {
      return;
    }

    final startedAt = _session.startedAt ?? DateTime.now();
    _engine.updateStartedAt(startedAt);

    if (_isSequenceExercise(_session.currentExercise)) {
      _startExercise();
      return;
    }

    _engine.updateStatus(
      WorkoutSessionStatus.countdown,
    );

    _engine.updateRemainingSeconds(seconds);

    _syncSession();

    _timerService.start(
      seconds: seconds,
      onTick: (remaining) {
        _engine.updateRemainingSeconds(
          remaining,
        );

        _syncSession();
      },
      onFinished: _startExercise,
    );
  }

  void pause() {
    if (_session.status ==
        WorkoutSessionStatus.completed) {
      return;
    }

    _statusBeforePause = _session.status;

    if (_timerService.isRunning) {
      _timerService.pause();
    }

    _engine.pause();

    _syncSession();
  }

  void resume() {
    if (_session.status != WorkoutSessionStatus.paused) {
      return;
    }

    if (_timerService.isPaused) {
      _timerService.resume();
    }

    _engine.resume(
      _statusBeforePause ??
          WorkoutSessionStatus.exercising,
    );

    if (_sequencePauseCompleter != null &&
        !_sequencePauseCompleter!.isCompleted) {
      _sequencePauseCompleter!.complete();
    }
    _sequencePauseCompleter = null;

    _syncSession();
  }

  void nextExercise() {
    _cancelSequenceExecution();
    _timerService.stop();

    _engine.nextExercise();

    _syncSession();

    if (!_engine.isCompleted) {
      _startExercise();
    }
  }

  void previousExercise() {
    _cancelSequenceExecution();
    _timerService.stop();

    _engine.previousExercise();

    _syncSession();

    _startExercise();
  }

  void finishWorkout() {
    _cancelSequenceExecution();
    _timerService.stop();

    _engine.finishWorkout(completedAt: DateTime.now());

    _syncSession();
  }

  void _startExercise() {
    final exercise = _engine.session.currentExercise;

    if (_isSequenceExercise(exercise)) {
      _startSequenceExercise();
      return;
    }

    _startLegacyExercise();
  }

  void _startLegacyExercise() {
    final exercise = _engine.session.currentExercise;
    final duration =
        exercise.durationInSeconds ?? 0;

    _engine.updateStatus(
      WorkoutSessionStatus.exercising,
    );

    _engine.updateRemainingSeconds(
      duration,
    );

    _syncSession();

    if (duration <= 0) {
      _startRest();
      return;
    }

    _timerService.start(
      seconds: duration,
      onTick: (remaining) {
        _engine.updateRemainingSeconds(
          remaining,
        );

        _syncSession();
      },
      onFinished: _startRest,
    );
  }

  void _startSequenceExercise() {
    final exercise = _engine.session.currentExercise;
    final sequenceDefinition = exercise.sequenceDefinition;

    if (sequenceDefinition == null ||
        sequenceDefinition.steps.isEmpty) {
      _startLegacyExercise();
      return;
    }

    _cancelSequenceExecution(stopVoice: false);

    final events = _sequenceExecutor.execute(
      workoutExercise: exercise,
      sequenceDefinition: sequenceDefinition,
    );

    _isSequenceExecutionRunning = true;
    _activeSequenceEvent = null;
    _lastAnnouncedIterationNumber = null;

    _engine.updateStatus(
      WorkoutSessionStatus.exercising,
    );
    _engine.updateRemainingSeconds(0);

    _syncSession();

    final executionToken = ++_sequenceExecutionToken;
    unawaited(
      _runSequenceExercise(
        executionToken: executionToken,
        events: events,
      ),
    );
  }

  Future<void> _runSequenceExercise({
    required int executionToken,
    required List<WorkoutSequenceEvent> events,
  }) async {
    for (final event in events) {
      if (executionToken != _sequenceExecutionToken) {
        return;
      }

      await _waitIfPaused(
        executionToken: executionToken,
      );

      if (executionToken != _sequenceExecutionToken) {
        return;
      }

      _activeSequenceEvent = event;

      if (event.type == WorkoutSequenceEventType.relax) {
        _engine.updateRemainingSeconds(
          event.durationInSeconds ?? 0,
        );
      } else {
        _engine.updateRemainingSeconds(0);
      }

      _syncSession();

      await _announceIterationIfNeeded(event);

      if (executionToken != _sequenceExecutionToken) {
        return;
      }

      switch (event.type) {
        case WorkoutSequenceEventType.guide:
          await _voiceCoach?.speakText(
            event.guideText ?? '',
          );
          break;
        case WorkoutSequenceEventType.count:
          await _voiceCoach?.speakText(
            '${event.countValue ?? ''}',
          );
          break;
        case WorkoutSequenceEventType.relax:
          await _waitForRelax(
            durationInSeconds:
                event.durationInSeconds ?? 0,
            executionToken: executionToken,
          );
          break;
        case WorkoutSequenceEventType.end:
          await _voiceCoach?.speakText(
            'End of exercise.',
          );
          _completeSequenceExercise(
            executionToken: executionToken,
          );
          return;
      }
    }
  }

  Future<void> _announceIterationIfNeeded(
    WorkoutSequenceEvent event,
  ) async {
    final iterationNumber = event.iterationNumber;

    if (iterationNumber == null ||
        iterationNumber == _lastAnnouncedIterationNumber) {
      return;
    }

    _lastAnnouncedIterationNumber = iterationNumber;
    await _voiceCoach?.speakText('$iterationNumber');
  }

  Future<void> _waitForRelax({
    required int durationInSeconds,
    required int executionToken,
  }) async {
    if (durationInSeconds <= 0) {
      return;
    }

    final waitCompleter = Completer<void>();
    _sequenceWaitCompleter = waitCompleter;

    _timerService.start(
      seconds: durationInSeconds,
      onTick: (remaining) {
        _engine.updateRemainingSeconds(remaining);
        _syncSession();
      },
      onFinished: () {
        if (!waitCompleter.isCompleted) {
          waitCompleter.complete();
        }
      },
    );

    await waitCompleter.future;

    if (identical(_sequenceWaitCompleter, waitCompleter)) {
      _sequenceWaitCompleter = null;
    }

    if (executionToken != _sequenceExecutionToken) {
      return;
    }

    _engine.updateRemainingSeconds(0);
    _syncSession();
  }

  Future<void> _waitIfPaused({
    required int executionToken,
  }) async {
    while (_session.status ==
        WorkoutSessionStatus.paused) {
      _sequencePauseCompleter ??=
          Completer<void>();
      await _sequencePauseCompleter!.future;

      if (executionToken != _sequenceExecutionToken) {
        return;
      }
    }
  }

  void _completeSequenceExercise({
    required int executionToken,
  }) {
    if (executionToken != _sequenceExecutionToken) {
      return;
    }

    _isSequenceExecutionRunning = false;
    _activeSequenceEvent = null;
    _lastAnnouncedIterationNumber = null;
    _engine.updateRemainingSeconds(0);
    _syncSession();
    _startRest();
  }

  void _startRest() {
    _cancelSequenceExecution(stopVoice: false);
    final exercise = _engine.session.currentExercise;

    final rest =
        exercise.restInSeconds ?? 0;

    _engine.updateStatus(
      WorkoutSessionStatus.resting,
    );

    _engine.updateRemainingSeconds(
      rest,
    );

    _syncSession();

    if (rest <= 0) {
      nextExercise();
      return;
    }

    _timerService.start(
      seconds: rest,
      onTick: (remaining) {
        _engine.updateRemainingSeconds(
          remaining,
        );

        _syncSession();
      },
      onFinished: nextExercise,
    );
  }

  @override
  void dispose() {
    _cancelSequenceExecution();
    _timerService.stop();
    super.dispose();
  }

  bool _isSequenceExercise(dynamic exercise) {
    final sequenceDefinition =
        exercise.sequenceDefinition;
    return sequenceDefinition != null &&
        sequenceDefinition.steps.isNotEmpty;
  }

  void _cancelSequenceExecution({
    bool stopVoice = true,
  }) {
    _sequenceExecutionToken += 1;
    _isSequenceExecutionRunning = false;
    _activeSequenceEvent = null;
    _lastAnnouncedIterationNumber = null;

    if (_sequencePauseCompleter != null &&
        !_sequencePauseCompleter!.isCompleted) {
      _sequencePauseCompleter!.complete();
    }
    _sequencePauseCompleter = null;

    if (_sequenceWaitCompleter != null &&
        !_sequenceWaitCompleter!.isCompleted) {
      _sequenceWaitCompleter!.complete();
    }
    _sequenceWaitCompleter = null;

    if (stopVoice) {
      unawaited(_voiceCoach?.stop());
    }
  }
}
