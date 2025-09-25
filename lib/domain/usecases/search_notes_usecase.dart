import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class SearchNotesUseCase {
  final NoteRepository repository;

  SearchNotesUseCase(this.repository);

  Future<List<NoteEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getAllNotes();
    }
    
    return await repository.searchNotes(query.trim());
  }
}