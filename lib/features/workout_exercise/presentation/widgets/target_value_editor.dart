import 'package:flutter/material.dart';

import '../../domain/entities/workout_target_type.dart';
import 'workout_builder_hud.dart';

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
    return WorkoutBuilderSection(title: 'TARGET VALUE', child: _buildEditor());
  }

  Widget _buildEditor() {
    switch (targetType) {
      case WorkoutTargetType.repetitions:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: ritmoHudInputDecoration(
            label: 'REPETITIONS',
            hint: 'e.g. 12',
          ),
        );

      case WorkoutTargetType.duration:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: ritmoHudInputDecoration(
            label: 'DURATION (SECONDS)',
            hint: 'e.g. 45',
          ),
        );

      case WorkoutTargetType.distance:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: ritmoHudInputDecoration(
            label: 'DISTANCE (METERS)',
            hint: 'e.g. 400',
          ),
        );

      case WorkoutTargetType.calories:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: ritmoHudInputDecoration(
            label: 'CALORIES',
            hint: 'e.g. 150',
          ),
        );

      case WorkoutTargetType.custom:
        return TextField(
          controller: controller,
          decoration: ritmoHudInputDecoration(
            label: 'CUSTOM TARGET',
            hint: 'Describe the target',
          ),
        );
    }
  }
}
