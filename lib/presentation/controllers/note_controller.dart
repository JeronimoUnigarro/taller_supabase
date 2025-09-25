import 'package:get/get.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';

class NoteController extends GetxController {
  final NoteRepository repository;

  NoteController({required this.repository});

  var notes = <NoteEntity>[].obs;

  Future<void> loadNotes() async {
    notes.value = await repository.getNotes();
  }

  Future<void> addNote(String title, String description) async {
    await repository.addNote(title, description);
    await loadNotes();
  }
}
