import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class CreateNoteUseCase {
  final NoteRepository repository;

  CreateNoteUseCase(this.repository);

  Future<NoteEntity> call(String title, String description) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('La descripción no puede estar vacía');
    }
    
    return await repository.createNote(title.trim(), description.trim());
  }
}