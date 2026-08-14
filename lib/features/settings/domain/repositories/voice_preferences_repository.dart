import '../entities/voice_preferences.dart';

abstract interface class VoicePreferencesRepository {
  Future<VoicePreferences> load();

  Future<void> save(VoicePreferences preferences);
}
