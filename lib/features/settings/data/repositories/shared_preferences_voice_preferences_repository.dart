import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/voice_preferences.dart';
import '../../domain/repositories/voice_preferences_repository.dart';

class SharedPreferencesVoicePreferencesRepository
    implements VoicePreferencesRepository {
  SharedPreferencesVoicePreferencesRepository({
    SharedPreferencesAsync? preferences,
  }) : this._internal(preferences);

  SharedPreferencesVoicePreferencesRepository._internal(this._preferences);

  static const _enabledKey = 'voice_coach_enabled';
  static const _speechRateKey = 'voice_coach_speech_rate';
  static const _pitchKey = 'voice_coach_pitch';
  static const _volumeKey = 'voice_coach_volume';

  SharedPreferencesAsync? _preferences;

  SharedPreferencesAsync get _storage =>
      _preferences ??= SharedPreferencesAsync();

  @override
  Future<VoicePreferences> load() async {
    final enabled = await _storage.getBool(_enabledKey);
    final speechRate = await _storage.getDouble(_speechRateKey);
    final pitch = await _storage.getDouble(_pitchKey);
    final volume = await _storage.getDouble(_volumeKey);

    return VoicePreferences(
      isEnabled: enabled ?? true,
      speechRate: speechRate ?? VoicePreferences.defaultSpeechRate,
      pitch: pitch ?? VoicePreferences.defaultPitch,
      volume: volume ?? VoicePreferences.defaultVolume,
    );
  }

  @override
  Future<void> save(VoicePreferences preferences) async {
    await _storage.setBool(_enabledKey, preferences.isEnabled);
    await _storage.setDouble(_speechRateKey, preferences.speechRate);
    await _storage.setDouble(_pitchKey, preferences.pitch);
    await _storage.setDouble(_volumeKey, preferences.volume);
  }
}
