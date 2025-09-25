import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
