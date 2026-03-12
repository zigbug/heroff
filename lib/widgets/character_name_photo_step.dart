import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroff/services/hugging_face_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../blocs/character_creation/character_creation_bloc.dart';
import '../services/ai_service.dart';
import '../services/ai_service.dart';

class CharacterNamePhotoStep extends StatefulWidget {
  const CharacterNamePhotoStep({super.key});

  @override
  State<CharacterNamePhotoStep> createState() => _CharacterNamePhotoStepState();
}

class _CharacterNamePhotoStepState extends State<CharacterNamePhotoStep> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CharacterCreationBloc>();
    _nameController = TextEditingController(
      text: bloc.state.character?.name ?? '',
    );
    _nameController.addListener(() {
      bloc.add(NameChanged(_nameController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Показываем диалог с выбором источника изображения
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите источник изображения'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать фото'),
                onTap: () {
                  Navigator.pop(context, 'camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Загрузить из галереи'),
                onTap: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      XFile? image;

      if (result == 'camera') {
        // Запрашиваем разрешение на использование камеры
        image = await picker.pickImage(source: ImageSource.camera);
      } else if (result == 'gallery') {
        // Запрашиваем разрешение на доступ к галерее
        image = await picker.pickImage(source: ImageSource.gallery);
      }

      if (image != null) {
        // Сохраняем путь к выбранному изображению
        final bloc = context.read<CharacterCreationBloc>();
        // Используем соответствующее событие в зависимости от источника
        if (result == 'camera') {
          bloc.add(PhotoTaken(image.path));
        } else {
          bloc.add(PhotoPicked(image.path));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Сделай/добавь свою фотку:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: BlocBuilder<CharacterCreationBloc, CharacterCreationState>(
                builder: (context, state) {
                  if (state.status == CharacterCreationStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final photoPath = state.character?.photoPath;
                  if (photoPath != null && photoPath.isNotEmpty) {
                    return Stack(
                      children: [
                        Image.file(File(photoPath), fit: BoxFit.cover),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: FloatingActionButton.small(
                            onPressed: () async {
                              // Обработка изображения с помощью ИИ
                              // final aiService = AIService();
                              // final result = await aiService.processImageWithAI(
                              //   photoPath,
                              //   'Проанализируй это изображение персонажа и опиши его характеристики',
                              // );
                              // if (result != null) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text(
                              //         'Результат обработки: $result',
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
                            child: const Icon(Icons.auto_fix_high),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: _pickImage,
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            'Введите имя персонажа:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Имя персонажа',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
