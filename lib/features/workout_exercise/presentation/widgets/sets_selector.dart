import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

class SetsSelector extends StatelessWidget {
  const SetsSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'SETS',
            style: const TextStyle(
              color: ritmoCyan,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: ritmoCyan,
          ),

          SizedBox(
            width: 56,
            child: Center(
              child: Text(
                '$value',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFF0FCFE),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
            color: ritmoCyan,
          ),
        ],
      ),
    );
  }
}
