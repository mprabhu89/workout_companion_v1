import 'package:flutter/material.dart';

import '../models/workout_exercise_view.dart';

class WorkoutExerciseCard extends StatelessWidget {
  const WorkoutExerciseCard({
    super.key,
    required this.view,
    required this.onTap,
    required this.onDelete,
  });

  final WorkoutExerciseView view;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          child: Text(
            '${view.workoutExercise.displayOrder}',
          ),
        ),

        title: Text(
          view.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(view.subtitle),

        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}