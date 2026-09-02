import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../workout_session/domain/services/voice_coach_service.dart';
import '../../domain/entities/coach_voice_profile.dart';
import '../../domain/entities/voice_preferences.dart';
import '../controllers/voice_preferences_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.controller});

  final VoicePreferencesController? controller;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final VoicePreferencesController _controller;
  VoiceCoachService? _ownedVoiceCoach;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _ownedVoiceCoach = RepositoryRegistry.createVoiceCoach();
      _controller = VoicePreferencesController(
        preferencesStore: RepositoryRegistry.voicePreferencesStore,
        voiceCoach: _ownedVoiceCoach!,
      );
    }
    _controller.load();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
      unawaited(_ownedVoiceCoach?.dispose() ?? Future.value());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const AppLoadingIndicator(message: 'Loading settings...');
          }

          final preferences = _controller.preferences;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Voice Coach',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: SwitchListTile(
                  title: const Text('Voice Coach Enabled'),
                  value: preferences.isEnabled,
                  onChanged: (enabled) {
                    _controller.update(
                      preferences.copyWith(isEnabled: enabled),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: const Text('Coach Voice'),
                  subtitle: Text(
                    preferences.coachVoiceMode == CoachVoiceMode.ritmoAuto
                        ? 'RITMO Auto - Recommended'
                        : '${preferences.selectedCoachVoice.displayName} - ${preferences.selectedCoachVoice.description}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCoachVoicePicker(preferences),
                ),
              ),
              const SizedBox(height: 12),
              _VoiceSlider(
                label: 'Speech Rate',
                lowLabel: 'Slow',
                highLabel: 'Fast',
                value: preferences.speechRate,
                min: VoicePreferences.minSpeechRate,
                max: VoicePreferences.maxSpeechRate,
                displayValue: preferences.speechRate.toStringAsFixed(2),
                onChanged: (value) => _controller.update(
                  preferences.copyWith(speechRate: value),
                  persist: false,
                ),
                onChangeEnd: (_) => _controller.persist(),
              ),
              _VoiceSlider(
                label: 'Pitch',
                lowLabel: 'Low',
                highLabel: 'High',
                value: preferences.pitch,
                min: VoicePreferences.minPitch,
                max: VoicePreferences.maxPitch,
                displayValue: preferences.pitch.toStringAsFixed(2),
                onChanged: (value) => _controller.update(
                  preferences.copyWith(pitch: value),
                  persist: false,
                ),
                onChangeEnd: (_) => _controller.persist(),
              ),
              _VoiceSlider(
                label: 'Volume',
                lowLabel: '0%',
                highLabel: '100%',
                value: preferences.volume,
                min: VoicePreferences.minVolume,
                max: VoicePreferences.maxVolume,
                displayValue: '${(preferences.volume * 100).round()}%',
                onChanged: (value) => _controller.update(
                  preferences.copyWith(volume: value),
                  persist: false,
                ),
                onChangeEnd: (_) => _controller.persist(),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _controller.testVoice,
                icon: const Icon(Icons.volume_up_outlined),
                label: const Text('Test Voice'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showCoachVoicePicker(
    VoicePreferences preferences,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const ListTile(
              title: Text('Choose Coach Voice'),
            ),
            ListTile(
              title: const Text('RITMO Auto'),
              subtitle: const Text('Recommended'),
              trailing:
                  preferences.coachVoiceMode == CoachVoiceMode.ritmoAuto
                  ? const Icon(Icons.check)
                  : null,
              onTap: () async {
                await _controller.update(
                  preferences.copyWith(
                    coachVoiceMode: CoachVoiceMode.ritmoAuto,
                  ),
                );
                if (sheetContext.mounted) {
                  Navigator.of(sheetContext).pop();
                }
              },
            ),
            ...CoachVoiceProfile.values.map(
              (profile) => ListTile(
                title: Text(profile.displayName),
                subtitle: Text(profile.description),
                trailing:
                    preferences.coachVoiceMode == CoachVoiceMode.chooseMyCoach
                    && preferences.selectedCoachVoice == profile
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  await _controller.update(
                    preferences.copyWith(
                      coachVoiceMode: CoachVoiceMode.chooseMyCoach,
                      selectedCoachVoice: profile,
                    ),
                  );
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceSlider extends StatelessWidget {
  const _VoiceSlider({
    required this.label,
    required this.lowLabel,
    required this.highLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final String label;
  final String lowLabel;
  final String highLabel;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(label)),
                Text(displayValue),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(lowLabel), Text(highLabel)],
            ),
          ],
        ),
      ),
    );
  }
}
