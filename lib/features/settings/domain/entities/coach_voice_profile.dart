enum CoachVoiceMode { ritmoAuto, chooseMyCoach }

enum CoachVoiceGender { male, female }

enum CoachVoiceProfile {
  zen(
    displayName: 'Zen',
    description: 'Calm & Composed',
    preferredGender: CoachVoiceGender.male,
    neutralSpeechRate: 0.44,
    neutralPitch: 0.94,
  ),
  serena(
    displayName: 'Serena',
    description: 'Warm & Peaceful',
    preferredGender: CoachVoiceGender.female,
    neutralSpeechRate: 0.46,
    neutralPitch: 1.03,
  ),
  pulse(
    displayName: 'Pulse',
    description: 'Energetic & Motivating',
    preferredGender: CoachVoiceGender.male,
    neutralSpeechRate: 0.5,
    neutralPitch: 1.0,
  ),
  nova(
    displayName: 'Nova',
    description: 'Upbeat & Confident',
    preferredGender: CoachVoiceGender.female,
    neutralSpeechRate: 0.54,
    neutralPitch: 1.05,
  ),
  titan(
    displayName: 'Titan',
    description: 'Strong & Commanding',
    preferredGender: CoachVoiceGender.male,
    neutralSpeechRate: 0.48,
    neutralPitch: 0.91,
  ),
  valkyrie(
    displayName: 'Valkyrie',
    description: 'Sharp & Powerful',
    preferredGender: CoachVoiceGender.female,
    neutralSpeechRate: 0.52,
    neutralPitch: 1.02,
  );

  const CoachVoiceProfile({
    required this.displayName,
    required this.description,
    required this.preferredGender,
    required this.neutralSpeechRate,
    required this.neutralPitch,
  });

  final String displayName;
  final String description;
  final CoachVoiceGender preferredGender;

  /// Used only while the user retains the neutral delivery controls.
  final double neutralSpeechRate;
  final double neutralPitch;
}
