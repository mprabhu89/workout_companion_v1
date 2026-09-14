import 'package:flutter_tts/flutter_tts.dart';

import 'speech_engine.dart';

class FlutterTtsSpeechEngine implements SpeechEngine, VoiceProfileSpeechEngine {
  FlutterTtsSpeechEngine() : _tts = FlutterTts();

  final FlutterTts _tts;
  Future<void>? _initialization;

  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;

  @override
  Future<void> speak(String text) async {
    await _ensureInitialized();
    await _tts.stop();
    _ensureSuccessful(await _tts.speak(text), operation: 'speak');
  }

  @override
  Future<void> stop() async {
    await _ensureInitialized();
    await _tts.stop();
  }

  @override
  Future<void> pause() async {
    await _ensureInitialized();
    await _tts.pause();
  }

  @override
  Future<void> resume() async {
    await _ensureInitialized();
    await _tts.speak('');
  }

  @override
  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    await _ensureInitialized();
    await _tts.setPitch(pitch);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _ensureInitialized();
    await _tts.setSpeechRate(rate);
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _ensureInitialized();
    await _tts.setVolume(volume);
  }

  @override
  Future<List<SpeechVoice>> getAvailableVoices() async {
    await _ensureInitialized();
    final voices = await _tts.getVoices;

    if (voices is! List) {
      return const [];
    }

    final distinctVoices = <String, SpeechVoice>{};
    for (final voice
        in voices
            .whereType<Map>()
            .map(
              (voice) => SpeechVoice(
                name: voice['name']?.toString().trim() ?? '',
                locale: _languageTag(voice['locale']?.toString().trim() ?? ''),
                gender: _normalizedGender(voice['gender']),
                requiresNetwork: _requiresNetwork(voice['network_required']),
              ),
            )
            .where((voice) => voice.name.isNotEmpty && voice.locale.isNotEmpty)
            .toList(growable: false)) {
      distinctVoices.putIfAbsent(_voiceIdentity(voice), () => voice);
    }

    final result = distinctVoices.values.toList(growable: false)
      ..sort((first, second) {
        final localeComparison = first.locale.compareTo(second.locale);
        return localeComparison != 0
            ? localeComparison
            : first.name.compareTo(second.name);
      });
    return result;
  }

  @override
  Future<void> setVoice(SpeechVoice voice) async {
    await _ensureInitialized();

    // Android only accepts a voice when its locale is active and the exact
    // name/locale pair is installed. It returns 0 instead of throwing when
    // either condition is not met.
    _ensureSuccessful(
      await _tts.setLanguage(_languageTag(voice.locale)),
      operation: 'setLanguage',
    );
    _ensureSuccessful(
      await _tts.setVoice({'name': voice.name, 'locale': voice.locale}),
      operation: 'setVoice',
    );
  }

  @override
  Future<void> clearVoice() async {
    await _ensureInitialized();
    await _tts.clearVoice();
  }

  Future<void> _ensureInitialized() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(_speechRate);
    await _tts.setPitch(_pitch);
    await _tts.setVolume(_volume);

    // Keep the platform default voice when English is unavailable. This is a
    // safe system-level fallback for devices whose installed TTS locale differs.
    try {
      final isAvailable = await _tts.isLanguageAvailable('en-US');
      if (_isSuccessful(isAvailable)) {
        _ensureSuccessful(
          await _tts.setLanguage('en-US'),
          operation: 'setLanguage',
        );
      }
    } catch (_) {
      // A system default voice can still speak if locale discovery fails.
    }
  }

  String _languageTag(String locale) => locale.replaceAll('_', '-');

  String _voiceIdentity(SpeechVoice voice) =>
      '${voice.locale.toLowerCase()}\u0000${voice.name.toLowerCase()}';

  String? _normalizedGender(Object? value) {
    final gender = value?.toString().trim().toLowerCase();
    return gender == 'male' || gender == 'female' ? gender : null;
  }

  bool _requiresNetwork(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == '1' || normalized == 'true';
  }

  bool _isSuccessful(dynamic result) {
    if (result is bool) {
      return result;
    }
    if (result is num) {
      return result > 0;
    }
    return true;
  }

  void _ensureSuccessful(dynamic result, {required String operation}) {
    if (!_isSuccessful(result)) {
      throw StateError('Flutter TTS $operation was rejected by the platform.');
    }
  }
}
