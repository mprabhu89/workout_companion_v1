import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/exercise/domain/entities/exercise.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/difficulty_level.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/equipment_type.dart';
import 'package:workout_companion_v1/features/exercise/domain/enums/muscle_group.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_session.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';

void main() {
  group('VoiceCoachService', () {
    test('announces the same session state once', () async {
      final speechEngine = _FakeSpeechEngine();
      final service = VoiceCoachService(speechEngine: speechEngine);
      final session = _session(status: WorkoutSessionStatus.countdown);

      await service.announceSessionState(session: session);
      await service.announceSessionState(session: session);

      expect(speechEngine.spokenMessages, ['Starting in 3']);
    });

    test(
      'uses available exercise information in exercise announcements',
      () async {
        final speechEngine = _FakeSpeechEngine();
        final service = VoiceCoachService(speechEngine: speechEngine);

        await service.announceSessionState(
          session: _session(status: WorkoutSessionStatus.exercising),
          currentExercise: _exercise(),
        );

        expect(speechEngine.spokenMessages, hasLength(1));
        expect(
          speechEngine.spokenMessages.single,
          'Start Push Up. 3 sets, 12 reps. Keep your body in a straight line.',
        );
      },
    );

    test('disabling voice stops speech and skips announcements', () async {
      final speechEngine = _FakeSpeechEngine();
      final service = VoiceCoachService(speechEngine: speechEngine);

      await service.setEnabled(false);
      await service.announceSessionState(
        session: _session(status: WorkoutSessionStatus.exercising),
        currentExercise: _exercise(),
      );

      expect(speechEngine.stopCount, 1);
      expect(speechEngine.spokenMessages, isEmpty);
    });

    test('swallows speech engine failures', () async {
      final speechEngine = _FakeSpeechEngine(throwOnSpeak: true);
      final service = VoiceCoachService(speechEngine: speechEngine);

      await service.announceSessionState(
        session: _session(status: WorkoutSessionStatus.exercising),
        currentExercise: _exercise(),
      );

      expect(speechEngine.spokenMessages, isEmpty);
    });
  });
}

WorkoutSession _session({required WorkoutSessionStatus status}) {
  return WorkoutSession(
    workoutExercises: [_workoutExercise()],
    remainingSeconds: 3,
    status: status,
  );
}

WorkoutExercise _workoutExercise() {
  return const WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 3,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 12,
    restInSeconds: 30,
  );
}

Exercise _exercise() {
  return const Exercise(
    id: 'exercise-1',
    name: 'Push Up',
    description: 'Bodyweight push movement.',
    instructions: 'Keep your body in a straight line.',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.bodyweight,
    difficulty: DifficultyLevel.beginner,
  );
}

class _FakeSpeechEngine implements SpeechEngine {
  _FakeSpeechEngine({this.throwOnSpeak = false});

  final bool throwOnSpeak;
  final List<String> spokenMessages = [];
  int stopCount = 0;
  int pauseCount = 0;
  int resumeCount = 0;

  @override
  Future<void> speak(String text) async {
    if (throwOnSpeak) {
      throw StateError('TTS unavailable');
    }

    spokenMessages.add(text);
  }

  @override
  Future<void> stop() async {
    stopCount += 1;
  }

  @override
  Future<void> pause() async {
    pauseCount += 1;
  }

  @override
  Future<void> resume() async {
    resumeCount += 1;
  }

  @override
  Future<void> setPitch(double pitch) async {}

  @override
  Future<void> setSpeechRate(double rate) async {}

  @override
  Future<void> setVolume(double volume) async {}
}
