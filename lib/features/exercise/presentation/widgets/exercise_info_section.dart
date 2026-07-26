import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';

class ExerciseInfoSection extends StatelessWidget {
  const ExerciseInfoSection({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(exercise.muscleGroup.displayName),
              ),
              Chip(
                label: Text(exercise.equipment.displayName),
              ),
              Chip(
                label: Text(exercise.difficulty.displayName),
              ),
              Chip(
                label: Text(
                  exercise.isCustom
                      ? 'Custom'
                      : 'Built-in',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            exercise.description.isEmpty
                ? 'No description available.'
                : exercise.description,
          ),
          const SizedBox(height: 24),
          Text(
            'Instructions',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            exercise.instructions.isEmpty
                ? 'No instructions available.'
                : exercise.instructions,
          ),
        ],
      ),
    );
  }
}