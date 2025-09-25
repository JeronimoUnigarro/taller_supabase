import 'package:get/get.dart';
import '../../domain/entities/note_entity.dart';
import '../../data/repositories/note_repository_impl.dart';

class NoteController extends GetxController {
  final NoteRepositoryImpl repository;

  NoteController({required this.repository});

  RxList<NoteEntity> notes = <NoteEntity>[].obs;

  void loadNotes() async {
    final result = await repository.getNotes();
    notes.assignAll(result);
  }

  Future<void> addNote(String title, String description) async {
    await repository.addNote(title, description);
    loadNotes();
  }
}
