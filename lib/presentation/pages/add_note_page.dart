import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  await controller.addNote(
                    titleController.text,
                    descriptionController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar Nota'),
            ),
          ],
        ),
      ),
    );
  }
}
