import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';

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
  State<CreateWorkoutDayScreen> createState() => _CreateWorkoutDayScreenState();
}

class _CreateWorkoutDayScreenState extends State<CreateWorkoutDayScreen> {
  static const Uuid _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dayNumberController;

  bool _isRestDay = false;

  bool get _isEditing => widget.workoutDay != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.workoutDay?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.workoutDay?.description ?? '',
    );

    _dayNumberController = TextEditingController(
      text: (widget.workoutDay?.dayNumber ?? 1).toString(),
    );

    _isRestDay = widget.workoutDay?.isRestDay ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dayNumberController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Workout day name is required';
    }

    final normalized = name.toLowerCase();

    final currentName = widget.workoutDay?.name.trim().toLowerCase();

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

    final dayNumber = int.tryParse(_dayNumberController.text.trim()) ?? 1;

    Navigator.of(context).pop(
      WorkoutDay(
        id: widget.workoutDay?.id ?? _uuid.v4(),
        workoutPlanId: widget.workoutPlanId,
        dayNumber: dayNumber,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        isRestDay: _isRestDay,
        isArchived: widget.workoutDay?.isArchived ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05090C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_isEditing ? 'EDIT TRAINING DAY' : 'CREATE TRAINING DAY'),
      ),
      body: RitmoCyberpunkBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const RitmoHudSectionHeading(title: 'DAY CONFIGURATION'),
                  const SizedBox(height: 8),
                  const Text(
                    'Add a training stage to this program.',
                    style: TextStyle(color: Color(0xFFABC7CD)),
                  ),
                  const SizedBox(height: 18),
                  RitmoHudPanel(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: ritmoCoreHudInputDecoration(
                            label: 'DAY NAME',
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _dayNumberController,
                          keyboardType: TextInputType.number,
                          decoration: ritmoCoreHudInputDecoration(
                            label: 'DAY NUMBER',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: ritmoCoreHudInputDecoration(
                            label: 'DESCRIPTION',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RitmoHudPanel(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'REST DAY',
                        style: TextStyle(
                          color: Color(0xFFD8FCFF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      subtitle: const Text(
                        'Mark this day as a recovery/rest day.',
                      ),
                      activeThumbColor: ritmoCyan,
                      value: _isRestDay,
                      onChanged: (value) => setState(() => _isRestDay = value),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RitmoActionButton(
                    label: _isEditing ? 'UPDATE DAY' : 'SAVE DAY',
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
