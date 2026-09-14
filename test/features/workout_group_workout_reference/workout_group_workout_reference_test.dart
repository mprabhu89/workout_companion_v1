import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_group/data/repositories/in_memory_workout_group_repository.dart';
import 'package:workout_companion_v1/features/workout_group/domain/entities/workout_group.dart';
import 'package:workout_companion_v1/features/workout_group_workout_reference/data/repositories/in_memory_workout_group_workout_reference_repository.dart';
import 'package:workout_companion_v1/features/workout_group_workout_reference/domain/entities/workout_group_workout_reference.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_session_builder.dart';

void main() {
  group('Workout group workout references', () {
    test('canonical library workout has no legacy group ownership', () async {
      final workouts = InMemoryWorkoutExerciseRepository();
      final workout = _workout(id: 'push-ups');

      await workouts.saveWorkoutExercise(workout);

      expect((await workouts.getAllWorkoutExercises()).single.workoutGroupId, isNull);
    });

    test('references reuse one workout across groups and prevent duplicates', () async {
      final references = InMemoryWorkoutGroupWorkoutReferenceRepository();
      final workout = _workout(id: 'push-ups');

      await references.saveReference(_reference(
        id: 'a',
        groupId: 'group-a',
        workoutId: workout.id,
        order: 1,
      ));
      await references.saveReference(_reference(
        id: 'b',
        groupId: 'group-b',
        workoutId: workout.id,
        order: 1,
      ));

      expect((await references.getReferences('group-a')).single.workoutExerciseId, workout.id);
      expect((await references.getReferences('group-b')).single.workoutExerciseId, workout.id);
      await expectLater(
        references.saveReference(_reference(
          id: 'duplicate',
          groupId: 'group-a',
          workoutId: workout.id,
          order: 2,
        )),
        throwsA(isA<StateError>()),
      );
    });

    test('removing and reordering references leaves canonical workouts intact', () async {
      final references = InMemoryWorkoutGroupWorkoutReferenceRepository();
      final workouts = InMemoryWorkoutExerciseRepository();
      final pushUps = _workout(id: 'push-ups');
      final squats = _workout(id: 'squats');
      await workouts.saveWorkoutExercise(pushUps);
      await workouts.saveWorkoutExercise(squats);
      await references.saveReference(_reference(id: 'push', groupId: 'group', workoutId: pushUps.id, order: 1));
      await references.saveReference(_reference(id: 'squat', groupId: 'group', workoutId: squats.id, order: 2));

      final ordered = await references.getReferences('group');
      await references.saveReference(ordered[0].copyWith(displayOrder: 2));
      await references.saveReference(ordered[1].copyWith(displayOrder: 1));
      expect(
        (await references.getReferences('group')).map((reference) => reference.workoutExerciseId),
        [squats.id, pushUps.id],
      );

      await references.archiveReference('push');
      expect(await workouts.getWorkoutExerciseById(pushUps.id), pushUps);
      expect(
        (await references.getReferences('group')).map((reference) => reference.workoutExerciseId),
        [squats.id],
      );
    });

    test('session builder resolves reference order before legacy ownership', () async {
      final groups = InMemoryWorkoutGroupRepository();
      final workouts = InMemoryWorkoutExerciseRepository();
      final references = InMemoryWorkoutGroupWorkoutReferenceRepository();
      await groups.saveWorkoutGroup(const WorkoutGroup(
        id: 'group',
        workoutDayId: 'day',
        name: 'Main',
        displayOrder: 1,
      ));
      final first = _workout(id: 'first');
      final second = _workout(id: 'second');
      await workouts.saveWorkoutExercise(first);
      await workouts.saveWorkoutExercise(second);
      await references.saveReference(_reference(id: 'second-ref', groupId: 'group', workoutId: second.id, order: 1));
      await references.saveReference(_reference(id: 'first-ref', groupId: 'group', workoutId: first.id, order: 2));

      final session = await WorkoutSessionBuilder(
        workoutGroupRepository: groups,
        workoutExerciseRepository: workouts,
        referenceRepository: references,
      ).build(workoutDayId: 'day');

      expect(session.workoutExercises.map((workout) => workout.id), [second.id, first.id]);
      expect(session.workoutExercises.every((workout) => workout.workoutGroupId == 'group'), isTrue);
    });
  });
}

WorkoutExercise _workout({required String id}) {
  return WorkoutExercise(
    id: id,
    exerciseId: 'exercise-$id',
    displayOrder: 0,
    targetType: WorkoutTargetType.repetitions,
  );
}

WorkoutGroupWorkoutReference _reference({
  required String id,
  required String groupId,
  required String workoutId,
  required int order,
}) {
  return WorkoutGroupWorkoutReference(
    id: id,
    workoutGroupId: groupId,
    workoutExerciseId: workoutId,
    displayOrder: order,
  );
}
