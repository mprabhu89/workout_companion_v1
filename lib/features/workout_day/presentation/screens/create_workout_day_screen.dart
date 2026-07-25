import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/workout_day.dart';

class CreateWorkoutDayScreen extends StatefulWidget {
  const CreateWorkoutDayScreen({
    super.key,
    required this.workoutPlanId,
    required this.existingNames,
    this.workoutDay,
  });

  final String workoutPlanId;
  final List<String> existingNames;
  final WorkoutDay? workoutDay;

  @override
  State<CreateWorkoutDayScreen> createState() =>
      _CreateWorkoutDayScreenState();
}

class _CreateWorkoutDayScreenState
    extends State<CreateWorkoutDayScreen> {
  static const Uuid _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _orderController;

  bool get _isEditing => widget.workoutDay != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.workoutDay?.name ?? '',
    );

    _notesController = TextEditingController(
      text: widget.workoutDay?.notes ?? '',
    );

    _orderController = TextEditingController(
      text: widget.workoutDay?.dayOrder.toString() ?? '1',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Workout day name is required';
    }

    final normalized = name.toLowerCase();

    final currentName =
        widget.workoutDay?.name.trim().toLowerCase();

    final exists = widget.existingNames.any((candidate) {
      final value = candidate.trim().toLowerCase();

      if (_isEditing && value == currentName) {
        return false;
      }

      return value == normalized;
    });

    if (exists) {
      return 'A workout day with this name already exists';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final order =
        int.tryParse(_orderController.text.trim()) ?? 1;

    Navigator.of(context).pop(
      WorkoutDay(
        id: widget.workoutDay?.id ?? _uuid.v4(),
        workoutPlanId: widget.workoutPlanId,
        name: _nameController.text.trim(),
        dayOrder: order,
        notes: _notesController.text.trim(),
        isEnabled: widget.workoutDay?.isEnabled ?? true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit Workout Day'
              : 'Create Workout Day',
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
                    labelText: 'Workout Day Name',
                  ),
                  validator: _validateName,
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
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _save,
                  child: Text(
                    _isEditing ? 'Update' : 'Save',
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