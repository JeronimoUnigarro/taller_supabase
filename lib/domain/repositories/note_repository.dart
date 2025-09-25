import '../entities/note_entity.dart';

abstract class NoteRepository {
  Future<List<NoteEntity>> getAllNotes();
  Future<NoteEntity?> getNoteById(String id);
  Future<NoteEntity> createNote(String title, String description);
  Future<NoteEntity> updateNote(NoteEntity note);
  Future<void> deleteNote(String id);
  Future<List<NoteEntity>> searchNotes(String query);
}