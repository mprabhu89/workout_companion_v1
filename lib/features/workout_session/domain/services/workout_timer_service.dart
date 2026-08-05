import 'dart:async';

typedef TimerTickCallback = void Function(
  int remainingSeconds,
);

typedef TimerFinishedCallback = void Function();

class WorkoutTimerService {
  Timer? _timer;

  int _remainingSeconds = 0;

  TimerTickCallback? _onTick;

  TimerFinishedCallback? _onFinished;

  bool _isPaused = false;

  bool get isRunning =>
      _timer != null && _timer!.isActive;

  bool get isPaused => _isPaused;

  int get remainingSeconds =>
      _remainingSeconds;

  void start({
    required int seconds,
    required TimerTickCallback onTick,
    required TimerFinishedCallback onFinished,
  }) {
    stop();

    _remainingSeconds = seconds;
    _onTick = onTick;
    _onFinished = onFinished;
    _isPaused = false;

    _onTick?.call(_remainingSeconds);

    _startInternalTimer();
  }

  void pause() {
    if (!isRunning) {
      return;
    }

    _timer?.cancel();
    _timer = null;

    _isPaused = true;
  }

  void resume() {
    if (!_isPaused) {
      return;
    }

    _isPaused = false;

    _startInternalTimer();
  }

  void stop() {
    _timer?.cancel();

    _timer = null;

    _remainingSeconds = 0;

    _isPaused = false;
  }

  void _startInternalTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _remainingSeconds--;

        if (_remainingSeconds <= 0) {
          _timer?.cancel();

          _timer = null;

          _onFinished?.call();

          return;
        }

        _onTick?.call(_remainingSeconds);
      },
    );
  }
}