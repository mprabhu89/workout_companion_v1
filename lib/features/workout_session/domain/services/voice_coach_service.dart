import '../../../../core/services/speech_engine.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../settings/domain/entities/voice_preferences.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';
import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../entities/workout_session.dart';
import 'coach_voice_resolver.dart';

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

  VoiceCoachService._({required this._speechEngine, this._isEnabled = true});

  final SpeechEngine _speechEngine;
  final CoachVoiceResolver _coachVoiceResolver = const CoachVoiceResolver();
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

  Future<void> applyPreferences(
    VoicePreferences preferences, {
    WorkoutPlanCategory? workoutPlanCategory,
  }) async {
    if (_isDisposed) {
      return;
    }

    _isEnabled = preferences.isEnabled;
    await _safeConfigure(
      preferences,
      workoutPlanCategory: workoutPlanCategory,
    );

    if (!_isEnabled) {
      await _safeStop();
    }
  }

  Future<void> announceSessionState({
    required WorkoutSession session,
    Exercise? currentExercise,
    Exercise? nextExercise,
  }) async {
    if (!_isEnabled || _isDisposed || session.workoutExercises.isEmpty) {
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

  Future<void> previewText(String text) async {
    if (_isDisposed) {
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
          key:
              'exercise-${session.currentExerciseIndex}-${session.currentExerciseRound}',
          message: _buildExerciseStartMessage(
            workoutExercise: session.currentExercise,
            exercise: currentExercise,
          ),
        );

      case WorkoutSessionStatus.resting:
        return _VoiceAnnouncement(
          key:
              'rest-${session.currentExerciseIndex}-${session.currentExerciseRound}',
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

    final prescription = _buildPrescription(workoutExercise);

    if (prescription.isNotEmpty) {
      parts.add(prescription);
    }

    final instructions = exercise?.instructions.trim();

    if (instructions != null && instructions.isNotEmpty) {
      parts.add(instructions);
    }

    return parts.join('. ');
  }

  String _buildRestMessage({
    required WorkoutExercise workoutExercise,
    Exercise? nextExercise,
  }) {
    final rest = workoutExercise.restInSeconds ?? 0;

    final parts = <String>[rest > 0 ? 'Rest for $rest seconds' : 'Rest'];

    if (nextExercise != null) {
      parts.add('Next exercise, ${nextExercise.name}');
    }

    return parts.join('. ');
  }

  String _buildPrescription(WorkoutExercise workoutExercise) {
    final parts = <String>[];

    if (workoutExercise.sets != null) {
      parts.add('${workoutExercise.sets} sets');
    }

    if (workoutExercise.repetitions != null) {
      parts.add('${workoutExercise.repetitions} reps');
    }

    if (workoutExercise.durationInSeconds != null) {
      parts.add('${workoutExercise.durationInSeconds} seconds');
    }

    return parts.join(', ');
  }

  Future<void> _safeSpeak(String message) async {
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

  Future<void> _safeConfigure(
    VoicePreferences preferences, {
    WorkoutPlanCategory? workoutPlanCategory,
  }) async {
    try {
      await _speechEngine.setSpeechRate(preferences.speechRate);
      await _speechEngine.setPitch(preferences.pitch);
      await _speechEngine.setVolume(preferences.volume);
    } catch (_) {
      // Voice coach must never block workout execution.
    }

    await _safeConfigureCoachVoice(
      preferences,
      workoutPlanCategory: workoutPlanCategory,
    );
  }

  Future<void> _safeConfigureCoachVoice(
    VoicePreferences preferences, {
    WorkoutPlanCategory? workoutPlanCategory,
  }) async {
    final Object speechEngineCandidate = _speechEngine;
    if (speechEngineCandidate is! VoiceProfileSpeechEngine) {
      return;
    }
    final speechEngine = speechEngineCandidate;

    final profile = _coachVoiceResolver.resolveProfile(
      preferences: preferences,
      workoutPlanCategory: workoutPlanCategory,
    );

    List<SpeechVoice> voices;
    try {
      voices = await speechEngine.getAvailableVoices();
    } catch (_) {
      return;
    }

    final preferredVoice = _coachVoiceResolver.resolveVoice(
      profile: profile,
      availableVoices: voices,
    );

    if (preferredVoice == null) {
      await _safeClearVoice(speechEngine);
      return;
    }

    try {
      await speechEngine.setVoice(preferredVoice);
      return;
    } catch (_) {
      // Fall through to another compatible voice or the system default.
    }

    final fallbackVoice = _coachVoiceResolver.resolveFallbackVoice(
      availableVoices: voices,
      excluding: preferredVoice,
    );

    if (fallbackVoice != null) {
      try {
        await speechEngine.setVoice(fallbackVoice);
        return;
      } catch (_) {
        // Use the engine's normal system voice as the final fallback.
      }
    }

    await _safeClearVoice(speechEngine);
  }

  Future<void> _safeClearVoice(
    VoiceProfileSpeechEngine speechEngine,
  ) async {
    try {
      await speechEngine.clearVoice();
    } catch (_) {
      // Voice coach must never block workout execution.
    }
  }
}

class _VoiceAnnouncement {
  const _VoiceAnnouncement({required this.key, required this.message});

  final String key;
  final String message;
}
