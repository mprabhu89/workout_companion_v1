/// Represents a reusable exercise in the Workout Companion library.
///
/// An Exercise is the master definition that can be reused across
/// multiple workout plans.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    this.description = '',
    this.defaultRestSeconds = 60,
    this.isEnabled = true,
  });

  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional description or coaching notes.
  final String description;

  /// Default rest duration after completing this exercise.
  final int defaultRestSeconds;

  /// Indicates whether this exercise is available for use.
  final bool isEnabled;

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    int? defaultRestSeconds,
    bool? isEnabled,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      defaultRestSeconds:
          defaultRestSeconds ?? this.defaultRestSeconds,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  String toString() {
    return 'Exercise('
        'id: $id, '
        'name: $name, '
        'description: $description, '
        'defaultRestSeconds: $defaultRestSeconds, '
        'isEnabled: $isEnabled'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Exercise &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            defaultRestSeconds == other.defaultRestSeconds &&
            isEnabled == other.isEnabled;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        defaultRestSeconds,
        isEnabled,
      );
}