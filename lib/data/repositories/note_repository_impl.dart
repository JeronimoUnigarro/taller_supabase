import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'notes';

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    try {
      print('Fetching all notes from Supabase...');
      final response = await _client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      print('Response from Supabase: $response');
      return (response as List)
          .map((json) => NoteModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      print('Error fetching notes: $e');
      throw Exception('Error al obtener las notas: $e');
    }
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return NoteModel.fromJson(response).toEntity();
    } catch (e) {
      if (e.toString().contains('No rows found')) {
        return null;
      }
      throw Exception('Error al obtener la nota: $e');
    }
  }

  @override
  Future<NoteEntity> createNote(String title, String description) async {
    try {
      final noteData = {
        'title': title,
        'description': description,
      };

      final response = await _client
          .from(_tableName)
          .insert(noteData)
          .select()
          .single();

      return NoteModel.fromJson(response).toEntity();
    } catch (e) {
      print('Error creating note: $e');
      throw Exception('Error al crear la nota: $e');
    }
  }

  @override
  Future<NoteEntity> updateNote(NoteEntity note) async {
    try {
      if (note.id == null) {
        throw Exception('La nota debe tener un ID para ser actualizada');
      }

      final noteModel = NoteModel.fromEntity(note);
      final updateData = noteModel.toJson();
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from(_tableName)
          .update(updateData)
          .eq('id', note.id!)
          .select()
          .single();

      return NoteModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al actualizar la nota: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar la nota: $e');
    }
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NoteModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al buscar notas: $e');
    }
  }
}