import '../database/isar_database.dart';
import '../../features/exercise/data/repositories/in_memory_exercise_repository.dart';
import '../../features/exercise/data/repositories/isar_exercise_repository.dart';
import '../../features/exercise/domain/repositories/exercise_repository.dart';
import '../../features/workout_group/data/repositories/in_memory_workout_group_repository.dart';
import '../../features/workout_group/data/repositories/isar_workout_group_repository.dart';
import '../../features/workout_group/domain/repositories/workout_group_repository.dart';
import '../../features/workout_plan/data/repositories/in_memory_workout_plan_repository.dart';
import '../../features/workout_plan/data/repositories/isar_workout_plan_repository.dart';
import '../../features/workout_plan/domain/repositories/workout_plan_repository.dart';
import '../../features/workout_exercise/data/repositories/in_memory_workout_exercise_repository.dart';
import '../../features/workout_exercise/data/repositories/isar_workout_exercise_repository.dart';
import '../../features/workout_exercise/domain/repositories/workout_exercise_repository.dart';
import '../../features/workout_day/data/repositories/in_memory_workout_day_repository.dart';
import '../../features/workout_day/data/repositories/isar_workout_day_repository.dart';
import '../../features/workout_day/domain/repositories/workout_day_repository.dart';
import '../../features/workout_history/data/repositories/in_memory_workout_history_repository.dart';
import '../../features/workout_history/data/repositories/isar_workout_history_repository.dart';
import '../../features/workout_history/domain/repositories/workout_history_repository.dart';

/// Temporary dependency container.
///
/// While we are using in-memory repositories, the application should share
/// exactly one instance of each repository.
///
/// Later, when we migrate to Drift, only this file should change.
final class RepositoryRegistry {
  RepositoryRegistry._();

  static ExerciseRepository exerciseRepository =
      InMemoryExerciseRepository();
  static WorkoutExerciseRepository workoutExerciseRepository =
    InMemoryWorkoutExerciseRepository();

  static WorkoutPlanRepository workoutPlanRepository =
      InMemoryWorkoutPlanRepository();

  static WorkoutDayRepository workoutDayRepository =
      InMemoryWorkoutDayRepository();

  static WorkoutGroupRepository workoutGroupRepository =
    InMemoryWorkoutGroupRepository();

  static WorkoutHistoryRepository workoutHistoryRepository =
    InMemoryWorkoutHistoryRepository();

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final database = await IsarDatabase.initialize();
    final isar = database.isar;

    await IsarExerciseRepository.seedIfEmpty(isar);

    exerciseRepository = IsarExerciseRepository(isar);
    workoutExerciseRepository =
        IsarWorkoutExerciseRepository(isar);
    workoutPlanRepository =
        IsarWorkoutPlanRepository(isar);
    workoutDayRepository =
        IsarWorkoutDayRepository(isar);
    workoutGroupRepository =
        IsarWorkoutGroupRepository(isar);
    workoutHistoryRepository =
        IsarWorkoutHistoryRepository(isar);

    _isInitialized = true;
  }

  static Future<void> close() async {
    _isInitialized = false;

    exerciseRepository = InMemoryExerciseRepository();
    workoutExerciseRepository =
        InMemoryWorkoutExerciseRepository();
    workoutPlanRepository =
        InMemoryWorkoutPlanRepository();
    workoutDayRepository =
        InMemoryWorkoutDayRepository();
    workoutGroupRepository =
        InMemoryWorkoutGroupRepository();
    workoutHistoryRepository =
        InMemoryWorkoutHistoryRepository();

    await IsarDatabase.closeInstance();
  }
}
