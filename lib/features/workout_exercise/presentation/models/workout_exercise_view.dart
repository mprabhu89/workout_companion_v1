import '../../domain/entities/workout_exercise.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../domain/entities/workout_target_type.dart';

class WorkoutExerciseView {
  const WorkoutExerciseView({
    required this.workoutExercise,
    required this.exercise,
  });

  final WorkoutExercise workoutExercise;
  final Exercise exercise;

  String get title => exercise.name;

  String get subtitle {
    final e = workoutExercise;

    final buffer = <String>[];

    if (e.sets != null) {
      buffer.add('${e.sets} Sets');
    }

    switch (e.targetType) {
      case WorkoutTargetType.repetitions:
        if (e.repetitions != null) {
          buffer.add('${e.repetitions} Reps');
        }
        break;

      case WorkoutTargetType.duration:
        if (e.durationInSeconds != null) {
          buffer.add('${e.durationInSeconds}s');
        }
        break;

      default:
        break;
    }

    if (e.restInSeconds != null) {
      buffer.add('Rest ${e.restInSeconds}s');
    }

    return buffer.join(' • ');
  }
}