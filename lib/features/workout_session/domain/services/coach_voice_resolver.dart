import '../../../../core/services/speech_engine.dart';
import '../../../settings/domain/entities/coach_voice_profile.dart';
import '../../../settings/domain/entities/voice_preferences.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';

class CoachVoiceResolver {
  const CoachVoiceResolver();

  CoachVoiceProfile resolveProfile({
    required VoicePreferences preferences,
    WorkoutPlanCategory? workoutPlanCategory,
  }) {
    if (preferences.coachVoiceMode == CoachVoiceMode.chooseMyCoach) {
      return preferences.selectedCoachVoice;
    }

    switch (workoutPlanCategory) {
      case WorkoutPlanCategory.mobility:
      case WorkoutPlanCategory.rehabilitation:
        return CoachVoiceProfile.zen;
      case WorkoutPlanCategory.strength:
      case WorkoutPlanCategory.hypertrophy:
        return CoachVoiceProfile.titan;
      case WorkoutPlanCategory.fatLoss:
      case WorkoutPlanCategory.cardio:
      case WorkoutPlanCategory.generalFitness:
      case WorkoutPlanCategory.sports:
      case WorkoutPlanCategory.custom:
      case null:
        return CoachVoiceProfile.pulse;
    }
  }

  SpeechVoice? resolveVoice({
    required CoachVoiceProfile profile,
    required List<SpeechVoice> availableVoices,
  }) {
    if (availableVoices.isEmpty) {
      return null;
    }

    final englishVoices = availableVoices
        .where((voice) => voice.locale.toLowerCase().startsWith('en'))
        .toList(growable: false);
    final localeCompatibleVoices =
        englishVoices.isEmpty ? availableVoices : englishVoices;
    final preferredGender = profile.preferredGender.name;
    final genderCompatibleVoice = localeCompatibleVoices
        .where(
          (voice) => voice.gender?.toLowerCase() == preferredGender,
        )
        .firstOrNull;

    return genderCompatibleVoice ?? localeCompatibleVoices.first;
  }

  SpeechVoice? resolveFallbackVoice({
    required List<SpeechVoice> availableVoices,
    SpeechVoice? excluding,
  }) {
    final fallbackVoices = availableVoices
        .where((voice) => voice.name != excluding?.name)
        .toList(growable: false);

    if (fallbackVoices.isEmpty) {
      return null;
    }

    return fallbackVoices
            .where((voice) => voice.locale.toLowerCase().startsWith('en'))
            .firstOrNull ??
        fallbackVoices.first;
  }
}
