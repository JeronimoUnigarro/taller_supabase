import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<List<NoteEntity>> getNotes() async {
    try {
      final data =
          await client
                  .from('notes')
                  .select()
                  .order('created_at', ascending: false)
              as List<dynamic>?;

      if (data == null) return [];

      return data.map((e) => NoteModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching notes: $e');
      return [];
    }
  }

  @override
  Future<void> addNote(String title, String description) async {
    try {
      await client.from('notes').insert({
        'title': title,
        'description': description,
      });
    } catch (e) {
      print('Error adding note: $e');
    }
  }
}
