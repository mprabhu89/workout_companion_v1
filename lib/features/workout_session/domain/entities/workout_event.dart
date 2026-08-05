enum WorkoutEventType {
  countdownStarted,
  countdownTick,
  exerciseStarted,
  exerciseCompleted,
  restStarted,
  restCompleted,
  workoutPaused,
  workoutResumed,
  nextExercise,
  previousExercise,
  workoutCompleted,
}

class WorkoutEvent {
  const WorkoutEvent({
    required this.type,
    this.message,
  });

  final WorkoutEventType type;

  final String? message;
}