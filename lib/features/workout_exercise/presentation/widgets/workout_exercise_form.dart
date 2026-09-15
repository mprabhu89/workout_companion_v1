import 'package:flutter/material.dart';

import '../../../../core/widgets/ritmo_hud_widgets.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_sequence_definition.dart';
import '../../domain/entities/workout_target_type.dart';
import 'exercise_header_card.dart';
import 'notes_editor.dart';
import 'rest_selector.dart';
import 'sets_selector.dart';
import 'target_type_selector.dart';
import 'target_value_editor.dart';
import 'workout_sequence_editor.dart';

class WorkoutExerciseForm extends StatelessWidget {
  const WorkoutExerciseForm({
    super.key,
    required this.workoutExercise,
    required this.exerciseName,
    required this.sets,
    required this.restSeconds,
    required this.targetType,
    required this.targetValueController,
    required this.notesController,
    required this.sequenceDefinition,
    required this.onSetsChanged,
    required this.onRestChanged,
    required this.onTargetTypeChanged,
    required this.onSequenceChanged,
    this.onChangeExercise,
    this.builderHeader,
  });

  final WorkoutExercise workoutExercise;
  final String exerciseName;

  final int sets;

  final int restSeconds;

  final WorkoutTargetType targetType;

  final TextEditingController targetValueController;

  final TextEditingController notesController;

  final WorkoutSequenceDefinition? sequenceDefinition;

  final ValueChanged<int> onSetsChanged;

  final ValueChanged<int> onRestChanged;

  final ValueChanged<WorkoutTargetType> onTargetTypeChanged;

  final ValueChanged<WorkoutSequenceDefinition?> onSequenceChanged;

  final VoidCallback? onChangeExercise;

  final Widget? builderHeader;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
      children: [
        ?builderHeader,
        if (builderHeader != null) const SizedBox(height: 24),
        const RitmoHudSectionHeading(title: 'WORKOUT PARAMETERS'),
        const SizedBox(height: 14),
        ExerciseHeaderCard(
          exerciseName: exerciseName,
          onChangeExercise: onChangeExercise,
        ),

        const SizedBox(height: 16),

        SetsSelector(value: sets, onChanged: onSetsChanged),

        const SizedBox(height: 16),

        TargetTypeSelector(value: targetType, onChanged: onTargetTypeChanged),

        if (targetType != WorkoutTargetType.repetitions) ...[
          const SizedBox(height: 16),
          TargetValueEditor(
            targetType: targetType,
            controller: targetValueController,
          ),
        ],

        const SizedBox(height: 16),

        RestSelector(value: restSeconds, onChanged: onRestChanged),

        const SizedBox(height: 16),

        WorkoutSequenceEditor(
          workoutExercise: workoutExercise,
          sequenceDefinition: sequenceDefinition,
          onChanged: onSequenceChanged,
        ),

        const SizedBox(height: 16),

        NotesEditor(controller: notesController),
      ],
    );
  }
}
