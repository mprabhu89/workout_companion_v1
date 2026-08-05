enum ExerciseCueTriggerType {
  immediately,
  elapsedTime,
  remainingTime,
  repetition,
}

class ExerciseCue {
  const ExerciseCue({
    required this.id,
    required this.exerciseId,
    required this.displayOrder,
    required this.triggerType,
    required this.triggerValue,
    required this.message,
    this.isArchived = false,
  });

  final String id;

  /// Exercise from the Exercise Library.
  final String exerciseId;

  /// Order of execution.
  final int displayOrder;

  /// When this cue should fire.
  final ExerciseCueTriggerType triggerType;

  /// Meaning depends on triggerType.
  ///
  /// elapsedTime -> seconds
  /// remainingTime -> seconds
  /// repetition -> rep number
  final int triggerValue;

  /// Text spoken by TTS and shown on screen.
  final String message;

  final bool isArchived;

  ExerciseCue copyWith({
    String? id,
    String? exerciseId,
    int? displayOrder,
    ExerciseCueTriggerType? triggerType,
    int? triggerValue,
    String? message,
    bool? isArchived,
  }) {
    return ExerciseCue(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      displayOrder: displayOrder ?? this.displayOrder,
      triggerType: triggerType ?? this.triggerType,
      triggerValue: triggerValue ?? this.triggerValue,
      message: message ?? this.message,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseCue &&
          id == other.id &&
          exerciseId == other.exerciseId &&
          displayOrder == other.displayOrder &&
          triggerType == other.triggerType &&
          triggerValue == other.triggerValue &&
          message == other.message &&
          isArchived == other.isArchived;

  @override
  int get hashCode => Object.hash(
        id,
        exerciseId,
        displayOrder,
        triggerType,
        triggerValue,
        message,
        isArchived,
      );

  @override
  String toString() =>
      'ExerciseCue(id: $id, order: $displayOrder)';
}