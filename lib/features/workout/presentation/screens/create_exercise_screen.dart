import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/exercise.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({
    super.key,
    required this.existingNames,
    this.exercise,
  });

  final List<String> existingNames;

  /// When supplied, the screen works in Edit mode.
  final Exercise? exercise;

  @override
  State<CreateExerciseScreen> createState() =>
      _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  static const Uuid _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.exercise?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.exercise?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Exercise name is required';
    }

    final normalized = name.toLowerCase();

    final currentName =
        widget.exercise?.name.trim().toLowerCase();

    final exists = widget.existingNames.any((item) {
      final candidate = item.trim().toLowerCase();

      if (_isEditing && candidate == currentName) {
        return false;
      }

      return candidate == normalized;
    });

    if (exists) {
      return 'An exercise with this name already exists';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exercise = Exercise(
      id: widget.exercise?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      defaultRestSeconds:
          widget.exercise?.defaultRestSeconds ?? 60,
      isEnabled: widget.exercise?.isEnabled ?? true,
    );

    Navigator.of(context).pop(exercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Exercise' : 'Create Exercise',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: !_isEditing,
                  decoration: const InputDecoration(
                    labelText: 'Exercise Name',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(
                      _isEditing ? 'Update' : 'Save',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}