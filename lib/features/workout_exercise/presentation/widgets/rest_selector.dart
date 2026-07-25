import 'package:flutter/material.dart';

class RestSelector extends StatelessWidget {
  const RestSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  static const List<int> _restOptions = <int>[
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rest Between Sets',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
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