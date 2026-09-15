import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import 'workout_builder_hud.dart';

class RestSelector extends StatelessWidget {
  const RestSelector({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  static const List<int> _restOptions = <int>[
    5,
    10,
    15,
    30,
    45,
    60,
    90,
    120,
    180,
    300,
  ];

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REST BETWEEN SETS',
            style: const TextStyle(
              color: ritmoCyan,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: value,
            dropdownColor: const Color(0xFF102027),
            style: const TextStyle(color: Color(0xFFF0FCFE)),
            decoration: ritmoHudInputDecoration(label: 'RECOVERY TIME'),
            items: _restOptions
                .map(
                  (seconds) => DropdownMenuItem<int>(
                    value: seconds,
                    child: Text(_formatDuration(seconds)),
                  ),
                )
                .toList(),
            onChanged: (selected) {
              if (selected != null) {
                onChanged(selected);
              }
            },
          ),
        ],
      ),
    );
  }

  static String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    }

    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    if (remainingSeconds == 0) {
      return '$minutes min';
    }

    return '$minutes min $remainingSeconds sec';
  }
}
