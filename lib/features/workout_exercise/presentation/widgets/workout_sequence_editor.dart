import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../../workout_session/domain/services/workout_sequence_executor.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_sequence_definition.dart';
import '../../domain/entities/workout_sequence_step.dart';

String? validateWorkoutSequenceDefinitionForEditor({
  required WorkoutExercise workoutExercise,
  required WorkoutSequenceDefinition? sequenceDefinition,
}) {
  if (sequenceDefinition == null || sequenceDefinition.steps.isEmpty) {
    return null;
  }

  for (final step in sequenceDefinition.steps) {
    if (step.type == WorkoutSequenceStepType.guide &&
        (step.text == null || step.text!.trim().isEmpty)) {
      return 'Guide text must not be empty.';
    }

    if ((step.type == WorkoutSequenceStepType.count ||
            step.type == WorkoutSequenceStepType.countSeconds) &&
        (step.count == null || step.count! <= 0)) {
      return 'Count must be greater than zero.';
    }

    if (step.type == WorkoutSequenceStepType.relax &&
        (step.durationInSeconds == null || step.durationInSeconds! < 0)) {
      return 'Relax duration must be zero or greater.';
    }

    if (step.type == WorkoutSequenceStepType.counter &&
        (step.repetitionCount == null || step.repetitionCount! <= 0)) {
      return 'Reps must be greater than zero.';
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
      List<WorkoutSequenceStep>.of(sequenceDefinition?.steps ?? const []);

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    return RitmoHudPanel(
      padding: const EdgeInsets.all(16),
      glowStrength: steps.isEmpty ? 0.08 : 0.18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RitmoHudSectionHeading(title: 'SEQUENCE DEFINITION'),
          const SizedBox(height: 6),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'EXECUTION PROTOCOL',
                  style: TextStyle(
                    color: Color(0xFFA8C7CD),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.05,
                  ),
                ),
              ),
              Text(
                '${steps.length} ${steps.length == 1 ? 'STEP' : 'STEPS'}',
                style: const TextStyle(
                  color: ritmoOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            key: const Key('sequence_editor_add_step_button'),
            onPressed: () => _addStep(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: ritmoCyan,
              side: const BorderSide(color: ritmoCyan),
              minimumSize: const Size.fromHeight(44),
            ),
            icon: const Icon(Icons.add),
            label: const Text('+ ADD STEP'),
          ),
          const SizedBox(height: 16),
          if (steps.isEmpty)
            const _SequenceEmptyState()
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 440),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: steps.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
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
                    onEdit: () => _editStep(context, index),
                    onDelete: () => _deleteStep(index),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _addStep(BuildContext context) async {
    final type = await showModalBottomSheet<WorkoutSequenceStepType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _SequenceTypePicker(),
    );
    if (type == null || !context.mounted) {
      return;
    }

    final step = await showDialog<WorkoutSequenceStep>(
      context: context,
      builder: (context) => WorkoutSequenceStepDialog(initialType: type),
    );
    if (step == null) return;

    final steps = _steps..add(step);
    _updateSequence(steps);
  }

  Future<void> _editStep(BuildContext context, int index) async {
    final step = await showDialog<WorkoutSequenceStep>(
      context: context,
      builder: (context) =>
          WorkoutSequenceStepDialog(initialStep: _steps[index]),
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
    onChanged(steps.isEmpty ? null : WorkoutSequenceDefinition(steps: steps));
  }
}

class WorkoutSequenceStepDialog extends StatefulWidget {
  const WorkoutSequenceStepDialog({
    super.key,
    this.initialStep,
    this.initialType,
  });

  final WorkoutSequenceStep? initialStep;
  final WorkoutSequenceStepType? initialType;

  @override
  State<WorkoutSequenceStepDialog> createState() =>
      _WorkoutSequenceStepDialogState();
}

class _WorkoutSequenceStepDialogState extends State<WorkoutSequenceStepDialog> {
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

    _stepType =
        initialStep?.type ??
        widget.initialType ??
        WorkoutSequenceStepType.guide;
    _guideController = TextEditingController(text: initialStep?.text ?? '');
    _countController = TextEditingController(
      text: initialStep?.count?.toString() ?? '',
    );
    _counterController = TextEditingController(
      text: initialStep?.repetitionCount?.toString() ?? '',
    );
    _relaxController = TextEditingController(
      text: initialStep?.durationInSeconds?.toString() ?? '',
    );
    _countDirection =
        initialStep?.countDirection ?? WorkoutCountDirection.ascending;
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

    return RitmoHudDialog(
      title: isEditing ? 'EDIT SEQUENCE STEP' : 'CONFIGURE SEQUENCE STEP',
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(foregroundColor: ritmoCyan),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          key: const Key('sequence_step_save_button'),
          onPressed: _save,
          style: OutlinedButton.styleFrom(foregroundColor: ritmoCyan),
          child: const Text('Save'),
        ),
      ],
      child: SingleChildScrollView(
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<WorkoutSequenceStepType>(
                key: const Key('sequence_step_type_dropdown'),
                initialValue: _stepType,
                decoration: ritmoCoreHudInputDecoration(label: 'STEP TYPE'),
                items: WorkoutSequenceStepType.values
                    .map(
                      (type) => DropdownMenuItem<WorkoutSequenceStepType>(
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
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    switch (_stepType) {
      case WorkoutSequenceStepType.guide:
        return [
          TextField(
            key: const Key('sequence_step_guide_text_field'),
            controller: _guideController,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: ritmoCoreHudInputDecoration(
              label: 'GUIDE TEXT',
            ).copyWith(alignLabelWithHint: true),
          ),
        ];
      case WorkoutSequenceStepType.count:
      case WorkoutSequenceStepType.countSeconds:
        return [
          TextField(
            key: const Key('sequence_step_count_field'),
            controller: _countController,
            keyboardType: TextInputType.number,
            decoration: ritmoCoreHudInputDecoration(label: 'COUNT'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WorkoutCountDirection>(
            key: const Key('sequence_step_count_direction_dropdown'),
            initialValue: _countDirection,
            decoration: ritmoCoreHudInputDecoration(label: 'DIRECTION'),
            items: WorkoutCountDirection.values
                .map(
                  (direction) => DropdownMenuItem<WorkoutCountDirection>(
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
            key: const Key('sequence_step_counter_field'),
            controller: _counterController,
            keyboardType: TextInputType.number,
            decoration: ritmoCoreHudInputDecoration(label: 'REPS'),
          ),
        ];
      case WorkoutSequenceStepType.relax:
        return [
          TextField(
            key: const Key('sequence_step_relax_field'),
            controller: _relaxController,
            keyboardType: TextInputType.number,
            decoration: ritmoCoreHudInputDecoration(
              label: 'RELAX DURATION (SECONDS)',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Relax is silent. Add a separate Guide step if you want speech.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ];
      case WorkoutSequenceStepType.sequenceBreak:
        return const [Text('Break exits the active Reps - Counter block.')];
      case WorkoutSequenceStepType.end:
        return const [Text('End terminates the sequence.')];
    }
  }

  void _save() {
    final guideText = _guideController.text.trim();
    final count = int.tryParse(_countController.text.trim());
    final repetitionCount = int.tryParse(_counterController.text.trim());
    final relaxDuration = int.tryParse(_relaxController.text.trim());

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
      case WorkoutSequenceStepType.countSeconds:
        if (count == null || count <= 0) {
          errorText = 'Count Seconds must be greater than zero.';
        } else {
          step = WorkoutSequenceStep.countSeconds(
            count: count,
            direction: _countDirection,
          );
        }
        break;
      case WorkoutSequenceStepType.counter:
        if (repetitionCount == null || repetitionCount <= 0) {
          errorText = 'Reps must be greater than zero.';
        } else {
          step = WorkoutSequenceStep.counter(repetitionCount: repetitionCount);
        }
        break;
      case WorkoutSequenceStepType.relax:
        if (relaxDuration == null || relaxDuration < 0) {
          errorText = 'Relax duration must be zero or greater.';
        } else {
          step = WorkoutSequenceStep.relax(durationInSeconds: relaxDuration);
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
      case WorkoutSequenceStepType.countSeconds:
        return 'Count Seconds';
      case WorkoutSequenceStepType.counter:
        return 'Reps - Counter';
      case WorkoutSequenceStepType.relax:
        return 'Relax';
      case WorkoutSequenceStepType.sequenceBreak:
        return 'Break';
      case WorkoutSequenceStepType.end:
        return 'End';
    }
  }
}

class _SequenceEmptyState extends StatelessWidget {
  const _SequenceEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'No sequence steps added. Build the execution protocol one step at a time.',
        style: TextStyle(color: Color(0xFFA8C7CD), height: 1.35),
      ),
    );
  }
}

class _SequenceTypePicker extends StatelessWidget {
  const _SequenceTypePicker();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.86,
      child: SafeArea(
        child: Material(
          color: const Color(0xFF102027),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: ritmoCyan)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADD SEQUENCE STEP',
                  style: TextStyle(
                    color: ritmoCyan,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: WorkoutSequenceStepType.values
                        .map((type) => _SequenceTypeOption(type: type))
                        .toList(growable: false),
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

class _SequenceTypeOption extends StatelessWidget {
  const _SequenceTypeOption({required this.type});

  final WorkoutSequenceStepType type;

  @override
  Widget build(BuildContext context) {
    final visual = _SequenceStepVisual.forType(type);
    return ListTile(
      key: Key('sequence_type_picker_${type.name}'),
      contentPadding: EdgeInsets.zero,
      leading: Icon(visual.icon, color: visual.accent),
      title: Text(
        visual.label,
        style: const TextStyle(
          color: Color(0xFFF0FCFE),
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        visual.description,
        style: const TextStyle(color: Color(0xFFA8C7CD)),
      ),
      onTap: () => Navigator.of(context).pop(type),
    );
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
    final visual = _SequenceStepVisual.forType(step.type);

    return RitmoHudPanel(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
      glowStrength: step.type == WorkoutSequenceStepType.counter ? 0.16 : 0.05,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final actions = _actions(visual.accent);
          final content = _stepContent(context, visual);

          if (constraints.maxWidth >= 540) {
            return Row(
              children: [
                _stepNumber(visual),
                const SizedBox(width: 12),
                Expanded(child: content),
                const SizedBox(width: 8),
                actions,
              ],
            );
          }

          // On phones, keep the full text column on its own row and place
          // the touch targets below it rather than squeezing text vertically.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stepNumber(visual),
                  const SizedBox(width: 12),
                  Expanded(child: content),
                ],
              ),
              const SizedBox(height: 4),
              Align(alignment: Alignment.centerRight, child: actions),
            ],
          );
        },
      ),
    );
  }

  Widget _stepNumber(_SequenceStepVisual visual) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: visual.accent.withValues(alpha: 0.14),
        border: Border.all(color: visual.accent.withValues(alpha: 0.68)),
      ),
      child: Text(
        '${index + 1}'.padLeft(2, '0'),
        style: TextStyle(color: visual.accent, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _stepContent(BuildContext context, _SequenceStepVisual visual) {
    final isGuide = step.type == WorkoutSequenceStepType.guide;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(visual.icon, color: visual.accent, size: 17),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                visual.label,
                key: Key('sequence_step_type_$index'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: visual.accent,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.45,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          _stepSummary(),
          key: Key('sequence_step_summary_$index'),
          maxLines: isGuide ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFD0E2E5)),
        ),
      ],
    );
  }

  Widget _actions(Color accent) {
    return Wrap(
      spacing: 0,
      children: [
        IconButton(
          onPressed: onMoveUp,
          icon: Icon(Icons.arrow_upward, color: accent),
          tooltip: 'Move Up',
        ),
        IconButton(
          onPressed: onMoveDown,
          icon: Icon(Icons.arrow_downward, color: accent),
          tooltip: 'Move Down',
        ),
        IconButton(
          onPressed: onEdit,
          icon: Icon(Icons.edit_outlined, color: accent),
          tooltip: 'Edit Step',
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Color(0xFFE27A7A)),
          tooltip: 'Delete Step',
        ),
      ],
    );
  }

  String _stepSummary() {
    final count = step.count;
    final isAscending = step.countDirection != WorkoutCountDirection.descending;

    switch (step.type) {
      case WorkoutSequenceStepType.guide:
        return step.text?.trim().isNotEmpty == true
            ? step.text!.trim()
            : 'No guide text';
      case WorkoutSequenceStepType.count:
        return count == null
            ? 'No count configured'
            : isAscending
            ? '1 to $count'
            : '$count to 1';
      case WorkoutSequenceStepType.countSeconds:
        return count == null
            ? 'No duration configured'
            : isAscending
            ? '$count seconds'
            : '$count to 1 seconds';
      case WorkoutSequenceStepType.counter:
        return '${step.repetitionCount ?? 0} repetitions';
      case WorkoutSequenceStepType.relax:
        return '${step.durationInSeconds ?? 0} seconds';
      case WorkoutSequenceStepType.sequenceBreak:
        return 'Ends the current repetition block';
      case WorkoutSequenceStepType.end:
        return 'End workout';
    }
  }
}

