class NoteEntity {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  NoteEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}
