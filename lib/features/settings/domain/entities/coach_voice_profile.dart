enum CoachVoiceMode {
  ritmoAuto,
  chooseMyCoach,
}

enum CoachVoiceGender {
  male,
  female,
}

enum CoachVoiceProfile {
  zen(
    displayName: 'Zen',
    description: 'Calm & Composed',
    preferredGender: CoachVoiceGender.male,
  ),
  serena(
    displayName: 'Serena',
    description: 'Warm & Peaceful',
    preferredGender: CoachVoiceGender.female,
  ),
  pulse(
    displayName: 'Pulse',
    description: 'Energetic & Motivating',
    preferredGender: CoachVoiceGender.male,
  ),
  nova(
    displayName: 'Nova',
    description: 'Upbeat & Confident',
    preferredGender: CoachVoiceGender.female,
  ),
  titan(
    displayName: 'Titan',
    description: 'Strong & Commanding',
    preferredGender: CoachVoiceGender.male,
  ),
  valkyrie(
    displayName: 'Valkyrie',
    description: 'Sharp & Powerful',
    preferredGender: CoachVoiceGender.female,
  );

  const CoachVoiceProfile({
    required this.displayName,
    required this.description,
    required this.preferredGender,
  });

  final String displayName;
  final String description;
  final CoachVoiceGender preferredGender;
}
