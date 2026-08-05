import '../entities/completed_workout_session.dart';

abstract interface class WorkoutHistoryRepository {
  Future<List<CompletedWorkoutSession>>
      getCompletedSessions();

  Future<void> saveSession(
    CompletedWorkoutSession session,
  );

  Future<void> deleteSession(
    String sessionId,
  );

  Future<CompletedWorkoutSession?> getSessionById(
    String sessionId,
  );
}