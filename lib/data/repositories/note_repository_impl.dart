import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<List<NoteEntity>> getNotes() async {
    // Ejecutar la consulta
    final response = await client
        .from('notes')
        .select()
        .order('created_at', ascending: false)
        .execute();

    // En la versión actual, error se accede así:
    if (response.error != null) {
      print('Supabase error: ${response.error!.message}');
      return [];
    }

    // data puede ser null si la tabla está vacía
    final data = response.data as List<dynamic>?;

    if (data == null) return [];

    return data.map((e) => NoteModel.fromMap(e)).toList();
  }

  @override
  Future<void> addNote(String title, String description) async {
    final response = await client.from('notes').insert({
      'title': title,
      'description': description,
    }).execute();

    if (response.error != null) {
      print('Error al insertar nota: ${response.error!.message}');
    }
  }
}
