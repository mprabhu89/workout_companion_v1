import '../../domain/entities/completed_workout_session.dart';
import '../../domain/repositories/workout_history_repository.dart';

class InMemoryWorkoutHistoryRepository
    implements WorkoutHistoryRepository {
  final List<CompletedWorkoutSession>
      _sessions = [];

  @override
  Future<List<CompletedWorkoutSession>>
      getCompletedSessions() async {
    return List.unmodifiable(_sessions);
  }

  @override
  Future<void> saveSession(
    CompletedWorkoutSession session,
  ) async {
    final index = _sessions.indexWhere(
      (s) => s.id == session.id,
    );

    if (index >= 0) {
      _sessions[index] = session;
    } else {
      _sessions.add(session);
    }
  }

  @override
  Future<void> deleteSession(
    String sessionId,
  ) async {
    _sessions.removeWhere(
      (s) => s.id == sessionId,
    );
  }

  @override
  Future<CompletedWorkoutSession?>
      getSessionById(
    String sessionId,
  ) async {
    try {
      return _sessions.firstWhere(
        (s) => s.id == sessionId,
      );
    } catch (_) {
      return null;
    }
  }
}