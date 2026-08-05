import 'package:flutter_tts/flutter_tts.dart';

import 'speech_engine.dart';

class FlutterTtsSpeechEngine implements SpeechEngine {
  FlutterTtsSpeechEngine()
      : _tts = FlutterTts() {
    _tts.setSpeechRate(0.45);
    _tts.setPitch(1.0);
    _tts.setVolume(1.0);
  }

  final FlutterTts _tts;

  @override
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  Future<void> pause() async {
    await _tts.pause();
  }

  @override
  Future<void> resume() async {
    await _tts.speak('');
  }

  @override
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }
}