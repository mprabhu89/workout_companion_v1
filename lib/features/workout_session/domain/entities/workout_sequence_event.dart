enum WorkoutSequenceEventType {
  guide,
  count,
  relax,
  end,
}

class WorkoutSequenceEvent {
  const WorkoutSequenceEvent._({
    required this.type,
    this.guideText,
    this.countValue,
    this.durationInSeconds,
    this.iterationNumber,
  });

  factory WorkoutSequenceEvent.guide({
    required String text,
    int? iterationNumber,
  }) {
    return WorkoutSequenceEvent._(
      type: WorkoutSequenceEventType.guide,
      guideText: text,
      iterationNumber: iterationNumber,
    );
  }

  factory WorkoutSequenceEvent.count({
    required int value,
    int? iterationNumber,
  }) {
    return WorkoutSequenceEvent._(
      type: WorkoutSequenceEventType.count,
      countValue: value,
      iterationNumber: iterationNumber,
    );
  }

  factory WorkoutSequenceEvent.relax({
    required int durationInSeconds,
    int? iterationNumber,
  }) {
    return WorkoutSequenceEvent._(
      type: WorkoutSequenceEventType.relax,
      durationInSeconds: durationInSeconds,
      iterationNumber: iterationNumber,
    );
  }

  factory WorkoutSequenceEvent.end() {
    return const WorkoutSequenceEvent._(
      type: WorkoutSequenceEventType.end,
    );
  }

  final WorkoutSequenceEventType type;
  final String? guideText;
  final int? countValue;
  final int? durationInSeconds;
  final int? iterationNumber;

  bool get shouldSpeak =>
      type == WorkoutSequenceEventType.guide ||
      type == WorkoutSequenceEventType.count;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSequenceEvent &&
          type == other.type &&
          guideText == other.guideText &&
          countValue == other.countValue &&
          durationInSeconds == other.durationInSeconds &&
          iterationNumber == other.iterationNumber;

  @override
  int get hashCode => Object.hash(
        type,
        guideText,
        countValue,
        durationInSeconds,
        iterationNumber,
      );
}
