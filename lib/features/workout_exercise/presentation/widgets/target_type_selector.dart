import 'package:flutter/material.dart';

import '../../domain/entities/workout_target_type.dart';

class TargetTypeSelector extends StatelessWidget {
  const TargetTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final WorkoutTargetType value;
  final ValueChanged<WorkoutTargetType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: WorkoutTargetType.values.map((type) {
                return ChoiceChip(
                  label: Text(_label(type)),
                  selected: value == type,
                  onSelected: (_) => onChanged(type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _label(WorkoutTargetType type) {
    switch (type) {
      case WorkoutTargetType.repetitions:
        return 'Reps';
      case WorkoutTargetType.duration:
        return 'Time';
      case WorkoutTargetType.distance:
        return 'Distance';
      case WorkoutTargetType.calories:
        return 'Calories';
      case WorkoutTargetType.custom:
        return 'Custom';
    }
  }
}