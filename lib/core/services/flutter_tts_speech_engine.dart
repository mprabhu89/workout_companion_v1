import 'package:flutter_tts/flutter_tts.dart';

import 'speech_engine.dart';

class FlutterTtsSpeechEngine
    implements SpeechEngine, VoiceProfileSpeechEngine {
  FlutterTtsSpeechEngine()
      : _tts = FlutterTts() {
    _tts.awaitSpeakCompletion(true);
    _tts.setSpeechRate(0.5);
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

  @override
  Future<List<SpeechVoice>> getAvailableVoices() async {
    final voices = await _tts.getVoices;

    if (voices is! List) {
      return const [];
    }

    return voices
        .whereType<Map>()
        .map(
          (voice) => SpeechVoice(
            name: voice['name']?.toString() ?? '',
            locale: voice['locale']?.toString() ?? '',
            gender: voice['gender']?.toString(),
          ),
        )
        .where((voice) => voice.name.isNotEmpty && voice.locale.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<void> setVoice(SpeechVoice voice) async {
    await _tts.setVoice({
      'name': voice.name,
      'locale': voice.locale,
    });
  }

  @override
  Future<void> clearVoice() async {
    await _tts.clearVoice();
  }
}
