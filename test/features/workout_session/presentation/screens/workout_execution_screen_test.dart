import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_history/domain/entities/completed_workout_session.dart';
import 'package:workout_companion_v1/features/workout_history/domain/repositories/workout_history_repository.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/controllers/workout_session_controller.dart';
import 'package:workout_companion_v1/features/workout_session/presentation/screens/workout_execution_screen.dart';

void main() {
  testWidgets(
    'history repository receives exactly one completed workout session',
    (tester) async {
      final historyRepository = _FakeWorkoutHistoryRepository();
      final voiceCoach = VoiceCoachService(
        speechEngine: _FakeSpeechEngine(),
      );
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise()],
          workoutPlanId: 'plan-1',
          workoutPlanName: 'Plan',
          workoutDayId: 'day-1',
          workoutDayName: 'Day 1',
          startedAt: DateTime(2026, 8, 13, 10, 0, 0),
          completedAt: DateTime(2026, 8, 13, 10, 5, 0),
          currentExerciseIndex: 0,
          status: WorkoutSessionStatus.completed,
        ),
        voiceCoach: voiceCoach,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: controller.session,
            controller: controller,
            voiceCoach: voiceCoach,
            workoutHistoryRepository: historyRepository,
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(historyRepository.savedSessions, hasLength(1));
      expect(
        historyRepository.savedSessions.single.completedExercises,
        1,
      );

      await tester.pump();
      expect(historyRepository.savedSessions, hasLength(1));
    },
  );
}

WorkoutExercise _exercise() {
  return const WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 1,
    targetType: WorkoutTargetType.duration,
    durationInSeconds: 30,
    restInSeconds: 0,
  );
}

class _FakeSpeechEngine implements SpeechEngine {
  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> setPitch(double pitch) async {}

  @override
  Future<void> setSpeechRate(double rate) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}

class _FakeWorkoutHistoryRepository
    implements WorkoutHistoryRepository {
  final List<CompletedWorkoutSession> savedSessions = [];

  @override
  Future<void> deleteSession(String sessionId) async {}

  @override
  Future<List<CompletedWorkoutSession>>
      getCompletedSessions() async {
    return List.unmodifiable(savedSessions);
  }

  @override
  Future<CompletedWorkoutSession?> getSessionById(
    String sessionId,
  ) async {
    try {
      return savedSessions.firstWhere(
        (session) => session.id == sessionId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveSession(
    CompletedWorkoutSession session,
  ) async {
    savedSessions.add(session);
  }
}
