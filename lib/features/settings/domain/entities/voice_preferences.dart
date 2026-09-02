import 'coach_voice_profile.dart';

class VoicePreferences {
  VoicePreferences({
    this.isEnabled = true,
    this.coachVoiceMode = CoachVoiceMode.ritmoAuto,
    this.selectedCoachVoice = CoachVoiceProfile.pulse,
    double speechRate = defaultSpeechRate,
    double pitch = defaultPitch,
    double volume = defaultVolume,
  }) : speechRate = _clamp(speechRate, minSpeechRate, maxSpeechRate),
       pitch = _clamp(pitch, minPitch, maxPitch),
       volume = _clamp(volume, minVolume, maxVolume);

  static const double defaultSpeechRate = 0.45;
  static const double defaultPitch = 1.0;
  static const double defaultVolume = 1.0;

  static const double minSpeechRate = 0.2;
  static const double maxSpeechRate = 0.8;
  static const double minPitch = 0.5;
  static const double maxPitch = 2.0;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;

  final bool isEnabled;
  final CoachVoiceMode coachVoiceMode;
  final CoachVoiceProfile selectedCoachVoice;
  final double speechRate;
  final double pitch;
  final double volume;

  VoicePreferences copyWith({
    bool? isEnabled,
    CoachVoiceMode? coachVoiceMode,
    CoachVoiceProfile? selectedCoachVoice,
    double? speechRate,
    double? pitch,
    double? volume,
  }) {
    return VoicePreferences(
      isEnabled: isEnabled ?? this.isEnabled,
      coachVoiceMode: coachVoiceMode ?? this.coachVoiceMode,
      selectedCoachVoice: selectedCoachVoice ?? this.selectedCoachVoice,
      speechRate: speechRate ?? this.speechRate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
    );
  }

  static double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
