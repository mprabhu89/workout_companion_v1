abstract interface class SpeechEngine {
  Future<void> speak(
    String text,
  );

  Future<void> stop();

  Future<void> pause();

  Future<void> resume();

  Future<void> setSpeechRate(
    double rate,
  );

  Future<void> setVolume(
    double volume,
  );

  Future<void> setPitch(
    double pitch,
  );
}

class SpeechVoice {
  const SpeechVoice({
    required this.name,
    required this.locale,
    this.gender,
  });

  final String name;
  final String locale;

  /// Present only when the platform explicitly reports it.
  final String? gender;
}

abstract interface class VoiceProfileSpeechEngine {
  Future<List<SpeechVoice>> getAvailableVoices();

  Future<void> setVoice(SpeechVoice voice);

  Future<void> clearVoice();
}
