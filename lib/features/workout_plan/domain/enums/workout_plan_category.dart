enum WorkoutPlanCategory {
  strength('Strength'),
  hypertrophy('Hypertrophy'),
  fatLoss('Fat Loss'),
  cardio('Cardio'),
  mobility('Mobility'),
  rehabilitation('Rehabilitation'),
  sports('Sports'),
  generalFitness('General Fitness'),
  custom('Custom');

  const WorkoutPlanCategory(this.displayName);

  final String displayName;
}