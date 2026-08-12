import 'workout_sequence_step.dart';

class WorkoutSequenceDefinition {
  WorkoutSequenceDefinition({
    required List<WorkoutSequenceStep> steps,
  }) : steps = List.unmodifiable(steps);

  final List<WorkoutSequenceStep> steps;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! WorkoutSequenceDefinition ||
        steps.length != other.steps.length) {
      return false;
    }

    for (var index = 0; index < steps.length; index += 1) {
      if (steps[index] != other.steps[index]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(steps);
}
