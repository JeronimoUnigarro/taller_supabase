import 'package:get/get.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/get_all_notes_usecase.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/search_notes_usecase.dart';

class NoteController extends GetxController {
  final GetAllNotesUseCase getAllNotesUseCase;
  final CreateNoteUseCase createNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final SearchNotesUseCase searchNotesUseCase;

  NoteController({
    required this.getAllNotesUseCase,
    required this.createNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
    required this.searchNotesUseCase,
  });

  // Estado observable
  final RxList<NoteEntity> _notes = <NoteEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  List<NoteEntity> get notes => _notes;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  // Cargar todas las notas
  Future<void> loadNotes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final notes = await getAllNotesUseCase();
      _notes.assignAll(notes);
    } catch (e) {
      _errorMessage.value = 'Error al cargar las notas: $e';
      Get.snackbar(
        'Error',
        'No se pudieron cargar las notas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Crear una nueva nota
  Future<bool> createNote(String title, String description) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final newNote = await createNoteUseCase(title, description);
      _notes.insert(0, newNote);

      Get.snackbar(
        'Éxito',
        'Nota creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      _errorMessage.value = 'Error al crear la nota: $e';
      Get.snackbar(
        'Error',
        'No se pudo crear la nota: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Actualizar una nota existente
  Future<bool> updateNote(NoteEntity note) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final updatedNote = await updateNoteUseCase(note);
      final index = _notes.indexWhere((n) => n.id == updatedNote.id);
      
      if (index != -1) {
        _notes[index] = updatedNote;
      }

      Get.snackbar(
        'Éxito',
        'Nota actualizada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      _errorMessage.value = 'Error al actualizar la nota: $e';
      Get.snackbar(
        'Error',
        'No se pudo actualizar la nota: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Eliminar una nota
  Future<bool> deleteNote(String id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await deleteNoteUseCase(id);
      _notes.removeWhere((note) => note.id == id);

      Get.snackbar(
        'Éxito',
        'Nota eliminada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      _errorMessage.value = 'Error al eliminar la nota: $e';
      Get.snackbar(
        'Error',
        'No se pudo eliminar la nota: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Buscar notas
  Future<void> searchNotes(String query) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _searchQuery.value = query;

      final notes = await searchNotesUseCase(query);
      _notes.assignAll(notes);
    } catch (e) {
      _errorMessage.value = 'Error al buscar notas: $e';
      Get.snackbar(
        'Error',
        'No se pudieron buscar las notas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Limpiar búsqueda
  void clearSearch() {
    _searchQuery.value = '';
    loadNotes();
  }

  // Refrescar notas
  Future<void> refreshNotes() async {
    await loadNotes();
  }
}