import '../repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<void> call(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('El ID de la nota no puede estar vacío');
    }
    
    return await repository.deleteNote(id.trim());
  }
}