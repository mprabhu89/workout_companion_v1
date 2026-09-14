import '../../../workout_exercise/domain/entities/workout_exercise.dart';
import '../../../workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../../workout_group/domain/entities/workout_group.dart';
import '../../../workout_group/domain/repositories/workout_group_repository.dart';
import '../../../workout_group_workout_reference/domain/repositories/workout_group_workout_reference_repository.dart';
import '../../../workout_plan/domain/enums/workout_plan_category.dart';
import '../entities/workout_session.dart';

class WorkoutSessionBuilder {
  WorkoutSessionBuilder({
    required this._workoutGroupRepository,
    required this._workoutExerciseRepository,
    this._referenceRepository,
  });

  final WorkoutGroupRepository _workoutGroupRepository;
  final WorkoutExerciseRepository _workoutExerciseRepository;
  final WorkoutGroupWorkoutReferenceRepository? _referenceRepository;

  Future<WorkoutSession> build({
    required String workoutDayId,
    String? workoutPlanId,
    String? workoutPlanName,
    WorkoutPlanCategory? workoutPlanCategory,
    String? workoutDayName,
  }) async {
    final List<WorkoutGroup> groups =
        await _workoutGroupRepository.getWorkoutGroups(workoutDayId);

    final List<WorkoutExercise> exercises = [];

    for (final group in groups) {
      final references = await _referenceRepository?.getReferences(group.id) ?? const [];
      final groupExercises = references.isEmpty
          ? await _workoutExerciseRepository.getWorkoutExercises(group.id)
          : await Future.wait(references.map((reference) async {
              final workout = await _workoutExerciseRepository
                  .getWorkoutExerciseById(reference.workoutExerciseId);
              return workout?.copyWith(
                workoutGroupId: group.id,
                displayOrder: reference.displayOrder,
              );
            })).then((workouts) => workouts.whereType<WorkoutExercise>().toList());

      exercises.addAll(
        groupExercises.where(
          (exercise) => !exercise.isArchived,
        ),
      );
    }

    return WorkoutSession(
      workoutExercises: List.unmodifiable(exercises),
      workoutPlanId: workoutPlanId,
      workoutPlanName: workoutPlanName,
      workoutPlanCategory: workoutPlanCategory,
      workoutDayId: workoutDayId,
      workoutDayName: workoutDayName,
    );
  }
}