class _SequenceStepVisual {
  const _SequenceStepVisual({
    required this.label,
    required this.description,
    required this.icon,
    required this.iconLabel,
    required this.accent,
  });

  final String label;
  final String description;
  final IconData icon;
  final String iconLabel;
  final Color accent;

  static _SequenceStepVisual forType(WorkoutSequenceStepType type) {
    switch (type) {
      case WorkoutSequenceStepType.guide:
        return const _SequenceStepVisual(
          label: 'Guide',
          description: 'Speak an instruction',
          icon: Icons.record_voice_over_outlined,
          iconLabel: '•',
          accent: ritmoCyan,
        );
      case WorkoutSequenceStepType.count:
        return const _SequenceStepVisual(
          label: 'Count',
          description: 'Natural coach counting',
          icon: Icons.format_list_numbered,
          iconLabel: '•',
          accent: ritmoCyan,
        );
      case WorkoutSequenceStepType.countSeconds:
        return const _SequenceStepVisual(
          label: 'Count Seconds',
          description: 'Timed one-second counting',
          icon: Icons.timer_outlined,
          iconLabel: '•',
          accent: ritmoCyan,
        );
      case WorkoutSequenceStepType.counter:
        return const _SequenceStepVisual(
          label: 'Reps - Counter',
          description: 'Repeat a sequence block',
          icon: Icons.loop,
          iconLabel: '×',
          accent: ritmoOrange,
        );
      case WorkoutSequenceStepType.relax:
        return const _SequenceStepVisual(
          label: 'Relax',
          description: 'Silent timed recovery',
          icon: Icons.self_improvement_outlined,
          iconLabel: '•',
          accent: Color(0xFF7AD4C7),
        );
      case WorkoutSequenceStepType.sequenceBreak:
        return const _SequenceStepVisual(
          label: 'Break',
          description: 'Exit repetition block',
          icon: Icons.subdirectory_arrow_right,
          iconLabel: '•',
          accent: ritmoOrange,
        );
      case WorkoutSequenceStepType.end:
        return const _SequenceStepVisual(
          label: 'End',
          description: 'Finish the sequence',
          icon: Icons.flag_outlined,
          iconLabel: '•',
          accent: Color(0xFFB3D1D6),
        );
    }
  }
}
