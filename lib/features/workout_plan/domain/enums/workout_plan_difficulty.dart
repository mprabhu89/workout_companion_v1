enum WorkoutPlanDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  const WorkoutPlanDifficulty(this.displayName);

  final String displayName;
}