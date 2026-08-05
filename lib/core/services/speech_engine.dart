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