import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/workout_plan.dart';
import '../../domain/enums/workout_plan_category.dart';
import '../../domain/enums/workout_plan_difficulty.dart';

class CreateWorkoutPlanScreen extends StatefulWidget {
  const CreateWorkoutPlanScreen({
    super.key,
    required this.existingNames,
    this.workoutPlan,
  });

  final List<String> existingNames;
  final WorkoutPlan? workoutPlan;

  @override
  State<CreateWorkoutPlanScreen> createState() =>
      _CreateWorkoutPlanScreenState();
}

class _CreateWorkoutPlanScreenState
    extends State<CreateWorkoutPlanScreen> {
  static const Uuid _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;

  WorkoutPlanDifficulty _difficulty =
      WorkoutPlanDifficulty.beginner;

  WorkoutPlanCategory _category =
      WorkoutPlanCategory.generalFitness;

  bool get _isEditing => widget.workoutPlan != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.workoutPlan?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.workoutPlan?.description ?? '',
    );

    _durationController = TextEditingController(
      text: widget.workoutPlan?.estimatedDurationInMinutes
              .toString() ??
          '',
    );

    _difficulty = widget.workoutPlan?.difficulty ??
        WorkoutPlanDifficulty.beginner;

    _category = widget.workoutPlan?.category ??
        WorkoutPlanCategory.generalFitness;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Workout plan name is required';
    }

    final normalized = name.toLowerCase();

    final currentName =
        widget.workoutPlan?.name.trim().toLowerCase();

    final exists = widget.existingNames.any((item) {
      final candidate = item.trim().toLowerCase();

      if (_isEditing && candidate == currentName) {
        return false;
      }

      return candidate == normalized;
    });

    if (exists) {
      return 'A workout plan with this name already exists';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final duration =
        int.tryParse(_durationController.text.trim()) ?? 0;

    Navigator.of(context).pop(
      WorkoutPlan(
        id: widget.workoutPlan?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        difficulty: _difficulty,
        estimatedDurationInMinutes: duration,
        isArchived:
            widget.workoutPlan?.isArchived ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit Workout Plan'
              : 'Create Workout Plan',
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
                    labelText: 'Workout Plan Name',
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
                const SizedBox(height: 16),
                DropdownButtonFormField<WorkoutPlanCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  items: WorkoutPlanCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _category = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<WorkoutPlanDifficulty>(
                  initialValue: _difficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                  ),
                  items: WorkoutPlanDifficulty.values
                      .map(
                        (difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(
                            difficulty.displayName,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _difficulty = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText:
                        'Estimated Duration (minutes)',
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