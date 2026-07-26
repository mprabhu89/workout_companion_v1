enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  biceps('Biceps'),
  triceps('Triceps'),
  forearms('Forearms'),
  quadriceps('Quadriceps'),
  hamstrings('Hamstrings'),
  glutes('Glutes'),
  calves('Calves'),
  core('Core'),
  fullBody('Full Body'),
  cardio('Cardio'),
  mobility('Mobility');

  const MuscleGroup(this.displayName);

  final String displayName;
}