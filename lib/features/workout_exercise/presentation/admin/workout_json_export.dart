import 'dart:convert';

import '../../../exercise/domain/entities/exercise.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_sequence_definition.dart';
import '../../domain/entities/workout_sequence_step.dart';

/// Read-only diagnostic formatter available only through export permission.
final class WorkoutJsonExport {
  WorkoutJsonExport._();

  static String encode({
    required WorkoutExercise workoutExercise,
    required Exercise? linkedExercise,
  }) {
    final export = <String, Object?>{
      'exportType': 'ritmoWorkoutLibraryDebug',
      'exportVersion': 1,
      'workoutExercise': _workoutExercise(workoutExercise),
      'linkedExercise': linkedExercise == null
          ? null
          : _exercise(linkedExercise),
    };
    return const JsonEncoder.withIndent('  ').convert(export);
  }

  static Map<String, Object?> _workoutExercise(
    WorkoutExercise workoutExercise,
  ) {
    return <String, Object?>{
      'id': workoutExercise.id,
      'workoutGroupId': workoutExercise.workoutGroupId,
      'exerciseId': workoutExercise.exerciseId,
      'displayOrder': workoutExercise.displayOrder,
      'sets': workoutExercise.sets,
      'targetType': workoutExercise.targetType.name,
      'repetitions': workoutExercise.repetitions,
      'durationInSeconds': workoutExercise.durationInSeconds,
      'restInSeconds': workoutExercise.restInSeconds,
      'sessionRepetitions': workoutExercise.sessionRepetitions,
      'weight': workoutExercise.weight,
      'weightUnit': workoutExercise.weightUnit.name,
      'rpe': workoutExercise.rpe,
      'tempoType': workoutExercise.tempoType.name,
      'customTempo': workoutExercise.customTempo,
      'notes': workoutExercise.notes,
      'isArchived': workoutExercise.isArchived,
      'sequenceDefinition': _sequenceDefinition(
        workoutExercise.sequenceDefinition,
      ),
    };
  }

  static Map<String, Object?>? _sequenceDefinition(
    WorkoutSequenceDefinition? definition,
  ) {
    if (definition == null) {
      return null;
    }
    return <String, Object?>{
      'steps': <Map<String, Object?>>[
        for (var index = 0; index < definition.steps.length; index += 1)
          _sequenceStep(definition.steps[index], index),
      ],
    };
  }

  static Map<String, Object?> _sequenceStep(
    WorkoutSequenceStep step,
    int order,
  ) {
    return <String, Object?>{
      'order': order,
      'type': step.type.name,
      'text': step.text,
      'count': step.count,
      'countDirection': step.countDirection?.name,
      'repetitionCount': step.repetitionCount,
      'durationInSeconds': step.durationInSeconds,
    };
  }

  static Map<String, Object?> _exercise(Exercise exercise) {
    return <String, Object?>{
      'id': exercise.id,
      'name': exercise.name,
      'description': exercise.description,
      'instructions': exercise.instructions,
      'muscleGroup': exercise.muscleGroup.name,
      'equipment': exercise.equipment.name,
      'difficulty': exercise.difficulty.name,
      'isCustom': exercise.isCustom,
      'isArchived': exercise.isArchived,
    };
  }
}
