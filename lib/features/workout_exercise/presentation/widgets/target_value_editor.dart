import 'package:flutter/material.dart';

import '../../domain/entities/workout_target_type.dart';

class TargetValueEditor extends StatelessWidget {
  const TargetValueEditor({
    super.key,
    required this.targetType,
    required this.controller,
  });

  final WorkoutTargetType targetType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildEditor(),
      ),
    );
  }

  Widget _buildEditor() {
    switch (targetType) {
      case WorkoutTargetType.repetitions:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Repetitions',
            hintText: 'e.g. 12',
            border: OutlineInputBorder(),
          ),
        );

      case WorkoutTargetType.duration:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Duration (seconds)',
            hintText: 'e.g. 45',
            border: OutlineInputBorder(),
          ),
        );

      case WorkoutTargetType.distance:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Distance (meters)',
            hintText: 'e.g. 400',
            border: OutlineInputBorder(),
          ),
        );

      case WorkoutTargetType.calories:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Calories',
            hintText: 'e.g. 150',
            border: OutlineInputBorder(),
          ),
        );

      case WorkoutTargetType.custom:
        return TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Custom Target',
            hintText: 'Describe the target',
            border: OutlineInputBorder(),
          ),
        );
    }
  }
}