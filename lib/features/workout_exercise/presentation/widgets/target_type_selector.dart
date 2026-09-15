import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

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
    return RitmoHudPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TARGET TYPE',
            style: const TextStyle(
              color: ritmoCyan,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: WorkoutTargetType.values.map((type) {
              final selected = value == type;
              return ChoiceChip(
                label: Text(_label(type)),
                selected: selected,
                selectedColor: ritmoCyan.withValues(alpha: 0.18),
                backgroundColor: const Color(0xFF0A1519),
                side: BorderSide(
                  color: selected ? ritmoCyan : const Color(0xFF365C66),
                ),
                labelStyle: TextStyle(
                  color: selected
                      ? const Color(0xFFF0FCFE)
                      : const Color(0xFFA7C7CD),
                  fontWeight: FontWeight.w800,
                ),
                onSelected: (_) => onChanged(type),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _label(WorkoutTargetType type) {
    switch (type) {
      case WorkoutTargetType.repetitions:
        return 'Reps';
      case WorkoutTargetType.duration:
        return 'Duration';
      case WorkoutTargetType.distance:
        return 'Distance';
      case WorkoutTargetType.calories:
        return 'Calories';
      case WorkoutTargetType.custom:
        return 'Custom';
    }
  }
}
