import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../controllers/note_controller.dart';
import 'add_note_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectar el controlador
    final controller = Get.put(
      NoteController(repository: NoteRepositoryImpl()),
    );

    // Cargar notas al inicio
    controller.loadNotes();

    return Scaffold(
      appBar: AppBar(title: const Text('Diario')),
      body: Obx(() {
        // Mientras carga, mostramos un indicador
        if (controller.notes.isEmpty) {
          return const Center(child: Text('No hay notas'));
        }

        // Lista de notas
        return ListView.builder(
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            final note = controller.notes[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(note.description),
                    const SizedBox(height: 4),
                    Text(
                      'Creado el: ${DateFormat('yyyy-MM-dd – HH:mm').format(note.createdAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotePage()),
          ).then((_) => controller.loadNotes()); // recargar después de agregar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
