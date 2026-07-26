import 'package:flutter/material.dart';

class ExerciseForm extends StatelessWidget {
  const ExerciseForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.onSave,
    this.saveButtonText = 'Save',
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final VoidCallback onSave;
  final String saveButtonText;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Exercise Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.save),
          label: Text(saveButtonText),
        ),
      ],
    );
  }
}