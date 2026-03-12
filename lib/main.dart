import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/character_creation_page.dart';
import 'theme.dart';
import 'blocs/character_creation/character_creation_bloc.dart';
import 'services/camera_service.dart';

void main() {
  // Тестирование сервиса хранения изображений
  WidgetsFlutterBinding.ensureInitialized();

  // Пример использования сервиса (для демонстрации)
  // В реальном приложении этот код будет использоваться в нужных местах

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CharacterCreationBloc(cameraService: CameraService()),
      child: MaterialApp(
        title: 'Dungeons & Dragons',
        theme: DungeonTheme.woodParchmentTheme,
        home: const CharacterCreationPage(),
      ),
    );
  }
}
