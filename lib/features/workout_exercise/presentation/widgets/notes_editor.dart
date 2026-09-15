import 'package:flutter/material.dart';

import 'workout_builder_hud.dart';

class NotesEditor extends StatelessWidget {
  const NotesEditor({super.key, required this.controller, this.maxLines = 4});

  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return WorkoutBuilderSection(
      title: 'NOTES',
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: ritmoHudInputDecoration(
          label: 'NOTES',
          hint: 'Optional notes for this exercise...',
        ),
      ),
    );
  }
}
