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
    final usableVoices = _distinctUsableVoices(availableVoices);
    if (usableVoices.isEmpty) {
      return null;
    }

    final englishVoices = usableVoices
        .where((voice) => voice.locale.toLowerCase().startsWith('en'))
        .toList(growable: false);
    final localeCompatibleVoices = englishVoices.isEmpty
        ? usableVoices
        : englishVoices;
    final preferredGender = profile.preferredGender.name;
    final genderCompatibleVoices = localeCompatibleVoices
        .where((voice) => voice.gender?.toLowerCase() == preferredGender)
        .toList(growable: false);

    final candidates = genderCompatibleVoices.isEmpty
        ? localeCompatibleVoices
        : genderCompatibleVoices;
    final profileIndex = genderCompatibleVoices.isEmpty
        ? profile.index
        : _sameGenderProfileIndex(profile);

    return candidates[profileIndex % candidates.length];
  }

  SpeechVoice? resolveFallbackVoice({
    required List<SpeechVoice> availableVoices,
    SpeechVoice? excluding,
  }) {
    final fallbackVoices = _distinctUsableVoices(availableVoices)
        .where(
          (voice) =>
              voice.name != excluding?.name ||
              voice.locale != excluding?.locale,
        )
        .toList(growable: false);

    if (fallbackVoices.isEmpty) {
      return null;
    }

    return fallbackVoices
            .where((voice) => voice.locale.toLowerCase().startsWith('en'))
            .firstOrNull ??
        fallbackVoices.first;
  }

  List<SpeechVoice> _distinctUsableVoices(List<SpeechVoice> voices) {
    final offlineVoices = voices
        .where((voice) => !voice.requiresNetwork)
        .toList(growable: false);
    final candidates = offlineVoices.isEmpty ? voices : offlineVoices;
    final distinct = <String, SpeechVoice>{};

    for (final voice in candidates) {
      final identity =
          '${voice.locale.toLowerCase()}\u0000${voice.name.toLowerCase()}';
      distinct.putIfAbsent(identity, () => voice);
    }

    final result = distinct.values.toList(growable: false)
      ..sort((first, second) {
        final localeComparison = first.locale.compareTo(second.locale);
        return localeComparison != 0
            ? localeComparison
            : first.name.compareTo(second.name);
      });
    return result;
  }

  int _sameGenderProfileIndex(CoachVoiceProfile profile) {
    return switch (profile) {
      CoachVoiceProfile.zen || CoachVoiceProfile.serena => 0,
      CoachVoiceProfile.pulse || CoachVoiceProfile.nova => 1,
      CoachVoiceProfile.titan || CoachVoiceProfile.valkyrie => 2,
    };
  }
}
