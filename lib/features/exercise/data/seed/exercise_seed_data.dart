import '../../domain/entities/exercise.dart';
import '../../domain/enums/difficulty_level.dart';
import '../../domain/enums/equipment_type.dart';
import '../../domain/enums/muscle_group.dart';

class ExerciseSeedData {
  const ExerciseSeedData._();

  static List<Exercise> build() {
    return [
      Exercise(
        id: 'exercise_push_up',
        name: 'Push-up',
        description: 'Classic bodyweight chest exercise.',
        instructions:
            'Keep your body straight. Lower until your chest is close to the floor, then push back up.',
        muscleGroup: MuscleGroup.chest,
        equipment: EquipmentType.bodyweight,
        difficulty: DifficultyLevel.beginner,
      ),
      Exercise(
        id: 'exercise_bench_press',
        name: 'Barbell Bench Press',
        description: 'Compound chest pressing movement.',
        instructions:
            'Lower the bar under control to the chest, then press back to full arm extension.',
        muscleGroup: MuscleGroup.chest,
        equipment: EquipmentType.barbell,
        difficulty: DifficultyLevel.intermediate,
      ),
      Exercise(
        id: 'exercise_incline_db_press',
        name: 'Incline Dumbbell Press',
        description: 'Upper chest pressing exercise.',
        instructions:
            'Press the dumbbells upward while maintaining shoulder stability.',
        muscleGroup: MuscleGroup.chest,
        equipment: EquipmentType.dumbbell,
        difficulty: DifficultyLevel.intermediate,
      ),
      Exercise(
        id: 'exercise_pull_up',
        name: 'Pull-up',
        description: 'Bodyweight vertical pulling exercise.',
        instructions:
            'Pull your chin above the bar while keeping your body under control.',
        muscleGroup: MuscleGroup.back,
        equipment: EquipmentType.pullUpBar,
        difficulty: DifficultyLevel.advanced,
      ),
      Exercise(
        id: 'exercise_lat_pulldown',
        name: 'Lat Pulldown',
        description: 'Machine-based vertical pulling exercise.',
        instructions:
            'Pull the bar toward your upper chest while squeezing your back muscles.',
        muscleGroup: MuscleGroup.back,
        equipment: EquipmentType.cable,
        difficulty: DifficultyLevel.beginner,
      ),
      Exercise(
        id: 'exercise_barbell_squat',
        name: 'Barbell Squat',
        description: 'Primary lower-body compound movement.',
        instructions:
            'Squat until your thighs are at least parallel to the floor, then stand back up.',
        muscleGroup: MuscleGroup.quadriceps,
        equipment: EquipmentType.barbell,
        difficulty: DifficultyLevel.intermediate,
      ),
      Exercise(
        id: 'exercise_rdl',
        name: 'Romanian Deadlift',
        description: 'Posterior-chain strengthening exercise.',
        instructions:
            'Hinge at the hips while keeping your back neutral, then return to standing.',
        muscleGroup: MuscleGroup.hamstrings,
        equipment: EquipmentType.barbell,
        difficulty: DifficultyLevel.intermediate,
      ),
      Exercise(
        id: 'exercise_plank',
        name: 'Plank',
        description: 'Core stability exercise.',
        instructions:
            'Maintain a straight body position while bracing your core.',
        muscleGroup: MuscleGroup.core,
        equipment: EquipmentType.bodyweight,
        difficulty: DifficultyLevel.beginner,
      ),
      Exercise(
        id: 'exercise_shoulder_press',
        name: 'Dumbbell Shoulder Press',
        description: 'Overhead pressing movement.',
        instructions:
            'Press the dumbbells overhead until your elbows are fully extended.',
        muscleGroup: MuscleGroup.shoulders,
        equipment: EquipmentType.dumbbell,
        difficulty: DifficultyLevel.intermediate,
      ),
      Exercise(
        id: 'exercise_barbell_curl',
        name: 'Barbell Curl',
        description: 'Isolation exercise for the biceps.',
        instructions:
            'Curl the bar toward your shoulders without swinging your body.',
        muscleGroup: MuscleGroup.biceps,
        equipment: EquipmentType.barbell,
        difficulty: DifficultyLevel.beginner,
      ),
    ];
  }
}