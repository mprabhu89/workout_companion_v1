import 'package:flutter_test/flutter_test.dart';
import 'package:workout_companion_v1/features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_exercise.dart';
import 'package:workout_companion_v1/features/workout_exercise/domain/entities/workout_target_type.dart';
import 'package:workout_companion_v1/features/workout_group/data/repositories/in_memory_workout_group_repository.dart';
import 'package:workout_companion_v1/features/workout_group/domain/entities/workout_group.dart';
import 'package:workout_companion_v1/features/workout_plan/domain/enums/workout_plan_category.dart';
import 'package:workout_companion_v1/features/workout_session/domain/services/workout_session_builder.dart';

void main() {
  group('WorkoutSessionBuilder', () {
    test('builds an ordered exercise queue from workout groups and exercises', () async {
      final workoutGroupRepository =
          InMemoryWorkoutGroupRepository();
      final workoutExerciseRepository =
          InMemoryWorkoutExerciseRepository();
      final builder = WorkoutSessionBuilder(
        workoutGroupRepository: workoutGroupRepository,
        workoutExerciseRepository:
            workoutExerciseRepository,
      );

      await workoutGroupRepository.saveWorkoutGroup(
        const WorkoutGroup(
          id: 'group-2',
          workoutDayId: 'day-1',
          name: 'Second group',
          displayOrder: 2,
        ),
      );
      await workoutGroupRepository.saveWorkoutGroup(
        const WorkoutGroup(
          id: 'group-1',
          workoutDayId: 'day-1',
          name: 'First group',
          displayOrder: 1,
        ),
      );

      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'exercise-2',
          workoutGroupId: 'group-1',
          displayOrder: 2,
        ),
      );
      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'exercise-1',
          workoutGroupId: 'group-1',
          displayOrder: 1,
        ),
      );
      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'exercise-4',
          workoutGroupId: 'group-2',
          displayOrder: 2,
        ),
      );
      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'exercise-3',
          workoutGroupId: 'group-2',
          displayOrder: 1,
        ),
      );

      final session = await builder.build(
        workoutDayId: 'day-1',
        workoutPlanId: 'plan-1',
        workoutPlanName: 'Plan',
        workoutPlanCategory: WorkoutPlanCategory.cardio,
        workoutDayName: 'Day 1',
      );

      expect(
        session.workoutExercises.map((e) => e.id).toList(),
        ['exercise-1', 'exercise-2', 'exercise-3', 'exercise-4'],
      );
      expect(session.totalExercises, 4);
      expect(session.workoutPlanCategory, WorkoutPlanCategory.cardio);
    });

    test('excludes archived entities according to queue-building semantics', () async {
      final workoutGroupRepository =
          InMemoryWorkoutGroupRepository();
      final workoutExerciseRepository =
          InMemoryWorkoutExerciseRepository();
      final builder = WorkoutSessionBuilder(
        workoutGroupRepository: workoutGroupRepository,
        workoutExerciseRepository:
            workoutExerciseRepository,
      );

      await workoutGroupRepository.saveWorkoutGroup(
        const WorkoutGroup(
          id: 'group-active',
          workoutDayId: 'day-1',
          name: 'Active group',
          displayOrder: 1,
        ),
      );
      await workoutGroupRepository.saveWorkoutGroup(
        const WorkoutGroup(
          id: 'group-archived',
          workoutDayId: 'day-1',
          name: 'Archived group',
          displayOrder: 2,
          isArchived: true,
        ),
      );

      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'active-exercise',
          workoutGroupId: 'group-active',
          displayOrder: 1,
        ),
      );
      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'archived-exercise',
          workoutGroupId: 'group-active',
          displayOrder: 2,
          isArchived: true,
        ),
      );
      await workoutExerciseRepository.saveWorkoutExercise(
        _exercise(
          id: 'excluded-by-group',
          workoutGroupId: 'group-archived',
          displayOrder: 1,
        ),
      );

      final session = await builder.build(
        workoutDayId: 'day-1',
      );

      expect(
        session.workoutExercises.map((e) => e.id).toList(),
        ['active-exercise'],
      );
    });

    test('returns an empty session safely when a workout day has no exercises', () async {
      final builder = WorkoutSessionBuilder(
        workoutGroupRepository:
            InMemoryWorkoutGroupRepository(),
        workoutExerciseRepository:
            InMemoryWorkoutExerciseRepository(),
      );

      final session = await builder.build(
        workoutDayId: 'empty-day',
      );

      expect(session.workoutExercises, isEmpty);
      expect(session.totalExercises, 0);
      expect(session.completedExerciseCount, 0);
    });
  });
}

WorkoutExercise _exercise({
  required String id,
  required String workoutGroupId,
  required int displayOrder,
  bool isArchived = false,
}) {
  return WorkoutExercise(
    id: id,
    workoutGroupId: workoutGroupId,
    exerciseId: id,
    displayOrder: displayOrder,
    sets: 1,
    targetType: WorkoutTargetType.repetitions,
    repetitions: 10,
    isArchived: isArchived,
  );
}
