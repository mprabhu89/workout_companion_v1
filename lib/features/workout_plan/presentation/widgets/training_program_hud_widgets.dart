import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

/// Compact hierarchy and card treatments shared by the training-program flow.
class RitmoHierarchyPath extends StatelessWidget {
  const RitmoHierarchyPath({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Text(
            items[index],
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: index == items.length - 1
                  ? ritmoCyan
                  : const Color(0xFF78959B),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.05,
            ),
          ),
          if (index != items.length - 1)
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF54747B)),
        ],
      ],
    );
  }
}

class RitmoTrainingCard extends StatelessWidget {
  const RitmoTrainingCard({
    super.key,
    required this.systemLabel,
    required this.title,
    required this.summary,
    required this.onTap,
    this.metrics = const [],
    this.trailing,
    this.glowStrength = 0.22,
  });

  final String systemLabel;
  final String title;
  final String summary;
  final VoidCallback onTap;
  final List<String> metrics;
  final Widget? trailing;
  final double glowStrength;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      glowStrength: glowStrength,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: ritmoCyan.withValues(alpha: 0.14),
          highlightColor: ritmoOrange.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 4, height: 58, color: ritmoCyan),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        systemLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ritmoOrange,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFA8C2C7),
                        ),
                      ),
                      if (metrics.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: metrics
                              .map(
                                (metric) => Text(
                                  metric,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: const Color(0xFF86DDE6),
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.65,
                                      ),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailing ?? const Icon(Icons.chevron_right, color: ritmoCyan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
