import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_mappers.dart';
import '../../../../core/database/isar_models.dart';
import '../../domain/entities/completed_workout_session.dart';
import '../../domain/repositories/workout_history_repository.dart';

class IsarWorkoutHistoryRepository
    implements WorkoutHistoryRepository {
  IsarWorkoutHistoryRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<CompletedWorkoutSession>>
      getCompletedSessions() async {
    final records = await _isar
        .isarCompletedWorkoutSessionRecords
        .where()
        .findAll();

    final sessions = records
        .toList()
      ..sort(
        (left, right) =>
            left.isarId.compareTo(right.isarId),
      );

    return List.unmodifiable(
      sessions.map(mapCompletedWorkoutSessionFromRecord),
    );
  }

  @override
  Future<void> saveSession(
    CompletedWorkoutSession session,
  ) async {
    final record =
        mapCompletedWorkoutSessionToRecord(session);
    final existing = await _isar
        .isarCompletedWorkoutSessionRecords
        .filter()
        .idEqualTo(session.id)
        .findFirst();

    if (existing != null) {
      record.isarId = existing.isarId;
    }

    await _isar.writeTxn(() async {
      await _isar
          .isarCompletedWorkoutSessionRecords
          .put(record);
    });
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final existing = await _isar
        .isarCompletedWorkoutSessionRecords
        .filter()
        .idEqualTo(sessionId)
        .findFirst();

    if (existing == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar
          .isarCompletedWorkoutSessionRecords
          .delete(existing.isarId);
    });
  }

  @override
  Future<CompletedWorkoutSession?> getSessionById(
    String sessionId,
  ) async {
    final record = await _isar
        .isarCompletedWorkoutSessionRecords
        .filter()
        .idEqualTo(sessionId)
        .findFirst();

    if (record == null) {
      return null;
    }

    return mapCompletedWorkoutSessionFromRecord(
      record,
    );
  }
}
