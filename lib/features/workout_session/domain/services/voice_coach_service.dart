import '../entities/workout_event.dart';

class VoiceCoachService {
  const VoiceCoachService();

  String? buildMessage(
    WorkoutEvent event,
  ) {
    switch (event.type) {
      case WorkoutEventType.countdownStarted:
        return 'Get Ready';

      case WorkoutEventType.countdownTick:
        return event.message;

      case WorkoutEventType.exerciseStarted:
        return event.message;

      case WorkoutEventType.exerciseCompleted:
        return 'Exercise Complete';

      case WorkoutEventType.restStarted:
        return event.message;

      case WorkoutEventType.restCompleted:
        return 'Rest Complete';

      case WorkoutEventType.workoutPaused:
        return 'Workout Paused';

      case WorkoutEventType.workoutResumed:
        return 'Resume Workout';

      case WorkoutEventType.nextExercise:
        return event.message;

      case WorkoutEventType.previousExercise:
        return 'Previous Exercise';

      case WorkoutEventType.workoutCompleted:
        return 'Workout Complete';
    }
  }
}