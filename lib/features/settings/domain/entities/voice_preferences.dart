import 'coach_voice_profile.dart';

class VoicePreferences {
  VoicePreferences({
    this.isEnabled = true,
    this.coachVoiceMode = CoachVoiceMode.ritmoAuto,
    this.selectedCoachVoice = CoachVoiceProfile.pulse,
    double speechRate = defaultSpeechRate,
    this.isVoicePaceExplicit = false,
    double pitch = defaultPitch,
    double volume = defaultVolume,
  }) : speechRate = _nearestSpeechRate(speechRate),
       pitch = _clamp(pitch, minPitch, maxPitch),
       volume = _clamp(volume, minVolume, maxVolume);

  static const double defaultSpeechRate = 0.35;
  static const List<double> voicePaceMultipliers = [0.25, 0.5, 1, 1.5, 2];
  static const List<double> voicePaceSpeechRates = [0.15, 0.25, 0.35, 0.45, 0.6];
  static const List<double> _previousVoicePaceSpeechRates = [
    0.25,
    0.33,
    0.42,
    0.55,
    0.7,
  ];
  static const List<Duration> voicePaceCoachCadenceDelays = [
    Duration(milliseconds: 1100),
    Duration(milliseconds: 900),
    Duration(milliseconds: 700),
    Duration(milliseconds: 500),
    Duration(milliseconds: 350),
  ];
  static const double defaultPitch = 1.0;
  static const double defaultVolume = 1.0;

  static const double minSpeechRate = 0.15;
  static const double maxSpeechRate = 0.6;
  static const double minPitch = 0.5;
  static const double maxPitch = 2.0;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;

  final bool isEnabled;
  final CoachVoiceMode coachVoiceMode;
  final CoachVoiceProfile selectedCoachVoice;
  final double speechRate;
  final bool isVoicePaceExplicit;
  final double pitch;
  final double volume;

  VoicePreferences copyWith({
    bool? isEnabled,
    CoachVoiceMode? coachVoiceMode,
    CoachVoiceProfile? selectedCoachVoice,
    double? speechRate,
    bool? isVoicePaceExplicit,
    double? pitch,
    double? volume,
  }) {
    return VoicePreferences(
      isEnabled: isEnabled ?? this.isEnabled,
      coachVoiceMode: coachVoiceMode ?? this.coachVoiceMode,
      selectedCoachVoice: selectedCoachVoice ?? this.selectedCoachVoice,
      speechRate: speechRate ?? this.speechRate,
      isVoicePaceExplicit: isVoicePaceExplicit ?? this.isVoicePaceExplicit,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
    );
  }

  static double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  int get voicePaceIndex {
    var closest = 0;
    for (var index = 1; index < voicePaceSpeechRates.length; index++) {
      if ((speechRate - voicePaceSpeechRates[index]).abs() <
          (speechRate - voicePaceSpeechRates[closest]).abs()) {
        closest = index;
      }
    }
    return closest;
  }

  double get voicePaceMultiplier => voicePaceMultipliers[voicePaceIndex];

  Duration get coachCadenceDelay =>
      voicePaceCoachCadenceDelays[voicePaceIndex];

  static double speechRateForVoicePaceIndex(int index) =>
      voicePaceSpeechRates[index.clamp(0, voicePaceSpeechRates.length - 1)];

  /// Keeps an existing selected Voice Pace on the same user-facing step when
  /// the engine-rate curve is recalibrated.
  static double normalizePersistedSpeechRate(double value) {
    for (var index = 0;
        index < _previousVoicePaceSpeechRates.length;
        index += 1) {
      if ((value - _previousVoicePaceSpeechRates[index]).abs() < 0.0001) {
        return voicePaceSpeechRates[index];
      }
    }
    return _nearestSpeechRate(value);
  }

  static double _nearestSpeechRate(double value) {
    final safe = _clamp(value, minSpeechRate, maxSpeechRate);
    return voicePaceSpeechRates.reduce((closest, candidate) =>
        (safe - candidate).abs() < (safe - closest).abs() ? candidate : closest);
  }
}
