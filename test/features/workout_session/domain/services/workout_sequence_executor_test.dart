import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_definition.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_sequence_step.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_session/domain/entities/workout_sequence_event.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_sequence_executor.dart';

void main() {
  group('WorkoutSequenceExecutor', () {
    const executor = WorkoutSequenceExecutor();

    test('guide executes once and preserves its configured text', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 1),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.guide(text: 'Be in position'),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(
        events,
        [
          WorkoutSequenceEvent.guide(text: 'Be in position'),
          WorkoutSequenceEvent.end(),
        ],
      );
    });

    test('ascending count emits one event for each ascending number', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 1),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(
        _countValues(events),
        [1, 2],
      );
    });

    test('descending count emits one event for each descending number', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 1),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.count(
              count: 5,
              direction: WorkoutCountDirection.descending,
            ),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(
        _countValues(events),
        [5, 4, 3, 2, 1],
      );
    });

    test('relax emits its configured duration and is not a speech event', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 1),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.relax(durationInSeconds: 2),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(events.first.type, WorkoutSequenceEventType.relax);
      expect(events.first.durationInSeconds, 2);
      expect(events.first.shouldSpeak, isFalse);
    });

    test('end terminates execution', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 1),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.guide(text: 'Before end'),
            WorkoutSequenceStep.end(),
            WorkoutSequenceStep.guide(text: 'After end'),
          ],
        ),
      );

      expect(
        events,
        [
          WorkoutSequenceEvent.guide(text: 'Before end'),
          WorkoutSequenceEvent.end(),
        ],
      );
    });

    test('counter repeats its contained block exactly by workout repetitions', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 3),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.counter(),
            WorkoutSequenceStep.guide(text: 'Up'),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(_guideTexts(events), ['Up', 'Up', 'Up']);
      expect(_countValues(events), [1, 2, 1, 2, 1, 2]);
    });

    test('steps before counter do not repeat', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 3),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.guide(text: 'Intro'),
            WorkoutSequenceStep.counter(),
            WorkoutSequenceStep.guide(text: 'Repeat'),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(_guideTexts(events), ['Intro', 'Repeat', 'Repeat', 'Repeat']);
    });

    test('break exits the counter-controlled block and continues after break', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 2),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.counter(),
            WorkoutSequenceStep.guide(text: 'Repeat'),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.guide(text: 'After break'),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(
        _guideTexts(events),
        ['Repeat', 'Repeat', 'After break'],
      );
    });

    test('iteration number is exposed for every counter iteration event', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 3),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.counter(),
            WorkoutSequenceStep.guide(text: 'Up'),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      final repeatedEvents = events
          .where((event) => event.type != WorkoutSequenceEventType.end)
          .toList();

      expect(
        repeatedEvents.map((event) => event.iterationNumber).toList(),
        [1, 1, 1, 2, 2, 2, 3, 3, 3],
      );
    });

    test('bicep curl reference behaviour is representable exactly', () {
      final events = executor.execute(
        workoutExercise: _workoutExercise(repetitions: 10),
        sequenceDefinition: WorkoutSequenceDefinition(
          steps: [
            WorkoutSequenceStep.guide(text: 'One stop bicep curl'),
            WorkoutSequenceStep.guide(
              text: 'Be in position. Hold the dumbbell in position.',
            ),
            WorkoutSequenceStep.guide(
              text: 'Workout begins in 5 seconds',
            ),
            WorkoutSequenceStep.count(
              count: 5,
              direction: WorkoutCountDirection.descending,
            ),
            WorkoutSequenceStep.counter(),
            WorkoutSequenceStep.guide(text: 'Up'),
            WorkoutSequenceStep.guide(text: 'Hold'),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.guide(text: 'Squeeze'),
            WorkoutSequenceStep.guide(text: 'Release'),
            WorkoutSequenceStep.guide(text: 'Hold'),
            WorkoutSequenceStep.count(
              count: 2,
              direction: WorkoutCountDirection.ascending,
            ),
            WorkoutSequenceStep.guide(text: 'Release'),
            WorkoutSequenceStep.relax(durationInSeconds: 2),
            WorkoutSequenceStep.sequenceBreak(),
            WorkoutSequenceStep.end(),
          ],
        ),
      );

      expect(
        _guideTexts(events).take(3).toList(),
        [
          'One stop bicep curl',
          'Be in position. Hold the dumbbell in position.',
          'Workout begins in 5 seconds',
        ],
      );
      expect(_countValues(events).take(5).toList(), [5, 4, 3, 2, 1]);

      final repeatedEvents = events
          .where((event) => event.iterationNumber != null)
          .toList();
      final relaxEvents = repeatedEvents
          .where((event) => event.type == WorkoutSequenceEventType.relax)
          .toList();

      expect(
        repeatedEvents.map((event) => event.iterationNumber).toSet(),
        {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
      );
      expect(relaxEvents, hasLength(10));
      expect(
        relaxEvents.every(
          (event) =>
              event.durationInSeconds == 2 &&
              event.shouldSpeak == false,
        ),
        isTrue,
      );

      final firstIterationEvents = repeatedEvents
          .where((event) => event.iterationNumber == 1)
          .toList();

      expect(
        firstIterationEvents,
        [
          WorkoutSequenceEvent.guide(text: 'Up', iterationNumber: 1),
          WorkoutSequenceEvent.guide(text: 'Hold', iterationNumber: 1),
          WorkoutSequenceEvent.count(value: 1, iterationNumber: 1),
          WorkoutSequenceEvent.count(value: 2, iterationNumber: 1),
          WorkoutSequenceEvent.guide(text: 'Squeeze', iterationNumber: 1),
          WorkoutSequenceEvent.guide(text: 'Release', iterationNumber: 1),
          WorkoutSequenceEvent.guide(text: 'Hold', iterationNumber: 1),
          WorkoutSequenceEvent.count(value: 1, iterationNumber: 1),
          WorkoutSequenceEvent.count(value: 2, iterationNumber: 1),
          WorkoutSequenceEvent.guide(text: 'Release', iterationNumber: 1),
          WorkoutSequenceEvent.relax(
            durationInSeconds: 2,
            iterationNumber: 1,
          ),
        ],
      );

      expect(events.last.type, WorkoutSequenceEventType.end);
    });

    test('invalid counts are rejected consistently', () {
      expect(
        () => WorkoutSequenceStep.count(
          count: 0,
          direction: WorkoutCountDirection.ascending,
        ),
        throwsArgumentError,
      );
    });

    test('invalid counter and break structures are rejected consistently', () {
      expect(
        () => executor.execute(
          workoutExercise: _workoutExercise(repetitions: 3),
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.sequenceBreak(),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
        throwsStateError,
      );

      expect(
        () => executor.execute(
          workoutExercise: _workoutExercise(repetitions: 3),
          sequenceDefinition: WorkoutSequenceDefinition(
            steps: [
              WorkoutSequenceStep.counter(),
              WorkoutSequenceStep.guide(text: 'Repeat'),
              WorkoutSequenceStep.end(),
            ],
          ),
        ),
        throwsStateError,
      );
    });
  });
}

List<int> _countValues(List<WorkoutSequenceEvent> events) {
  return events
      .where((event) => event.type == WorkoutSequenceEventType.count)
      .map((event) => event.countValue!)
      .toList();
}

List<String> _guideTexts(List<WorkoutSequenceEvent> events) {
  return events
      .where((event) => event.type == WorkoutSequenceEventType.guide)
      .map((event) => event.guideText!)
      .toList();
}

WorkoutExercise _workoutExercise({required int repetitions}) {
  return WorkoutExercise(
    id: 'workout-exercise-1',
    workoutGroupId: 'group-1',
    exerciseId: 'exercise-1',
    displayOrder: 1,
    sets: 1,
    targetType: WorkoutTargetType.repetitions,
    repetitions: repetitions,
    restInSeconds: 30,
  );
}
