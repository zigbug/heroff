import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroff/screens/bloc/character_creation_bloc.dart';
import 'package:heroff/utils/talker_config.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'screens/character_creation_page.dart';
import 'services/ai_photo_realisations/openrouter_service.dart';
import 'services/camera_service.dart';
import 'services/image_storage_service.dart';
import 'theme.dart';

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
          (context) => CharacterCreationBloc(
            cameraService: CameraService(),
            aiPhotoService: OpenRouterService(),
            // HuggingFaceService(),
            imageStorageService: ImageStorageServiceImpl(),
          ),
      child: TalkerWrapper(
        talker: TalkerConfig.talker,
        child: MaterialApp(
          title: 'Dungeons & Dragons',
          theme: DungeonTheme.woodParchmentTheme,
          home: const CharacterCreationPage(),
          navigatorObservers: [
            TalkerRouteObserver(TalkerConfig.talker),
          ],
        ),
      ),
    );
  }
}
