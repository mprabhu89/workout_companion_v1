import 'package:flutter/material.dart';

import '../../../workout_session/domain/services/workout_sequence_executor.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_sequence_definition.dart';
import '../../domain/entities/workout_sequence_step.dart';

String? validateWorkoutSequenceDefinitionForEditor({
  required WorkoutExercise workoutExercise,
  required WorkoutSequenceDefinition? sequenceDefinition,
}) {
  if (sequenceDefinition == null ||
      sequenceDefinition.steps.isEmpty) {
    return null;
  }

  for (final step in sequenceDefinition.steps) {
    if (step.type == WorkoutSequenceStepType.guide &&
        (step.text == null || step.text!.trim().isEmpty)) {
      return 'Guide text must not be empty.';
    }

    if (step.type == WorkoutSequenceStepType.count &&
        (step.count == null || step.count! <= 0)) {
      return 'Count must be greater than zero.';
    }

    if (step.type == WorkoutSequenceStepType.relax &&
        (step.durationInSeconds == null ||
            step.durationInSeconds! < 0)) {
      return 'Relax duration must be zero or greater.';
    }

    if (step.type == WorkoutSequenceStepType.counter &&
        (step.repetitionCount == null ||
            step.repetitionCount! <= 0)) {
      return 'Counter repetition count must be greater than zero.';
    }
  }

  try {
    const WorkoutSequenceExecutor().execute(
      workoutExercise: workoutExercise,
      sequenceDefinition: sequenceDefinition,
    );
  } on StateError catch (error) {
    return error.message.toString();
  }

  return null;
}

class WorkoutSequenceEditor extends StatelessWidget {
  const WorkoutSequenceEditor({
    super.key,
    required this.workoutExercise,
    required this.sequenceDefinition,
    required this.onChanged,
  });

  final WorkoutExercise workoutExercise;
  final WorkoutSequenceDefinition? sequenceDefinition;
  final ValueChanged<WorkoutSequenceDefinition?> onChanged;

