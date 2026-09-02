import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/settings/domain/entities/coach_voice_profile.dart';
import 'package:workout_companion_v1/features/settings/domain/entities/voice_preferences.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/coach_voice_resolver.dart';

void main() {
  const resolver = CoachVoiceResolver();

  group('CoachVoiceResolver', () {
    test('RITMO Auto defaults to the safe general Pulse profile', () {
      expect(
        resolver.resolveProfile(preferences: VoicePreferences()),
        CoachVoiceProfile.pulse,
      );
    });

    test('a fixed coach selection overrides RITMO Auto category mapping', () {
      for (final profile in CoachVoiceProfile.values) {
        expect(
          resolver.resolveProfile(
            preferences: VoicePreferences(
              coachVoiceMode: CoachVoiceMode.chooseMyCoach,
              selectedCoachVoice: profile,
            ),
            workoutPlanCategory: WorkoutPlanCategory.strength,
          ),
          profile,
        );
      }
    });

    test('RITMO Auto maps only existing reliable plan categories', () {
      final preferences = VoicePreferences();

      expect(
        resolver.resolveProfile(
          preferences: preferences,
          workoutPlanCategory: WorkoutPlanCategory.mobility,
        ),
        CoachVoiceProfile.zen,
      );
      expect(
        resolver.resolveProfile(
          preferences: preferences,
          workoutPlanCategory: WorkoutPlanCategory.strength,
        ),
        CoachVoiceProfile.titan,
      );
      expect(
        resolver.resolveProfile(
          preferences: preferences,
          workoutPlanCategory: WorkoutPlanCategory.cardio,
        ),
        CoachVoiceProfile.pulse,
      );
      expect(
        resolver.resolveProfile(
          preferences: preferences,
          workoutPlanCategory: WorkoutPlanCategory.sports,
        ),
        CoachVoiceProfile.pulse,
      );
    });

    test('uses explicit gender metadata without inferring from voice names', () {
      final voices = [
        const SpeechVoice(
          name: 'System Female Label',
          locale: 'en-US',
        ),
        const SpeechVoice(
          name: 'System Voice Two',
          locale: 'en-US',
          gender: 'female',
        ),
      ];

      expect(
        resolver.resolveVoice(
          profile: CoachVoiceProfile.nova,
          availableVoices: voices,
        ),
        same(voices[1]),
      );
    });
  });
}
