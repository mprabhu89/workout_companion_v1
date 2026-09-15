import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

class WorkoutBuilderHeader extends StatelessWidget {
  const WorkoutBuilderHeader({
    super.key,
    required this.stage,
    required this.title,
    required this.subtitle,
    this.stageLabel,
  });

  final int stage;
  final String title;
  final String subtitle;
  final String? stageLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CREATE WORKOUT',
          style: TextStyle(
            color: ritmoCyan,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.45,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'WORKOUT BUILDER',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFF0FCFE),
            fontWeight: FontWeight.w900,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 18),
        BuilderProgressIndicator(currentStage: stage),
        const SizedBox(height: 24),
        Text(
          '0$stage // ${stageLabel ?? title}',
          style: const TextStyle(
            color: ritmoCyan,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFF0FCFE),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFFA8C7CD),
            fontSize: 15,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class BuilderProgressIndicator extends StatelessWidget {
  const BuilderProgressIndicator({super.key, required this.currentStage});

  final int currentStage;

  @override
  Widget build(BuildContext context) {
    const labels = ['IDENTITY', 'EXERCISE', 'CONFIGURE'];
    return Row(
      children: List.generate(labels.length, (index) {
        final stage = index + 1;
        final isComplete = stage < currentStage;
        final isCurrent = stage == currentStage;
        final color = isComplete || isCurrent
            ? ritmoCyan
            : const Color(0xFF4D6970);
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? ritmoCyan.withValues(alpha: 0.16)
                      : Colors.transparent,
                  border: Border.all(color: color, width: isCurrent ? 1.5 : 1),
                  shape: BoxShape.circle,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: ritmoCyan.withValues(alpha: 0.22),
                            blurRadius: 9,
                          ),
                        ]
                      : const [],
                ),
                child: Icon(
                  isComplete ? Icons.check : Icons.circle,
                  color: color,
                  size: isComplete ? 15 : 7,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.55,
                  ),
                ),
              ),
              if (stage != labels.length)
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    color: stage < currentStage
                        ? ritmoCyan
                        : const Color(0xFF36545B),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class RitmoHudTextField extends StatelessWidget {
  const RitmoHudTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: Color(0xFFF0FCFE)),
      decoration: ritmoHudInputDecoration(label: label, hint: hint),
    );
  }
}

InputDecoration ritmoHudInputDecoration({required String label, String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: Color(0xFF9FC5CB)),
    hintStyle: const TextStyle(color: Color(0xFF6F9198)),
    filled: true,
    fillColor: const Color(0xE60A1519),
    alignLabelWithHint: true,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF365C66)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: ritmoCyan, width: 1.4),
    ),
  );
}

class WorkoutBuilderSection extends StatelessWidget {
  const WorkoutBuilderSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ritmoCyan,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle!,
              style: const TextStyle(color: Color(0xFFA8C7CD), fontSize: 13),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
