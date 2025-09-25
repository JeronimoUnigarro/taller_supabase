class NoteEntity {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const NoteEntity({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  NoteEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'NoteEntity(id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}