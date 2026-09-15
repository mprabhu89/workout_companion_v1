import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

class ExerciseHeaderCard extends StatelessWidget {
  const ExerciseHeaderCard({
    super.key,
    required this.exerciseName,
    this.onChangeExercise,
  });

  final String exerciseName;
  final VoidCallback? onChangeExercise;

  @override
  Widget build(BuildContext context) {
    return RitmoHudPanel(
      padding: const EdgeInsets.all(16),
      glowStrength: 0.12,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ritmoCyan.withValues(alpha: 0.12),
              border: Border.all(color: ritmoCyan.withValues(alpha: 0.62)),
            ),
            child: const Icon(Icons.fitness_center, color: ritmoCyan),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              exerciseName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFF0FCFE),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (onChangeExercise != null)
            OutlinedButton(
              onPressed: onChangeExercise,
              child: const Text('Change'),
            ),
        ],
      ),
    );
  }
}
