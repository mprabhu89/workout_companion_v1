import '../entities/completed_workout_session.dart';

class WorkoutStatisticsService {
  const WorkoutStatisticsService();

  int totalWorkouts(
    List<CompletedWorkoutSession> sessions,
  ) {
    return sessions.length;
  }

  int totalDurationInSeconds(
    List<CompletedWorkoutSession> sessions,
  ) {
    return sessions.fold(
      0,
      (sum, session) =>
          sum + session.durationInSeconds,
    );
  }

  double averageWorkoutDuration(
    List<CompletedWorkoutSession> sessions,
  ) {
    if (sessions.isEmpty) {
      return 0;
    }

    return totalDurationInSeconds(
          sessions,
        ) /
        sessions.length;
  }

  int completedWorkouts(
    List<CompletedWorkoutSession> sessions,
  ) {
    return sessions
        .where(
          (s) => s.wasCompleted,
        )
        .length;
  }

  double completionRate(
    List<CompletedWorkoutSession> sessions,
  ) {
    if (sessions.isEmpty) {
      return 0;
    }

    return completedWorkouts(
          sessions,
        ) /
        sessions.length;
  }
}