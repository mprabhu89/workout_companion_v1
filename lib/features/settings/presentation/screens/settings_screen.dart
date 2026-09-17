import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/repository_registry.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/ritmo_hud_widgets.dart';
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
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF071216),
        foregroundColor: const Color(0xFFE2F9FC),
        title: const Text('SETTINGS'),
      ),
      body: RitmoCyberpunkBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const AppLoadingIndicator(message: 'Loading settings...');
            }

            final preferences = _controller.preferences;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              children: [
                const _ScreenHeader(),
                const SizedBox(height: 20),
                RitmoHudPanel(
                  glowStrength: preferences.isEnabled ? 0.32 : 0.08,
                  child: _VoiceCoachHeader(
                    isEnabled: preferences.isEnabled,
                    onChanged: (enabled) => _controller.update(
                      preferences.copyWith(isEnabled: enabled),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                RitmoHudPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RitmoHudSectionHeading(title: 'COACH MODE'),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose automatic guidance or keep one coach as your fixed preference.',
                        style: TextStyle(
                          color: Color(0xFFAAC2C7),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _CoachModeChoice(
                        key: const Key('coach-mode-auto'),
                        title: 'RITMO AUTO',
                        label: 'RECOMMENDED',
                        description:
                            'Selects the appropriate coach for your training type.',
                        icon: Icons.auto_awesome_outlined,
                        isSelected:
                            preferences.coachVoiceMode ==
                            CoachVoiceMode.ritmoAuto,
                        onTap: () => _controller.update(
                          preferences.copyWith(
                            coachVoiceMode: CoachVoiceMode.ritmoAuto,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CoachModeChoice(
                        key: const Key('coach-mode-fixed'),
                        title: 'CHOOSE MY COACH',
                        label: 'FIXED PREFERENCE',
                        description:
                            'Keep your selected RITMO coach for every training session.',
                        icon: Icons.record_voice_over_outlined,
                        isSelected:
                            preferences.coachVoiceMode ==
                            CoachVoiceMode.chooseMyCoach,
                        onTap: () => _controller.update(
                          preferences.copyWith(
                            coachVoiceMode: CoachVoiceMode.chooseMyCoach,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (preferences.coachVoiceMode ==
                    CoachVoiceMode.chooseMyCoach) ...[
                  const SizedBox(height: 14),
                  _CoachProfiles(
                    preferences: preferences,
                    onSelected: (profile) => _controller.update(
                      preferences.copyWith(
                        coachVoiceMode: CoachVoiceMode.chooseMyCoach,
                        selectedCoachVoice: profile,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                RitmoHudPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RitmoHudSectionHeading(title: 'VOICE PREVIEW'),
                      const SizedBox(height: 10),
                      const Text(
                        "Ready. Let's begin your workout.",
                        style: TextStyle(
                          color: Color(0xFFE5F8FA),
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Preview uses your current coach and delivery settings.',
                        style: TextStyle(
                          color: Color(0xFF9EB8BE),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      RitmoActionButton(
                        label: 'PREVIEW COACH',
                        onPressed: _controller.testVoice,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                RitmoHudPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RitmoHudSectionHeading(title: 'VOICE DELIVERY'),
                      const SizedBox(height: 14),
                      _HudSlider(
                        key: const Key('voice-pace-control'),
                        label: 'VOICE PACE',
                        lowLabel: 'SLOW',
                        highLabel: 'FAST',
                        value: preferences.voicePaceIndex.toDouble(),
                        min: 0,
                        max: 4,
                        divisions: 4,
                        displayValue: '${preferences.voicePaceMultiplier}x',
                        markers: const ['0.25x', '0.5x', '1x', '1.5x', '2x'],
                        onChanged: (value) => _controller.update(
                          preferences.copyWith(
                            speechRate:
                                VoicePreferences.speechRateForVoicePaceIndex(
                                  value.round(),
                                ),
                            isVoicePaceExplicit: true,
                          ),
                          persist: false,
                        ),
                        onChangeEnd: (_) => _controller.persist(),
                      ),
                      const SizedBox(height: 12),
                      _HudSlider(
                        key: const Key('pitch-control'),
                        label: 'PITCH',
                        lowLabel: 'LOW',
                        highLabel: 'HIGH',
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
                      const SizedBox(height: 12),
                      _HudSlider(
                        key: const Key('volume-control'),
                        label: 'VOLUME',
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
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTROL CENTER',
          style: TextStyle(
            color: ritmoCyan,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.1,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Configure your RITMO training guidance.',
          style: TextStyle(color: Color(0xFFB8CED2), fontSize: 16),
        ),
      ],
    );
  }
}

class _VoiceCoachHeader extends StatelessWidget {
  const _VoiceCoachHeader({required this.isEnabled, required this.onChanged});

  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ritmoCyan.withValues(alpha: 0.12),
            border: Border.all(color: ritmoCyan.withValues(alpha: 0.48)),
          ),
          child: const Icon(Icons.graphic_eq, color: ritmoCyan),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VOICE COACH',
                style: TextStyle(
                  color: Color(0xFFF0FCFD),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'COACH CONFIGURATION',
                style: TextStyle(
                  color: ritmoOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.25,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Voice guidance during active training.',
                style: TextStyle(color: Color(0xFFACC2C6), height: 1.25),
              ),
            ],
          ),
        ),
        Semantics(
          label: 'Voice Coach Enabled',
          child: Switch(value: isEnabled, onChanged: onChanged),
        ),
      ],
    );
  }
}

class _CoachModeChoice extends StatelessWidget {
  const _CoachModeChoice({
    super.key,
    required this.title,
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? ritmoCyan : const Color(0xFF31535C);
    return Semantics(
      selected: isSelected,
      button: true,
      label: title,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isSelected
                ? ritmoCyan.withValues(alpha: 0.12)
                : const Color(0xFF0A1519),
            border: Border.all(color: borderColor),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ritmoCyan.withValues(alpha: 0.16),
                      blurRadius: 12,
                    ),
                  ]
                : const [],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? ritmoCyan : const Color(0xFF9AB1B6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE9FAFC),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? ritmoOrange
                            : const Color(0xFF89A4AA),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.05,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFFAFC5C9),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? ritmoCyan : const Color(0xFF789398),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoachProfiles extends StatelessWidget {
  const _CoachProfiles({required this.preferences, required this.onSelected});

  final VoicePreferences preferences;
  final ValueChanged<CoachVoiceProfile> onSelected;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RitmoHudSectionHeading(title: 'COACH PROFILES'),
          const SizedBox(height: 8),
          const Text(
            'Voice matching uses compatible installed system voices when available.',
            style: TextStyle(color: Color(0xFFAAC2C7), height: 1.35),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = CoachVoiceProfile.values
                  .map(
                    (profile) => _CoachProfileCard(
                      profile: profile,
                      isSelected: preferences.selectedCoachVoice == profile,
                      onTap: () => onSelected(profile),
                    ),
                  )
                  .toList(growable: false);
              if (constraints.maxWidth < 330) {
                return Column(
                  children:
                      cards
                          .expand<Widget>(
                            (card) => [card, const SizedBox(height: 8)],
                          )
                          .toList()
                        ..removeLast(),
                );
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cards
                    .map(
                      (card) => SizedBox(
                        width: (constraints.maxWidth - 8) / 2,
                        child: card,
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CoachProfileCard extends StatelessWidget {
  const _CoachProfileCard({
    required this.profile,
    required this.isSelected,
    required this.onTap,
  });

  final CoachVoiceProfile profile;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gender = profile.preferredGender == CoachVoiceGender.male
        ? 'MALE PREFERENCE'
        : 'FEMALE PREFERENCE';
    return Semantics(
      selected: isSelected,
      button: true,
      label: '${profile.displayName}, $gender',
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 118),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? ritmoCyan.withValues(alpha: 0.13)
                : const Color(0xFF0A1519),
            border: Border.all(
              color: isSelected ? ritmoCyan : const Color(0xFF31535C),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      profile.displayName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFEAFBFC),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.65,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: ritmoCyan,
                      size: 18,
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                profile.description.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ritmoOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                gender,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9DB8BE),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudSlider extends StatelessWidget {
  const _HudSlider({
    super.key,
    required this.label,
    required this.lowLabel,
    required this.highLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
    required this.onChangeEnd,
    this.divisions,
    this.markers,
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
  final int? divisions;
  final List<String>? markers;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1519),
        border: Border.all(color: const Color(0xFF31535C)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFDFF6F8),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  color: ritmoCyan.withValues(alpha: 0.12),
                  child: Text(
                    displayValue,
                    style: const TextStyle(
                      color: ritmoCyan,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ritmoCyan,
                inactiveTrackColor: const Color(0xFF27434A),
                thumbColor: ritmoCyan,
                overlayColor: ritmoCyan.withValues(alpha: 0.12),
                trackHeight: 3,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),
            if (markers case final values?)
              Row(
                children: values
                    .map(
                      (marker) => Expanded(
                        child: Text(
                          marker,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: marker == displayValue
                                ? ritmoCyan
                                : const Color(0xFF88A4AA),
                            fontSize: 10,
                            fontWeight: marker == displayValue
                                ? FontWeight.w900
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lowLabel,
                    style: const TextStyle(
                      color: Color(0xFF88A4AA),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    highLabel,
                    style: const TextStyle(
                      color: Color(0xFF88A4AA),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
