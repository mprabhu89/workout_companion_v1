import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/core/services/flutter_tts_speech_engine.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_tts');
  late List<MethodCall> calls;
  late Object? voiceResponse;

  setUp(() {
    calls = [];
    voiceResponse = const [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          switch (call.method) {
            case 'isLanguageAvailable':
              return true;
            case 'setVoice':
              return 0;
            case 'getVoices':
              return voiceResponse;
            default:
              return 1;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'awaits initialization before speaking with the system fallback',
    () async {
      final engine = FlutterTtsSpeechEngine();

      await engine.speak('Voice coach is ready.');

      expect(
        calls.map((call) => call.method),
        containsAllInOrder([
          'awaitSpeakCompletion',
          'setSpeechRate',
          'setPitch',
          'setVolume',
          'isLanguageAvailable',
          'setLanguage',
          'stop',
          'speak',
        ]),
      );
    },
  );

  test('treats an Android-rejected voice selection as a failure', () async {
    final engine = FlutterTtsSpeechEngine();

    await expectLater(
      engine.setVoice(const SpeechVoice(name: 'Unavailable', locale: 'en-US')),
      throwsA(isA<StateError>()),
    );

    expect(calls.where((call) => call.method == 'setVoice'), hasLength(1));
  });

  test('normalizes and deduplicates Android voice metadata', () async {
    voiceResponse = const [
      {
        'name': ' Device Voice ',
        'locale': 'en_US',
        'gender': 'unknown',
        'network_required': '0',
      },
      {
        'name': 'Device Voice',
        'locale': 'en-US',
        'gender': 'female',
        'network_required': '1',
      },
    ];
    final engine = FlutterTtsSpeechEngine();

    final voices = await engine.getAvailableVoices();

    expect(voices, hasLength(1));
    expect(voices.single.name, 'Device Voice');
    expect(voices.single.locale, 'en-US');
    expect(voices.single.gender, isNull);
    expect(voices.single.requiresNetwork, isFalse);
  });
}
