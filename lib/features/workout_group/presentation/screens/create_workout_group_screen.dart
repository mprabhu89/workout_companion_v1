import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/workout_group.dart';

class CreateWorkoutGroupScreen extends StatefulWidget {
  const CreateWorkoutGroupScreen({
    super.key,
    required this.workoutDayId,
    required this.existingNames,
    this.workoutGroup,
  });

  final String workoutDayId;
  final List<String> existingNames;
  final WorkoutGroup? workoutGroup;

  bool get isEditing => workoutGroup != null;

  @override
  State<CreateWorkoutGroupScreen> createState() =>
      _CreateWorkoutGroupScreenState();
}

class _CreateWorkoutGroupScreenState
    extends State<CreateWorkoutGroupScreen> {
  static const _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _displayOrderController;

  bool get _isEditing => widget.workoutGroup != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.workoutGroup?.name ?? '',
    );

    _displayOrderController = TextEditingController(
      text: (widget.workoutGroup?.displayOrder ?? 1).toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Workout group name is required';
    }

    final normalized = name.toLowerCase();

    final currentName =
        widget.workoutGroup?.name.trim().toLowerCase();

    final exists = widget.existingNames.any((candidate) {
      final value = candidate.trim().toLowerCase();

      if (_isEditing && value == currentName) {
        return false;
      }

      return value == normalized;
    });

    if (exists) {
      return 'A workout group with this name already exists';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final displayOrder =
        int.tryParse(_displayOrderController.text.trim()) ?? 1;

    Navigator.of(context).pop(
      WorkoutGroup(
        id: widget.workoutGroup?.id ?? _uuid.v4(),
        workoutDayId: widget.workoutDayId,
        name: _nameController.text.trim(),
        displayOrder: displayOrder,
        isArchived: widget.workoutGroup?.isArchived ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit Workout Group'
              : 'Create Workout Group',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Workout Group Name',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _displayOrderController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Display Order',
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _save,
                  child: Text(
                    _isEditing
                        ? 'Update Workout Group'
                        : 'Create Workout Group',
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