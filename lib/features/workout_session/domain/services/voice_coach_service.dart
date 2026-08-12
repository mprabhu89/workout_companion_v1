import '../../../../core/services/speech_engine.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../entities/workout_session.dart';

class VoiceCoachService {
  factory VoiceCoachService({
    required SpeechEngine speechEngine,
    bool isEnabled = true,
  }) {
    return VoiceCoachService._(
      speechEngine: speechEngine,
      isEnabled: isEnabled,
    );
  }

  VoiceCoachService._({
    required this._speechEngine,
    this._isEnabled = true,
  });

  final SpeechEngine _speechEngine;
  final Set<String> _announcedKeys = {};

  bool _isEnabled;
  bool _isDisposed = false;

  bool get isEnabled => _isEnabled;

  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;

    if (!enabled) {
      await _safeStop();
    }
  }

  Future<void> announceSessionState({
    required WorkoutSession session,
    Exercise? currentExercise,
    Exercise? nextExercise,
  }) async {
    if (!_isEnabled ||
        _isDisposed ||
        session.workoutExercises.isEmpty) {
      return;
    }

    final announcement = _buildSessionAnnouncement(
      session: session,
      currentExercise: currentExercise,
      nextExercise: nextExercise,
    );

    if (announcement == null) {
      return;
    }

    if (!_announcedKeys.add(announcement.key)) {
      return;
    }

    await _safeSpeak(announcement.message);
  }

  Future<void> pause() async {
    if (!_isEnabled || _isDisposed) {
      return;
    }

    await _safePause();
  }

  Future<void> resume() async {
    if (!_isEnabled || _isDisposed) {
      return;
    }

    await _safeResume();
  }

  Future<void> speakText(String text) async {
    if (!_isEnabled || _isDisposed) {
      return;
    }

    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    await _safeSpeak(trimmed);
  }

  Future<void> stop() async {
    if (_isDisposed) {
      return;
    }

    await _safeStop();
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await _safeStop();
  }

  _VoiceAnnouncement? _buildSessionAnnouncement({
    required WorkoutSession session,
    Exercise? currentExercise,
    Exercise? nextExercise,
  }) {
    switch (session.status) {
      case WorkoutSessionStatus.notStarted:
      case WorkoutSessionStatus.paused:
        return null;

      case WorkoutSessionStatus.countdown:
        return _VoiceAnnouncement(
          key: 'countdown-${session.remainingSeconds}',
          message: session.remainingSeconds > 0
              ? 'Starting in ${session.remainingSeconds}'
              : 'Starting workout',
        );

      case WorkoutSessionStatus.exercising:
        return _VoiceAnnouncement(
          key: 'exercise-${session.currentExerciseIndex}',
          message: _buildExerciseStartMessage(
            workoutExercise: session.currentExercise,
            exercise: currentExercise,
          ),
        );

      case WorkoutSessionStatus.resting:
        return _VoiceAnnouncement(
          key: 'rest-${session.currentExerciseIndex}',
          message: _buildRestMessage(
            workoutExercise: session.currentExercise,
            nextExercise: nextExercise,
          ),
        );

      case WorkoutSessionStatus.completed:
        return const _VoiceAnnouncement(
          key: 'workout-completed',
          message: 'Workout complete. Great work.',
        );
    }
  }

  String _buildExerciseStartMessage({
    required WorkoutExercise workoutExercise,
    Exercise? exercise,
  }) {
    final parts = <String>[
      'Start ${exercise?.name ?? workoutExercise.exerciseId}',
    ];

    final prescription = _buildPrescription(
      workoutExercise,
    );

    if (prescription.isNotEmpty) {
      parts.add(prescription);
    }

    final instructions = exercise?.instructions.trim();

    if (instructions != null &&
        instructions.isNotEmpty) {
      parts.add(instructions);
    }

    return parts.join('. ');
  }

  String _buildRestMessage({
    required WorkoutExercise workoutExercise,
    Exercise? nextExercise,
  }) {
    final rest = workoutExercise.restInSeconds ?? 0;

    final parts = <String>[
      rest > 0
          ? 'Rest for $rest seconds'
          : 'Rest',
    ];

    if (nextExercise != null) {
      parts.add(
        'Next exercise, ${nextExercise.name}',
      );
    }

    return parts.join('. ');
  }

  String _buildPrescription(
    WorkoutExercise workoutExercise,
  ) {
    final parts = <String>[];

    if (workoutExercise.sets != null) {
      parts.add(
        '${workoutExercise.sets} sets',
      );
    }

    if (workoutExercise.repetitions != null) {
      parts.add(
        '${workoutExercise.repetitions} reps',
      );
    }

    if (workoutExercise.durationInSeconds != null) {
      parts.add(
        '${workoutExercise.durationInSeconds} seconds',
      );
    }

    return parts.join(', ');
  }

  Future<void> _safeSpeak(
    String message,
  ) async {
    try {
      await _speechEngine.speak(message);
    } catch (_) {
      // Voice coach must never block workout execution.
    }
  }

  Future<void> _safeStop() async {
    try {
      await _speechEngine.stop();
    } catch (_) {
      // Voice coach must never block workout execution.
    }
  }

  Future<void> _safePause() async {
    try {
      await _speechEngine.pause();
    } catch (_) {
      // Voice coach must never block workout execution.
    }
  }

  Future<void> _safeResume() async {
    try {
      await _speechEngine.resume();
    } catch (_) {
      // Voice coach must never block workout execution.
    }
  }
}

class _VoiceAnnouncement {
  const _VoiceAnnouncement({
    required this.key,
    required this.message,
  });

  final String key;
  final String message;
}
