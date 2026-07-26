enum EquipmentType {
  bodyweight('Bodyweight'),
  dumbbell('Dumbbell'),
  barbell('Barbell'),
  kettlebell('Kettlebell'),
  resistanceBand('Resistance Band'),
  cable('Cable Machine'),
  machine('Machine'),
  smithMachine('Smith Machine'),
  medicineBall('Medicine Ball'),
  stabilityBall('Stability Ball'),
  trx('TRX / Suspension Trainer'),
  bench('Bench'),
  pullUpBar('Pull-up Bar'),
  cardioMachine('Cardio Machine'),
  other('Other');

  const EquipmentType(this.displayName);

  final String displayName;
}