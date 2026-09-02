import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../workout_session/domain/services/voice_coach_service.dart';
import '../../domain/entities/voice_preferences.dart';
import '../../domain/services/voice_preferences_store.dart';

class VoicePreferencesController extends ChangeNotifier {
  VoicePreferencesController({
    required VoicePreferencesStore preferencesStore,
    required VoiceCoachService voiceCoach,
  }) : this._internal(preferencesStore, voiceCoach);

  VoicePreferencesController._internal(
    this._preferencesStore,
    this._voiceCoach,
  ) {
    _preferencesStore.addListener(_onPreferencesChanged);
  }

  final VoicePreferencesStore _preferencesStore;
  final VoiceCoachService _voiceCoach;

  bool _isLoading = true;

  VoicePreferences get preferences => _preferencesStore.preferences;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    await _preferencesStore.load();
    await _voiceCoach.applyPreferences(preferences);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> update(
    VoicePreferences preferences, {
    bool persist = true,
  }) async {
    _preferencesStore.setPreferences(preferences);
    if (persist) {
      await _preferencesStore.persist();
    }
  }

  Future<void> persist() => _preferencesStore.persist();

  Future<void> testVoice() async {
    await _voiceCoach.applyPreferences(preferences);
    await _voiceCoach.previewText("Ready. Let's begin your workout.");
  }

  void _onPreferencesChanged() {
    unawaited(_voiceCoach.applyPreferences(preferences));
    notifyListeners();
  }

  @override
  void dispose() {
    _preferencesStore.removeListener(_onPreferencesChanged);
    super.dispose();
  }
}
