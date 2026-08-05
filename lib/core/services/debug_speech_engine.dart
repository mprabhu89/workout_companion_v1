import 'package:flutter/foundation.dart';

import 'speech_engine.dart';

class DebugSpeechEngine
    implements SpeechEngine {
  @override
  Future<void> speak(
    String text,
  ) async {
    debugPrint(
      '[VOICE] $text',
    );
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> setPitch(
    double pitch,
  ) async {}

  @override
  Future<void> setSpeechRate(
    double rate,
  ) async {}

  @override
  Future<void> setVolume(
    double volume,
  ) async {}
}