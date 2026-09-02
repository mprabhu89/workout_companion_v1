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
    var index = 0;
    while (index < steps.length) {
      final step = steps[index];

      if (step.type == WorkoutSequenceStepType.end) {
        events.add(WorkoutSequenceEvent.end());
        break;
      }

      if (step.type == WorkoutSequenceStepType.counter) {
        final breakIndex = _findMatchingBreakIndex(
          steps,
          counterIndex: index,
        );
        final repetitionCount =
            step.repetitionCount!;
        final repeatedSteps = steps.sublist(
          index + 1,
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
            iterationTotal: repetitionCount,
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

      events.addAll(
        _emitEventsForStep(
          step,
        ),
      );
      index += 1;
    }

    return List.unmodifiable(events);
  }

  _BlockEmissionResult _emitSteps(
    List<WorkoutSequenceStep> steps, {
    required int iterationNumber,
    required int iterationTotal,
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
        iterationTotal: iterationTotal,
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
    int? iterationTotal,
  }) {
    switch (step.type) {
      case WorkoutSequenceStepType.guide:
        return [
          WorkoutSequenceEvent.guide(
            text: step.text ?? '',
            iterationNumber: iterationNumber,
            iterationTotal: iterationTotal,
          ),
        ];
      case WorkoutSequenceStepType.count:
      case WorkoutSequenceStepType.countSeconds:
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
              (value) => step.type == WorkoutSequenceStepType.count
                  ? WorkoutSequenceEvent.count(
                      value: value,
                      iterationNumber: iterationNumber,
                      iterationTotal: iterationTotal,
                    )
                  : WorkoutSequenceEvent.countSeconds(
                      value: value,
                      iterationNumber: iterationNumber,
                      iterationTotal: iterationTotal,
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
            iterationTotal: iterationTotal,
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
    int? activeCounterIndex;

    for (var index = 0; index < steps.length; index += 1) {
      final step = steps[index];

      if ((step.type == WorkoutSequenceStepType.count ||
              step.type == WorkoutSequenceStepType.countSeconds) &&
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
        if (step.repetitionCount == null ||
            step.repetitionCount! <= 0) {
          throw StateError(
            'Counter steps must have a positive repetition count.',
          );
        }

        if (activeCounterIndex != null) {
          throw StateError(
            'Nested Counter blocks are not supported.',
          );
        }

        activeCounterIndex = index;
      }

      if (step.type == WorkoutSequenceStepType.sequenceBreak) {
        if (activeCounterIndex == null) {
          throw StateError(
            'Break step must close an active Counter block.',
          );
        }

        activeCounterIndex = null;
      }
    }

    if (activeCounterIndex != null) {
      throw StateError(
        'Counter must be followed by Break.',
      );
    }
  }

  int _findMatchingBreakIndex(
    List<WorkoutSequenceStep> steps,
    {
    required int counterIndex,
  }
  ) {
    for (
      var index = counterIndex + 1;
      index < steps.length;
      index += 1
    ) {
      final step = steps[index];

      if (step.type == WorkoutSequenceStepType.counter) {
        throw StateError(
          'Nested Counter blocks are not supported.',
        );
      }

      if (step.type == WorkoutSequenceStepType.sequenceBreak) {
        return index;
      }
    }

    throw StateError(
      'Counter must be followed by Break.',
    );
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
