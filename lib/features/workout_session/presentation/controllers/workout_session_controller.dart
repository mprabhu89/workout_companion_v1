import 'package:flutter/foundation.dart';

import '../../domain/entities/workout_session.dart';
import '../../domain/services/workout_engine.dart';
import '../../domain/services/workout_timer_service.dart';

class WorkoutSessionController extends ChangeNotifier {
  WorkoutSessionController({
    required WorkoutSession session,
  })  : _session = session,
        _engine = WorkoutEngine(session: session);

  WorkoutSession _session;

  final WorkoutEngine _engine;

  final WorkoutTimerService _timerService =
      WorkoutTimerService();

  WorkoutSessionStatus? _statusBeforePause;

  WorkoutSession get session => _session;

  bool get isPaused => _timerService.isPaused;

  void _syncSession() {
    _session = _engine.session;
    notifyListeners();
  }

  void startCountdown({
    int seconds = 3,
  }) {
    final startedAt = _session.startedAt ?? DateTime.now();
    _engine.updateStartedAt(startedAt);
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

    _timerService.pause();

    _engine.pause();

    _syncSession();
  }

  void resume() {
    if (!_timerService.isPaused) {
      return;
    }

    _timerService.resume();

    _engine.resume(
      _statusBeforePause ??
          WorkoutSessionStatus.exercising,
    );

    _syncSession();
  }

  void nextExercise() {
    _timerService.stop();

    _engine.nextExercise();

    _syncSession();

    if (!_engine.isCompleted) {
      _startExercise();
    }
  }

  void previousExercise() {
    _timerService.stop();

    _engine.previousExercise();

    _syncSession();

    _startExercise();
  }

  void finishWorkout() {
    _timerService.stop();

    _engine.finishWorkout(completedAt: DateTime.now());

    _syncSession();
  }

  void _startExercise() {
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

  void _startRest() {
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
    _timerService.stop();
    super.dispose();
  }
}
