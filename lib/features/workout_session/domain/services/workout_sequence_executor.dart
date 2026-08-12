import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/entities/workout_sequence_definition.dart';
import '../../../workout_exercise/domain/entities/workout_sequence_step.dart';
import '../entities/workout_sequence_event.dart';

class WorkoutSequenceExecutor {
  const WorkoutSequenceExecutor();

  List<WorkoutSequenceEvent> execute({
    required WorkoutExercise workoutExercise,
    required WorkoutSequenceDefinition sequenceDefinition,
  }) {
    _validateStructure(sequenceDefinition);

    final events = <WorkoutSequenceEvent>[];
    final steps = sequenceDefinition.steps;
    final counterIndex = _findFirstIndex(
      steps,
      WorkoutSequenceStepType.counter,
    );
    final breakIndex = _findFirstIndex(
      steps,
      WorkoutSequenceStepType.sequenceBreak,
    );

    var index = 0;
    while (index < steps.length) {
      final step = steps[index];

      if (step.type == WorkoutSequenceStepType.end) {
        events.add(WorkoutSequenceEvent.end());
        break;
      }

      if (index == counterIndex) {
        final repetitionCount = _resolveRepetitionCount(
          workoutExercise,
        );
        final repeatedSteps = steps.sublist(
          counterIndex + 1,
          breakIndex,
        );

        for (
          var iterationNumber = 1;
          iterationNumber <= repetitionCount;
          iterationNumber += 1
        ) {
          final blockEvents = _emitSteps(
            repeatedSteps,
            iterationNumber: iterationNumber,
          );
          events.addAll(blockEvents.events);

          if (blockEvents.didReachEnd) {
            return List.unmodifiable(events);
          }
        }

        index = breakIndex + 1;
        continue;
      }

      if (step.type == WorkoutSequenceStepType.sequenceBreak) {
        throw StateError(
          'Break step must close an active Counter block.',
        );
      }

      events.addAll(_emitEventsForStep(step));
      index += 1;
    }

    return List.unmodifiable(events);
  }

  _BlockEmissionResult _emitSteps(
    List<WorkoutSequenceStep> steps, {
    required int iterationNumber,
  }) {
    final events = <WorkoutSequenceEvent>[];

    for (final step in steps) {
      if (step.type == WorkoutSequenceStepType.end) {
        events.add(WorkoutSequenceEvent.end());
        return _BlockEmissionResult(
          events: events,
          didReachEnd: true,
        );
      }

      if (step.type == WorkoutSequenceStepType.counter ||
          step.type == WorkoutSequenceStepType.sequenceBreak) {
        throw StateError(
          'Nested Counter blocks are not supported.',
        );
      }

      final emitted = _emitEventsForStep(
        step,
        iterationNumber: iterationNumber,
      );
      events.addAll(emitted);
    }

    return _BlockEmissionResult(
      events: events,
      didReachEnd: false,
    );
  }

  List<WorkoutSequenceEvent> _emitEventsForStep(
    WorkoutSequenceStep step, {
    int? iterationNumber,
  }) {
    switch (step.type) {
      case WorkoutSequenceStepType.guide:
        return [
          WorkoutSequenceEvent.guide(
            text: step.text ?? '',
            iterationNumber: iterationNumber,
          ),
        ];
      case WorkoutSequenceStepType.count:
        final count = step.count ?? 0;
        final direction = step.countDirection ??
            WorkoutCountDirection.ascending;
        final values = direction == WorkoutCountDirection.ascending
            ? Iterable<int>.generate(count, (index) => index + 1)
            : Iterable<int>.generate(
                count,
                (index) => count - index,
              );

        return values
            .map(
              (value) => WorkoutSequenceEvent.count(
                value: value,
                iterationNumber: iterationNumber,
              ),
            )
            .toList(growable: false);
      case WorkoutSequenceStepType.counter:
        return const [];
      case WorkoutSequenceStepType.relax:
        return [
          WorkoutSequenceEvent.relax(
            durationInSeconds:
                step.durationInSeconds ?? 0,
            iterationNumber: iterationNumber,
          ),
        ];
      case WorkoutSequenceStepType.sequenceBreak:
        return const [];
      case WorkoutSequenceStepType.end:
        return [WorkoutSequenceEvent.end()];
    }
  }

  void _validateStructure(
    WorkoutSequenceDefinition sequenceDefinition,
  ) {
    final steps = sequenceDefinition.steps;
    var counterCount = 0;
    var breakCount = 0;
    int? counterIndex;
    int? breakIndex;

    for (var index = 0; index < steps.length; index += 1) {
      final step = steps[index];

      if (step.type == WorkoutSequenceStepType.count &&
          (step.count == null || step.count! <= 0)) {
        throw StateError(
          'Count steps must have a positive count value.',
        );
      }

      if (step.type == WorkoutSequenceStepType.relax &&
          (step.durationInSeconds == null ||
              step.durationInSeconds! < 0)) {
        throw StateError(
          'Relax steps must have a non-negative duration.',
        );
      }

      if (step.type == WorkoutSequenceStepType.counter) {
        counterCount += 1;
        counterIndex ??= index;
      }

      if (step.type == WorkoutSequenceStepType.sequenceBreak) {
        breakCount += 1;
        breakIndex ??= index;
      }
    }

    if (counterCount == 0 && breakCount == 0) {
      return;
    }

    if (counterCount != 1 || breakCount != 1) {
      throw StateError(
        'Sequence must contain exactly one Counter and one Break when using repetition blocks.',
      );
    }

    if (counterIndex == null ||
        breakIndex == null ||
        breakIndex <= counterIndex) {
      throw StateError(
        'Break must appear after Counter.',
      );
    }
  }

  int _resolveRepetitionCount(
    WorkoutExercise workoutExercise,
  ) {
    final repetitionCount = workoutExercise.repetitions;

    if (repetitionCount == null || repetitionCount <= 0) {
      throw StateError(
        'WorkoutExercise.repetitions must be greater than zero when a Counter block is present.',
      );
    }

    return repetitionCount;
  }

  int _findFirstIndex(
    List<WorkoutSequenceStep> steps,
    WorkoutSequenceStepType type,
  ) {
    for (var index = 0; index < steps.length; index += 1) {
      if (steps[index].type == type) {
        return index;
      }
    }

    return -1;
  }
}

class _BlockEmissionResult {
  const _BlockEmissionResult({
    required this.events,
    required this.didReachEnd,
  });

  final List<WorkoutSequenceEvent> events;
  final bool didReachEnd;
}
