enum WorkoutSequenceStepType {
  guide,
  count,
  counter,
  relax,
  sequenceBreak,
  end,
}

enum WorkoutCountDirection {
  ascending,
  descending,
}

class WorkoutSequenceStep {
  const WorkoutSequenceStep._({
    required this.type,
    this.text,
    this.count,
    this.countDirection,
    this.durationInSeconds,
  });

  factory WorkoutSequenceStep.guide({
    required String text,
  }) {
    return WorkoutSequenceStep._(
      type: WorkoutSequenceStepType.guide,
      text: text,
    );
  }

  factory WorkoutSequenceStep.count({
    required int count,
    required WorkoutCountDirection direction,
  }) {
    if (count <= 0) {
      throw ArgumentError.value(
        count,
        'count',
        'Count must be greater than zero.',
      );
    }

    return WorkoutSequenceStep._(
      type: WorkoutSequenceStepType.count,
      count: count,
      countDirection: direction,
    );
  }

  factory WorkoutSequenceStep.counter() {
    return const WorkoutSequenceStep._(
      type: WorkoutSequenceStepType.counter,
    );
  }

  factory WorkoutSequenceStep.relax({
    required int durationInSeconds,
  }) {
    if (durationInSeconds < 0) {
      throw ArgumentError.value(
        durationInSeconds,
        'durationInSeconds',
        'Relax duration must be non-negative.',
      );
    }

    return WorkoutSequenceStep._(
      type: WorkoutSequenceStepType.relax,
      durationInSeconds: durationInSeconds,
    );
  }

  factory WorkoutSequenceStep.sequenceBreak() {
    return const WorkoutSequenceStep._(
      type: WorkoutSequenceStepType.sequenceBreak,
    );
  }

  factory WorkoutSequenceStep.end() {
    return const WorkoutSequenceStep._(
      type: WorkoutSequenceStepType.end,
    );
  }

  final WorkoutSequenceStepType type;
  final String? text;
  final int? count;
  final WorkoutCountDirection? countDirection;
  final int? durationInSeconds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSequenceStep &&
          type == other.type &&
          text == other.text &&
          count == other.count &&
          countDirection == other.countDirection &&
          durationInSeconds == other.durationInSeconds;

  @override
  int get hashCode => Object.hash(
        type,
        text,
        count,
        countDirection,
        durationInSeconds,
      );
}
