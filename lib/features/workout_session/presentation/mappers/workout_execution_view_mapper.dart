import '../../../exercise/domain/entities/exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../models/workout_execution_view.dart';

class WorkoutExecutionViewMapper {
  const WorkoutExecutionViewMapper._();

  static WorkoutExecutionView map({
    required WorkoutSession session,
    required Exercise exercise,
  }) {
    final workoutExercise = session.currentExercise;

    final subtitleParts = <String>[];

    if (workoutExercise.sets != null) {
      subtitleParts.add('${workoutExercise.sets} Sets');
    }

    if (workoutExercise.repetitions != null) {
      subtitleParts.add(
        '${workoutExercise.repetitions} Reps',
      );
    }

    if (workoutExercise.restInSeconds != null) {
      subtitleParts.add(
        'Rest ${workoutExercise.restInSeconds}s',
      );
    }

    final progress =
        (session.currentExerciseIndex + 1) /
        session.workoutExercises.length;

    return WorkoutExecutionView(
      exerciseName: exercise.name,
      subtitle: subtitleParts.join(' • '),
      currentSetText:
          'Set ${session.currentSet} of ${workoutExercise.sets ?? 1}',
      timerText:
          session.remainingSeconds.toString().padLeft(
                2,
                '0',
              ),
      progress: progress,
      progressText:
          'Exercise ${session.currentExerciseIndex + 1} of ${session.workoutExercises.length}',
      isPaused:
          session.status == WorkoutSessionStatus.paused,
    );
  }
}