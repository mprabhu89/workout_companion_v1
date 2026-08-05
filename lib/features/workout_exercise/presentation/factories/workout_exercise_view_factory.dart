import '../../../exercise/domain/entities/exercise.dart';
import '../../domain/entities/workout_exercise.dart';
import '../models/workout_exercise_view.dart';

class WorkoutExerciseViewFactory {
  const WorkoutExerciseViewFactory._();

  static WorkoutExerciseView create({
    required WorkoutExercise workoutExercise,
    required Exercise exercise,
  }) {
    return WorkoutExerciseView(
      workoutExercise: workoutExercise,
      exercise: exercise,
    );
  }
}