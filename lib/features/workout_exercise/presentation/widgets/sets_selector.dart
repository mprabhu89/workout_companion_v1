import 'package:flutter/material.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'Sets',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const Spacer(),

            IconButton(
              onPressed: value > min
                  ? () => onChanged(value - 1)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),

            SizedBox(
              width: 56,
              child: Center(
                child: Text(
                  '$value',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),
              ),
            ),

            IconButton(
              onPressed: value < max
                  ? () => onChanged(value + 1)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}