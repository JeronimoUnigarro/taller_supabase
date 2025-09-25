import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/usecases/create_note_usecase.dart';
import 'domain/usecases/delete_note_usecase.dart';
import 'domain/usecases/get_all_notes_usecase.dart';
import 'domain/usecases/search_notes_usecase.dart';
import 'domain/usecases/update_note_usecase.dart';
import 'presentation/controllers/note_controller.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Cargar variables de entorno
    await dotenv.load(fileName: ".env");
    
    // Inicializar Supabase
    await Supabase.initialize(
      url: Config.supabaseUrl,
      anonKey: Config.supabaseAnonKey,
    );
    
    // Configurar dependencias
    _setupDependencies();
    
    runApp(const MyApp());
  } catch (e) {
    // En caso de error durante la inicialización
    runApp(ErrorApp(error: e.toString()));
  }
}

void _setupDependencies() {
  // Repositorio
  Get.lazyPut<NoteRepository>(() => NoteRepositoryImpl());
  
  // Casos de uso
  Get.lazyPut(() => GetAllNotesUseCase(Get.find<NoteRepository>()));
  Get.lazyPut(() => CreateNoteUseCase(Get.find<NoteRepository>()));
  Get.lazyPut(() => UpdateNoteUseCase(Get.find<NoteRepository>()));
  Get.lazyPut(() => DeleteNoteUseCase(Get.find<NoteRepository>()));
  Get.lazyPut(() => SearchNotesUseCase(Get.find<NoteRepository>()));
  
  // Controlador
  Get.lazyPut(() => NoteController(
    getAllNotesUseCase: Get.find<GetAllNotesUseCase>(),
    createNoteUseCase: Get.find<CreateNoteUseCase>(),
    updateNoteUseCase: Get.find<UpdateNoteUseCase>(),
    deleteNoteUseCase: Get.find<DeleteNoteUseCase>(),
    searchNotesUseCase: Get.find<SearchNotesUseCase>(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mi Diario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
      // Configuración de GetX
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error de Inicialización',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Error de Inicialización',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'No se pudo inicializar la aplicación. Verifica tu configuración de Supabase y el archivo .env.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    'Error: $error',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Reiniciar la aplicación
                    main();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}