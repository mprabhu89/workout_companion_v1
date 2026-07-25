import '../../features/workout/data/repositories/in_memory_exercise_repository.dart';
import '../../features/workout/domain/repositories/exercise_repository.dart';
import '../../features/workout_group/data/repositories/in_memory_workout_group_repository.dart';
import '../../features/workout_group/domain/repositories/workout_group_repository.dart';
import '../../features/workout_plan/data/repositories/in_memory_workout_plan_repository.dart';
import '../../features/workout_plan/domain/repositories/workout_plan_repository.dart';
import '../../features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import '../../features/workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../features/workout_day/data/repositories/in_memory_workout_day_repository.dart';
import '../../features/workout_day/domain/repositories/workout_day_repository.dart';

/// Temporary dependency container.
///
/// While we are using in-memory repositories, the application should share
/// exactly one instance of each repository.
///
/// Later, when we migrate to Drift, only this file should change.
final class RepositoryRegistry {
  RepositoryRegistry._();

  static final ExerciseRepository exerciseRepository =
      InMemoryExerciseRepository();
  static final WorkoutExerciseRepository workoutExerciseRepository =
    InMemoryWorkoutExerciseRepository();

  static final WorkoutPlanRepository workoutPlanRepository =
      InMemoryWorkoutPlanRepository();

  static final WorkoutDayRepository workoutDayRepository =
      InMemoryWorkoutDayRepository();

  static final WorkoutGroupRepository workoutGroupRepository =
    InMemoryWorkoutGroupRepository();
}
