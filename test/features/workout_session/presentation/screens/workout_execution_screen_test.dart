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
    'shows round progress when session repetition is greater than 1',
    (tester) async {
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise(sessionRepetitions: 3)],
          currentExerciseRound: 2,
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutExecutionScreen(
            session: controller.session,
            controller: controller,
            voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
            workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Round 2 of 3'), findsOneWidget);
    },
  );

  testWidgets(
    'history repository receives exactly one completed workout session',
    (tester) async {
      final historyRepository = _FakeWorkoutHistoryRepository();
      final voiceCoach = VoiceCoachService(speechEngine: _FakeSpeechEngine());
      final controller = WorkoutSessionController(
        session: WorkoutSession(
          workoutExercises: [_exercise(sessionRepetitions: 3)],
          workoutPlanId: 'plan-1',
          workoutPlanName: 'Plan',
          workoutDayId: 'day-1',
          workoutDayName: 'Day 1',
          startedAt: DateTime(2026, 8, 13, 10, 0, 0),
          completedAt: DateTime(2026, 8, 13, 10, 5, 0),
          currentExerciseIndex: 0,
          currentExerciseRound: 3,
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
      expect(historyRepository.savedSessions.single.completedExercises, 1);
      expect(historyRepository.savedSessions.single.totalExercises, 1);

      await tester.pump();
      expect(historyRepository.savedSessions, hasLength(1));
    },
  );

  testWidgets('active workout requires confirmation before leaving', (
    tester,
  ) async {
    final controller = WorkoutSessionController(
      session: WorkoutSession(
        workoutExercises: [_exercise()],
        status: WorkoutSessionStatus.exercising,
      ),
      voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutExecutionScreen(
                      session: controller.session,
                      controller: controller,
                      voiceCoach: VoiceCoachService(
                        speechEngine: _FakeSpeechEngine(),
                      ),
                      workoutHistoryRepository: _FakeWorkoutHistoryRepository(),
                    ),
                  ),
                ),
                child: const Text('Open Workout'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open Workout'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Leave workout?'), findsOneWidget);

    await tester.tap(find.text('Keep Workout'));
    await tester.pumpAndSettle();
    expect(find.text('Workout'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave Workout'));
    await tester.pumpAndSettle();

    expect(find.text('Open Workout'), findsOneWidget);
  });
}

WorkoutExercise _exercise({int sessionRepetitions = 1}) {
  return WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 1,
    targetType: WorkoutTargetType.duration,
    durationInSeconds: 30,
    restInSeconds: 0,
    sessionRepetitions: sessionRepetitions,
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

class _FakeWorkoutHistoryRepository implements WorkoutHistoryRepository {
  final List<CompletedWorkoutSession> savedSessions = [];

  @override
  Future<void> deleteSession(String sessionId) async {}

  @override
  Future<List<CompletedWorkoutSession>> getCompletedSessions() async {
    return List.unmodifiable(savedSessions);
  }

  @override
  Future<CompletedWorkoutSession?> getSessionById(String sessionId) async {
    try {
      return savedSessions.firstWhere((session) => session.id == sessionId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveSession(CompletedWorkoutSession session) async {
    savedSessions.add(session);
  }
}
