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
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _orderController;
  late final TextEditingController _notesController;

  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();

    final group = widget.workoutGroup;

    _nameController = TextEditingController(
      text: group?.name ?? '',
    );

    _orderController = TextEditingController(
      text: group?.groupOrder.toString() ?? '1',
    );

    _notesController = TextEditingController(
      text: group?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _nameExists(String value) {
    final normalized = value.trim().toLowerCase();

    return widget.existingNames.any((name) {
      if (widget.isEditing &&
          normalized ==
              widget.workoutGroup!.name.trim().toLowerCase()) {
        return false;
      }

      return name.trim().toLowerCase() == normalized;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final workoutGroup = WorkoutGroup(
      id: widget.workoutGroup?.id ?? _uuid.v4(),
      workoutDayId: widget.workoutDayId,
      name: _nameController.text.trim(),
      groupOrder:
          int.tryParse(_orderController.text.trim()) ?? 1,
      notes: _notesController.text.trim(),
      isEnabled: widget.workoutGroup?.isEnabled ?? true,
    );

    Navigator.of(context).pop(workoutGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? 'Edit Workout Group'
              : 'Create Workout Group',
        ),
      ),
      body: Padding(
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
                validator: (value) {
                  final text = value?.trim() ?? '';

                  if (text.isEmpty) {
                    return 'Please enter a name';
                  }

                  if (_nameExists(text)) {
                    return 'A workout group with this name already exists.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Display Order',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(
                  widget.isEditing
                      ? 'Update Workout Group'
                      : 'Create Workout Group',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}