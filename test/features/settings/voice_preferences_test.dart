import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/app/router/app_router.dart';
import 'package:workout_companion_v1/app/workout_companion_app.dart';
import 'package:workout_companion_v1/core/di/repository_registry.dart';
import 'package:workout_companion_v1/core/services/speech_engine.dart';
import 'package:workout_companion_v1/features/settings/domain/entities/coach_voice_profile.dart';
import 'package:workout_companion_v1/features/settings/domain/entities/voice_preferences.dart';
import 'package:workout_companion_v1/features/settings/domain/repositories/voice_preferences_repository.dart';
import 'package:workout_companion_v1/features/settings/domain/services/voice_preferences_store.dart';
import 'package:workout_companion_v1/features/settings/presentation/controllers/voice_preferences_controller.dart';
import 'package:workout_companion_v1/features/settings/presentation/screens/settings_screen.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/voice_coach_service.dart';

import '../../support/completing_startup_video_player.dart';

void main() {
  group('Voice preferences', () {
    test(
      'loads the current voice defaults when no preferences are saved',
      () async {
        final store = VoicePreferencesStore(repository: _MemoryRepository());

        await store.load();

        expect(store.preferences.isEnabled, isTrue);
        expect(store.preferences.coachVoiceMode, CoachVoiceMode.ritmoAuto);
        expect(store.preferences.selectedCoachVoice, CoachVoiceProfile.pulse);
        expect(store.preferences.speechRate, 0.35);
        expect(store.preferences.voicePaceMultiplier, 1);
        expect(
          store.preferences.coachCadenceDelay,
          const Duration(milliseconds: 700),
        );
        expect(store.preferences.pitch, 1.0);
        expect(store.preferences.volume, 1.0);
      },
    );

    test(
      'persists coach selection and delivery preferences across a new store',
      () async {
        final repository = _MemoryRepository();
        final firstStore = VoicePreferencesStore(repository: repository);
        await firstStore.load();
        await firstStore.update(
          VoicePreferences(
            isEnabled: false,
            coachVoiceMode: CoachVoiceMode.chooseMyCoach,
            selectedCoachVoice: CoachVoiceProfile.valkyrie,
            speechRate: 0.6,
            isVoicePaceExplicit: true,
            pitch: 1.2,
            volume: 0.75,
          ),
        );
        final reopenedStore = VoicePreferencesStore(repository: repository);

        await reopenedStore.load();

        expect(reopenedStore.preferences.isEnabled, isFalse);
        expect(
          reopenedStore.preferences.coachVoiceMode,
          CoachVoiceMode.chooseMyCoach,
        );
        expect(
          reopenedStore.preferences.selectedCoachVoice,
          CoachVoiceProfile.valkyrie,
        );
        expect(reopenedStore.preferences.speechRate, 0.6);
        expect(reopenedStore.preferences.isVoicePaceExplicit, isTrue);
        expect(reopenedStore.preferences.pitch, 1.2);
        expect(reopenedStore.preferences.volume, 0.75);
      },
    );

    test('constrains rate, pitch, and volume to supported ranges', () {
      final preferences = VoicePreferences(speechRate: 9, pitch: -1, volume: 3);

      expect(preferences.speechRate, VoicePreferences.maxSpeechRate);
      expect(preferences.pitch, VoicePreferences.minPitch);
      expect(preferences.volume, VoicePreferences.maxVolume);
    });

    test('normalizes arbitrary rates to the five Voice Pace steps', () {
      expect(VoicePreferences(speechRate: 0.16).voicePaceMultiplier, 0.25);
      expect(VoicePreferences(speechRate: 0.34).voicePaceMultiplier, 1);
      expect(VoicePreferences(speechRate: 0.44).voicePaceMultiplier, 1.5);
      expect(VoicePreferences(speechRate: 0.8).voicePaceMultiplier, 2);
    });

    test('preserves previous Voice Pace selections on the calmer curve', () {
      expect(VoicePreferences.normalizePersistedSpeechRate(0.25), 0.15);
      expect(VoicePreferences.normalizePersistedSpeechRate(0.33), 0.25);
      expect(VoicePreferences.normalizePersistedSpeechRate(0.42), 0.35);
      expect(VoicePreferences.normalizePersistedSpeechRate(0.55), 0.45);
      expect(VoicePreferences.normalizePersistedSpeechRate(0.7), 0.6);
    });

    test('maps every Voice Pace step to its engine rate and coach delay', () {
      final expected = <double, ({double rate, Duration delay})>{
        0.25: (rate: 0.15, delay: const Duration(milliseconds: 1100)),
        0.5: (rate: 0.25, delay: const Duration(milliseconds: 900)),
        1: (rate: 0.35, delay: const Duration(milliseconds: 700)),
        1.5: (rate: 0.45, delay: const Duration(milliseconds: 500)),
        2: (rate: 0.6, delay: const Duration(milliseconds: 350)),
      };

      for (
        var index = 0;
        index < VoicePreferences.voicePaceMultipliers.length;
        index++
      ) {
        final preferences = VoicePreferences(
          speechRate: VoicePreferences.speechRateForVoicePaceIndex(index),
        );
        final values = expected[preferences.voicePaceMultiplier]!;
        expect(preferences.speechRate, values.rate);
        expect(preferences.coachCadenceDelay, values.delay);
      }
    });

    test('all fixed coach profiles remain selectable', () {
      for (final profile in CoachVoiceProfile.values) {
        final preferences = VoicePreferences(
          coachVoiceMode: CoachVoiceMode.chooseMyCoach,
          selectedCoachVoice: profile,
        );

        expect(preferences.coachVoiceMode, CoachVoiceMode.chooseMyCoach);
        expect(preferences.selectedCoachVoice, profile);
      }
    });

    test('storage failure keeps safe in-memory preferences', () async {
      final store = VoicePreferencesStore(
        repository: _MemoryRepository(throwOnLoad: true, throwOnSave: true),
      );

      await store.load();
      await store.update(VoicePreferences(isEnabled: false));

      expect(store.preferences.isEnabled, isFalse);
      expect(store.preferences.speechRate, VoicePreferences.defaultSpeechRate);
    });

    test(
      'applies saved configuration and skips workout speech when disabled',
      () async {
        final engine = _FakeSpeechEngine();
        final store = VoicePreferencesStore(
          repository: _MemoryRepository(
            value: VoicePreferences(
              isEnabled: false,
              coachVoiceMode: CoachVoiceMode.chooseMyCoach,
              selectedCoachVoice: CoachVoiceProfile.nova,
              speechRate: 0.6,
              isVoicePaceExplicit: true,
              pitch: 1.2,
              volume: 0.75,
            ),
          ),
        );
        final voiceCoach = VoiceCoachService(speechEngine: engine);
        final controller = VoicePreferencesController(
          preferencesStore: store,
          voiceCoach: voiceCoach,
        );

        await controller.load();
        await voiceCoach.speakText('Guide still executes without speech.');

        expect(voiceCoach.isEnabled, isFalse);
        expect(engine.speechRates, [0.6]);
        expect(engine.pitches, [1.2]);
        expect(engine.volumes, [0.75]);
        expect(engine.spokenMessages, isEmpty);
      },
    );

    test(
      'test voice previews configured speech without enabling Voice Coach',
      () async {
        final engine = _FakeSpeechEngine();
        final store = VoicePreferencesStore(
          repository: _MemoryRepository(
            value: VoicePreferences(
              isEnabled: false,
              speechRate: 0.6,
              isVoicePaceExplicit: true,
              pitch: 1.1,
              volume: 0.5,
            ),
          ),
        );
        final voiceCoach = VoiceCoachService(speechEngine: engine);
        final controller = VoicePreferencesController(
          preferencesStore: store,
          voiceCoach: voiceCoach,
        );

        await controller.load();
        await controller.testVoice();

        expect(engine.speechRates, [0.6, 0.6]);
        expect(engine.pitches, [1.1, 1.1]);
        expect(engine.volumes, [0.5, 0.5]);
        expect(engine.spokenMessages, ["Ready. Let's begin your workout."]);
        expect(voiceCoach.isEnabled, isFalse);
      },
    );

    test('preview uses the selected installed coach voice', () async {
      final engine = _FakeSpeechEngine(
        availableVoices: const [
          SpeechVoice(name: 'Male', locale: 'en-US', gender: 'male'),
          SpeechVoice(name: 'Female', locale: 'en-US', gender: 'female'),
        ],
      );
      final controller = VoicePreferencesController(
        preferencesStore: VoicePreferencesStore(
          repository: _MemoryRepository(
            value: VoicePreferences(
              coachVoiceMode: CoachVoiceMode.chooseMyCoach,
              selectedCoachVoice: CoachVoiceProfile.nova,
            ),
          ),
        ),
        voiceCoach: VoiceCoachService(speechEngine: engine),
      );

      await controller.load();
      await controller.testVoice();

      expect(engine.selectedVoices.last.name, 'Female');
      expect(engine.spokenMessages.single, "Ready. Let's begin your workout.");
    });

    test(
      'voice discovery and voice-selection failures fall back safely',
      () async {
        final discoveryFailureEngine = _FakeSpeechEngine(
          throwOnVoiceDiscovery: true,
        );
        final selectionFailureEngine = _FakeSpeechEngine(
          availableVoices: const [
            SpeechVoice(name: 'Default', locale: 'en-US'),
          ],
          throwOnSetVoice: true,
        );
        final preferences = VoicePreferences(
          coachVoiceMode: CoachVoiceMode.chooseMyCoach,
          selectedCoachVoice: CoachVoiceProfile.serena,
        );

        final discoveryFailureCoach = VoiceCoachService(
          speechEngine: discoveryFailureEngine,
        );
        await discoveryFailureCoach.applyPreferences(preferences);
        await discoveryFailureCoach.speakText('Continue');

        final selectionFailureCoach = VoiceCoachService(
          speechEngine: selectionFailureEngine,
        );
        await selectionFailureCoach.applyPreferences(preferences);
        await selectionFailureCoach.speakText('Continue');

        expect(discoveryFailureEngine.spokenMessages, ['Continue']);
        expect(discoveryFailureEngine.clearVoiceCount, 1);
        expect(selectionFailureEngine.clearVoiceCount, 1);
        expect(selectionFailureEngine.spokenMessages, ['Continue']);
      },
    );

    test(
      'an unavailable preferred voice falls through to another installed voice',
      () async {
        final engine = _FakeSpeechEngine(
          availableVoices: const [
            SpeechVoice(name: 'Preferred', locale: 'en-US', gender: 'male'),
            SpeechVoice(name: 'Fallback', locale: 'en-US'),
          ],
          unavailableVoiceNames: {'Preferred'},
        );
        final coach = VoiceCoachService(speechEngine: engine);

        await coach.applyPreferences(
          VoicePreferences(
            coachVoiceMode: CoachVoiceMode.chooseMyCoach,
            selectedCoachVoice: CoachVoiceProfile.zen,
          ),
        );
        await coach.speakText('Continue');

        expect(engine.selectedVoices.single.name, 'Fallback');
        expect(engine.selectedVoices.single.locale, 'en-US');
        expect(engine.spokenMessages, ['Continue']);
      },
    );

    test(
      'all coach profiles continue speaking when only one voice is installed',
      () async {
        for (final profile in CoachVoiceProfile.values) {
          final engine = _FakeSpeechEngine(
            availableVoices: const [
              SpeechVoice(name: 'System', locale: 'en-US'),
            ],
          );
          final coach = VoiceCoachService(speechEngine: engine);

          await coach.applyPreferences(
            VoicePreferences(
              coachVoiceMode: CoachVoiceMode.chooseMyCoach,
              selectedCoachVoice: profile,
            ),
          );
          await coach.speakText('Continue');

          expect(engine.spokenMessages, ['Continue']);
        }
      },
    );

    test(
      'neutral controls use the selected coach delivery characteristics',
      () async {
        final engine = _FakeSpeechEngine();
        final coach = VoiceCoachService(speechEngine: engine);

        await coach.applyPreferences(
          VoicePreferences(
            coachVoiceMode: CoachVoiceMode.chooseMyCoach,
            selectedCoachVoice: CoachVoiceProfile.zen,
          ),
        );

        expect(engine.speechRates, [VoicePreferences.defaultSpeechRate]);
        expect(engine.pitches, [CoachVoiceProfile.zen.neutralPitch]);
        expect(engine.volumes, [VoicePreferences.defaultVolume]);
      },
    );

    test(
      'custom pace, pitch, and volume override coach delivery defaults',
      () async {
        final engine = _FakeSpeechEngine();
        final coach = VoiceCoachService(speechEngine: engine);

        await coach.applyPreferences(
          VoicePreferences(
            coachVoiceMode: CoachVoiceMode.chooseMyCoach,
            selectedCoachVoice: CoachVoiceProfile.titan,
            speechRate: 0.6,
            isVoicePaceExplicit: true,
            pitch: 1.18,
            volume: 0.72,
          ),
        );

        expect(engine.speechRates, [0.6]);
        expect(engine.pitches, [1.18]);
        expect(engine.volumes, [0.72]);
      },
    );

    testWidgets(
      'Settings renders the Control Center and updates voice preferences',
      (tester) async {
        final store = VoicePreferencesStore(
          repository: _MemoryRepository(
            value: VoicePreferences(
              speechRate: 0.45,
              isVoicePaceExplicit: true,
              pitch: 1.2,
              volume: 0.75,
            ),
          ),
        );
        final controller = VoicePreferencesController(
          preferencesStore: store,
          voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
        );

        await tester.pumpWidget(
          MaterialApp(home: SettingsScreen(controller: controller)),
        );
        await tester.pumpAndSettle();

        expect(find.text('SETTINGS'), findsOneWidget);
        expect(find.text('CONTROL CENTER'), findsOneWidget);
        expect(find.text('VOICE COACH'), findsOneWidget);
        expect(find.text('COACH CONFIGURATION'), findsOneWidget);
        expect(find.text('RITMO AUTO'), findsOneWidget);
        expect(find.text('CHOOSE MY COACH'), findsOneWidget);
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(controller.preferences.isEnabled, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const Key('voice-pace-control')),
          240,
        );
        expect(find.text('1.5x'), findsWidgets);
        expect(find.text('1.20'), findsOneWidget);
        expect(find.text('75%'), findsOneWidget);

        await tester.drag(find.byType(Scrollable), const Offset(0, 1000));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('coach-mode-fixed')));
        await tester.pumpAndSettle();
        expect(find.text('COACH PROFILES'), findsOneWidget);
        for (final profile in CoachVoiceProfile.values) {
          expect(find.text(profile.displayName.toUpperCase()), findsOneWidget);
        }

        await tester.ensureVisible(find.text('ZEN'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('ZEN'));
        await tester.pumpAndSettle();

        expect(
          controller.preferences.coachVoiceMode,
          CoachVoiceMode.chooseMyCoach,
        );
        expect(
          controller.preferences.selectedCoachVoice,
          CoachVoiceProfile.zen,
        );
      },
    );

    testWidgets('Settings keeps the five discrete Voice Pace values readable', (
      tester,
    ) async {
      final controller = VoicePreferencesController(
        preferencesStore: VoicePreferencesStore(
          repository: _MemoryRepository(),
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );

      await tester.pumpWidget(
        MaterialApp(home: SettingsScreen(controller: controller)),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('voice-pace-control')),
        240,
      );
      expect(find.text('VOICE PACE'), findsOneWidget);
      for (final pace in const ['0.25x', '0.5x', '1x', '1.5x', '2x']) {
        expect(find.text(pace), findsWidgets);
      }
      expect(
        find.descendant(
          of: find.byKey(const Key('voice-pace-control')),
          matching: find.byType(Slider),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Settings remains usable in a narrow portrait viewport', (
      tester,
    ) async {
      final controller = VoicePreferencesController(
        preferencesStore: VoicePreferencesStore(
          repository: _MemoryRepository(
            value: VoicePreferences(
              coachVoiceMode: CoachVoiceMode.chooseMyCoach,
              selectedCoachVoice: CoachVoiceProfile.valkyrie,
            ),
          ),
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(home: SettingsScreen(controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.text('CONTROL CENTER'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Settings renders fixed coach profiles on a narrow device', (
      tester,
    ) async {
      final controller = VoicePreferencesController(
        preferencesStore: VoicePreferencesStore(
          repository: _MemoryRepository(
            value: VoicePreferences(
              coachVoiceMode: CoachVoiceMode.chooseMyCoach,
            ),
          ),
        ),
        voiceCoach: VoiceCoachService(speechEngine: _FakeSpeechEngine()),
      );
      await tester.binding.setSurfaceSize(const Size(280, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(home: SettingsScreen(controller: controller)),
      );
      await tester.pumpAndSettle();

      for (final profile in CoachVoiceProfile.values) {
        expect(find.text(profile.displayName.toUpperCase()), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('Dashboard opens Settings', (tester) async {
      final engine = _FakeSpeechEngine();
      RepositoryRegistry.voicePreferencesStore = VoicePreferencesStore(
        repository: _MemoryRepository(),
      );
      RepositoryRegistry.speechEngineFactory = () => engine;

      await tester.pumpWidget(
        WorkoutCompanionApp(
          router: createAppRouter(
            startupVideoPlayerFactory: CompletingStartupVideoPlayer.new,
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (var index = 0; index < 5; index += 1) {
        await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
        await tester.pumpAndSettle();
      }
      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('lobby-card-Settings')),
          matching: find.text('ENTER'),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('SETTINGS'), findsOneWidget);
      expect(find.text('CONTROL CENTER'), findsOneWidget);
    });
  });
}

class _MemoryRepository implements VoicePreferencesRepository {
  _MemoryRepository({
    this.value,
    this.throwOnLoad = false,
    this.throwOnSave = false,
  });

  VoicePreferences? value;
  final bool throwOnLoad;
  final bool throwOnSave;

  @override
  Future<VoicePreferences> load() async {
    if (throwOnLoad) {
      throw StateError('Storage unavailable');
    }
    return value ?? VoicePreferences();
  }

  @override
  Future<void> save(VoicePreferences preferences) async {
    if (throwOnSave) {
      throw StateError('Storage unavailable');
    }
    value = preferences;
  }
}

class _FakeSpeechEngine implements SpeechEngine, VoiceProfileSpeechEngine {
  _FakeSpeechEngine({
    this.availableVoices = const [],
    this.throwOnVoiceDiscovery = false,
    this.throwOnSetVoice = false,
    this.unavailableVoiceNames = const {},
  });

  final List<SpeechVoice> availableVoices;
  final bool throwOnVoiceDiscovery;
  final bool throwOnSetVoice;
  final Set<String> unavailableVoiceNames;
  final List<String> spokenMessages = [];
  final List<double> speechRates = [];
  final List<double> pitches = [];
  final List<double> volumes = [];
  final List<SpeechVoice> selectedVoices = [];
  int clearVoiceCount = 0;

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> setPitch(double pitch) async {
    pitches.add(pitch);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    speechRates.add(rate);
  }

  @override
  Future<void> setVolume(double volume) async {
    volumes.add(volume);
  }

  @override
  Future<void> speak(String text) async {
    spokenMessages.add(text);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> clearVoice() async {
    clearVoiceCount += 1;
  }

  @override
  Future<List<SpeechVoice>> getAvailableVoices() async {
    if (throwOnVoiceDiscovery) {
      throw StateError('Voice discovery unavailable');
    }
    return availableVoices;
  }

  @override
  Future<void> setVoice(SpeechVoice voice) async {
    if (throwOnSetVoice || unavailableVoiceNames.contains(voice.name)) {
      throw StateError('Voice unavailable');
    }
    selectedVoices.add(voice);
  }
}
