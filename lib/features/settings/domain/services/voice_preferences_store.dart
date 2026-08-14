import 'package:flutter/foundation.dart';

import '../entities/voice_preferences.dart';
import '../repositories/voice_preferences_repository.dart';

class VoicePreferencesStore extends ChangeNotifier {
  VoicePreferencesStore({required VoicePreferencesRepository repository})
    : this._internal(repository);

  VoicePreferencesStore._internal(this._repository);

  final VoicePreferencesRepository _repository;

  VoicePreferences _preferences = VoicePreferences();
  bool _isLoaded = false;

  VoicePreferences get preferences => _preferences;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    if (_isLoaded) {
      return;
    }

    try {
      _preferences = await _repository.load();
    } catch (_) {
      _preferences = VoicePreferences();
    }

    _isLoaded = true;
  }

  void setPreferences(VoicePreferences preferences) {
    _preferences = preferences;
    notifyListeners();
  }

  Future<void> persist() async {
    try {
      await _repository.save(_preferences);
    } catch (_) {
      // Settings remain usable with the current in-memory preferences.
    }
  }

  Future<void> update(VoicePreferences preferences) async {
    setPreferences(preferences);
    await persist();
  }
}
