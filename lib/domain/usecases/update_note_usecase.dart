import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<NoteEntity> call(NoteEntity note) async {
    if (note.title.trim().isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    if (note.description.trim().isEmpty) {
      throw ArgumentError('La descripción no puede estar vacía');
    }
    
    final updatedNote = note.copyWith(
      title: note.title.trim(),
      description: note.description.trim(),
      updatedAt: DateTime.now(),
    );
    
    return await repository.updateNote(updatedNote);
  }
}