  List<WorkoutSequenceStep> get _steps =>
      List<WorkoutSequenceStep>.of(
        sequenceDefinition?.steps ?? const [],
      );

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sequence Definition',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium,
                  ),
                ),
                FilledButton.icon(
                  key: const Key(
                    'sequence_editor_add_step_button',
                  ),
                  onPressed: () => _addStep(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Step'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ordered workout guidance steps for this workout exercise.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (steps.isEmpty)
              Text(
                'No sequence steps added.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 360,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: steps.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _SequenceStepTile(
                      index: index,
                      step: steps[index],
                      stepCount: steps.length,
                      onMoveUp: index > 0
                          ? () => _moveStep(index, index - 1)
                          : null,
                      onMoveDown: index < steps.length - 1
                          ? () => _moveStep(index, index + 1)
                          : null,
                      onEdit: () => _editStep(
                        context,
                        index,
                      ),
                      onDelete: () => _deleteStep(index),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addStep(BuildContext context) async {
    final step = await showDialog<WorkoutSequenceStep>(
      context: context,
      builder: (context) => WorkoutSequenceStepDialog(
      ),
    );

    if (step == null) {
      return;
    }

    final steps = _steps..add(step);
    _updateSequence(steps);
  }

  Future<void> _editStep(
    BuildContext context,
    int index,
  ) async {
    final step = await showDialog<WorkoutSequenceStep>(
      context: context,
      builder: (context) => WorkoutSequenceStepDialog(
        initialStep: _steps[index],
      ),
    );

    if (step == null) {
      return;
    }

    final steps = _steps;
    steps[index] = step;
    _updateSequence(steps);
  }

  void _deleteStep(int index) {
    final steps = _steps;
    steps.removeAt(index);
    _updateSequence(steps);
  }

  void _moveStep(int fromIndex, int toIndex) {
    final steps = _steps;
    final step = steps.removeAt(fromIndex);
    steps.insert(toIndex, step);
    _updateSequence(steps);
  }

  void _updateSequence(List<WorkoutSequenceStep> steps) {
    onChanged(
      steps.isEmpty
          ? null
          : WorkoutSequenceDefinition(steps: steps),
    );
  }
}

class WorkoutSequenceStepDialog extends StatefulWidget {
  const WorkoutSequenceStepDialog({
    super.key,
    this.initialStep,
  });

  final WorkoutSequenceStep? initialStep;

  @override
  State<WorkoutSequenceStepDialog> createState() =>
      _WorkoutSequenceStepDialogState();
}

class _WorkoutSequenceStepDialogState
    extends State<WorkoutSequenceStepDialog> {
  late WorkoutSequenceStepType _stepType;
  late final TextEditingController _guideController;
  late final TextEditingController _countController;
  late final TextEditingController _counterController;
  late final TextEditingController _relaxController;
  late WorkoutCountDirection _countDirection;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initialStep = widget.initialStep;

    _stepType = initialStep?.type ??
        WorkoutSequenceStepType.guide;
    _guideController = TextEditingController(
      text: initialStep?.text ?? '',
    );
    _countController = TextEditingController(
      text: initialStep?.count?.toString() ?? '',
    );
    _counterController = TextEditingController(
      text: initialStep?.repetitionCount?.toString() ?? '',
    );
    _relaxController = TextEditingController(
      text:
          initialStep?.durationInSeconds?.toString() ??
          '',
    );
    _countDirection =
        initialStep?.countDirection ??
            WorkoutCountDirection.ascending;
  }

  @override
  void dispose() {
    _guideController.dispose();
    _countController.dispose();
    _counterController.dispose();
    _relaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialStep != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Sequence Step' : 'Add Sequence Step',
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<WorkoutSequenceStepType>(
                key: const Key(
                  'sequence_step_type_dropdown',
                ),
                initialValue: _stepType,
                decoration: const InputDecoration(
                  labelText: 'Step Type',
                  border: OutlineInputBorder(),
                ),
                items: WorkoutSequenceStepType.values
                    .map(
                      (type) =>
                          DropdownMenuItem<WorkoutSequenceStepType>(
                        value: type,
                        child: Text(_stepTypeLabel(type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _stepType = value;
                    _errorText = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              ..._buildFields(context),
              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key(
            'sequence_step_save_button',
          ),
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    switch (_stepType) {
      case WorkoutSequenceStepType.guide:
        return [
          TextField(
            key: const Key(
              'sequence_step_guide_text_field',
            ),
            controller: _guideController,
            minLines: 2,
            maxLines: 4,
            textCapitalization:
                TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Guide Text',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ];
      case WorkoutSequenceStepType.count:
        return [
          TextField(
            key: const Key(
              'sequence_step_count_field',
            ),
            controller: _countController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Count',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WorkoutCountDirection>(
            key: const Key(
              'sequence_step_count_direction_dropdown',
            ),
            initialValue: _countDirection,
            decoration: const InputDecoration(
              labelText: 'Direction',
              border: OutlineInputBorder(),
            ),
            items: WorkoutCountDirection.values
                .map(
                  (direction) =>
                      DropdownMenuItem<WorkoutCountDirection>(
                    value: direction,
                    child: Text(direction.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _countDirection = value;
              });
            },
          ),
        ];
      case WorkoutSequenceStepType.counter:
        return [
          TextField(
            key: const Key(
              'sequence_step_counter_field',
            ),
            controller: _counterController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Counter Repetitions',
              border: OutlineInputBorder(),
            ),
          ),
        ];
      case WorkoutSequenceStepType.relax:
        return [
          TextField(
            key: const Key(
              'sequence_step_relax_field',
            ),
            controller: _relaxController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Relax Duration (seconds)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Relax is silent. Add a separate Guide step if you want speech.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ];
      case WorkoutSequenceStepType.sequenceBreak:
        return const [
          Text('Break exits the active Counter block.'),
        ];
      case WorkoutSequenceStepType.end:
        return const [
          Text('End terminates the sequence.'),
        ];
    }
  }

  void _save() {
    final guideText = _guideController.text.trim();
    final count =
        int.tryParse(_countController.text.trim());
    final repetitionCount = int.tryParse(
      _counterController.text.trim(),
    );
    final relaxDuration = int.tryParse(
      _relaxController.text.trim(),
    );

    WorkoutSequenceStep? step;
    String? errorText;

    switch (_stepType) {
      case WorkoutSequenceStepType.guide:
        if (guideText.isEmpty) {
          errorText = 'Guide text is required.';
        } else {
          step = WorkoutSequenceStep.guide(text: guideText);
        }
        break;
      case WorkoutSequenceStepType.count:
        if (count == null || count <= 0) {
          errorText = 'Count must be greater than zero.';
        } else {
          step = WorkoutSequenceStep.count(
            count: count,
            direction: _countDirection,
          );
        }
        break;
      case WorkoutSequenceStepType.counter:
        if (repetitionCount == null || repetitionCount <= 0) {
          errorText =
              'Counter repetition count must be greater than zero.';
        } else {
          step = WorkoutSequenceStep.counter(
            repetitionCount: repetitionCount,
          );
        }
        break;
      case WorkoutSequenceStepType.relax:
        if (relaxDuration == null || relaxDuration < 0) {
          errorText =
              'Relax duration must be zero or greater.';
        } else {
          step = WorkoutSequenceStep.relax(
            durationInSeconds: relaxDuration,
          );
        }
        break;
      case WorkoutSequenceStepType.sequenceBreak:
        step = WorkoutSequenceStep.sequenceBreak();
        break;
      case WorkoutSequenceStepType.end:
        step = WorkoutSequenceStep.end();
        break;
    }

    if (errorText != null || step == null) {
      setState(() {
        _errorText = errorText ?? 'Invalid sequence step.';
      });
      return;
    }

    Navigator.of(context).pop(step);
  }

  String _stepTypeLabel(WorkoutSequenceStepType type) {
    switch (type) {
      case WorkoutSequenceStepType.guide:
        return 'Guide';
      case WorkoutSequenceStepType.count:
        return 'Count';
      case WorkoutSequenceStepType.counter:
        return 'Counter';
      case WorkoutSequenceStepType.relax:
        return 'Relax';
      case WorkoutSequenceStepType.sequenceBreak:
        return 'Break';
      case WorkoutSequenceStepType.end:
        return 'End';
    }
  }
}

class _SequenceStepTile extends StatelessWidget {
  const _SequenceStepTile({
    required this.index,
    required this.step,
    required this.stepCount,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final WorkoutSequenceStep step;
  final int stepCount;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(
          _summaryText(),
          key: Key('sequence_step_summary_$index'),
        ),
        subtitle: Text('${index + 1} of $stepCount'),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              onPressed: onMoveUp,
              icon: const Icon(Icons.arrow_upward),
              tooltip: 'Move Up',
            ),
            IconButton(
              onPressed: onMoveDown,
              icon: const Icon(Icons.arrow_downward),
              tooltip: 'Move Down',
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Step',
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Step',
            ),
          ],
        ),
      ),
    );
  }

  String _summaryText() {
    switch (step.type) {
      case WorkoutSequenceStepType.guide:
        return 'Guide - ${step.text ?? ''}';
      case WorkoutSequenceStepType.count:
        return 'Count - ${step.count} ${step.countDirection?.name ?? WorkoutCountDirection.ascending.name}';
      case WorkoutSequenceStepType.counter:
        return 'Counter - ${step.repetitionCount} repetitions';
      case WorkoutSequenceStepType.relax:
        return 'Relax - ${step.durationInSeconds} sec';
      case WorkoutSequenceStepType.sequenceBreak:
        return 'Break';
      case WorkoutSequenceStepType.end:
        return 'End';
    }
  }
}
