import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetAllNotesUseCase {
  final NoteRepository repository;

  GetAllNotesUseCase(this.repository);

  Future<List<NoteEntity>> call() async {
    return await repository.getAllNotes();
  }
}