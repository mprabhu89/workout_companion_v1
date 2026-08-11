import '../entities/workout_session.dart';

class WorkoutEngine {
  WorkoutEngine({
    required this._session,
  });

  WorkoutSession _session;

  WorkoutSession get session => _session;

  bool get hasNextExercise => _session.hasNextExercise;

  bool get hasPreviousExercise =>
      _session.currentExerciseIndex > 0;

  bool get isCompleted =>
      _session.status ==
      WorkoutSessionStatus.completed;

  void updateSession(
    WorkoutSession session,
  ) {
    _session = session;
  }

  void updateStatus(
    WorkoutSessionStatus status,
  ) {
    _session = _session.copyWith(
      status: status,
    );
  }

  void updateRemainingSeconds(
    int seconds,
  ) {
    _session = _session.copyWith(
      remainingSeconds: seconds,
    );
  }

  void updateStartedAt(DateTime startedAt) {
    _session = _session.copyWith(startedAt: startedAt);
  }

  void nextExercise() {
    if (!hasNextExercise) {
      finishWorkout();
      return;
    }

    _session = _session.copyWith(
      currentExerciseIndex:
          _session.currentExerciseIndex + 1,
      remainingSeconds: 0,
    );
  }

  void previousExercise() {
    if (!hasPreviousExercise) {
      return;
    }

    _session = _session.copyWith(
      currentExerciseIndex:
          _session.currentExerciseIndex - 1,
      remainingSeconds: 0,
    );
  }

  void pause() {
    _session = _session.copyWith(
      status: WorkoutSessionStatus.paused,
    );
  }

  void resume(
    WorkoutSessionStatus previousStatus,
  ) {
    _session = _session.copyWith(
      status: previousStatus,
    );
  }

  void finishWorkout({DateTime? completedAt}) {
    _session = _session.copyWith(
      status: WorkoutSessionStatus.completed,
      remainingSeconds: 0,
      completedAt: completedAt ?? DateTime.now(),
    );
  }

  void resetExerciseTimer() {
    final exercise = _session.currentExercise;

    _session = _session.copyWith(
      remainingSeconds:
          exercise.durationInSeconds ?? 0,
    );
  }
}
