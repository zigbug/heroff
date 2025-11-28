import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../services/camera_service.dart';

class CharacterCreationPage extends StatefulWidget {
  const CharacterCreationPage({super.key});

  @override
  State<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends State<CharacterCreationPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isPhotoTaken = false;
  String? _photoPath;

  Future<void> _takePhoto() async {
    try {
      // Используем CameraService для получения фото с камеры
      final CameraService cameraService = CameraService();
      final XFile? photo = await cameraService.takePicture();

      if (photo != null) {
        setState(() {
          _isPhotoTaken = true;
          _photoPath = photo.path;
        });
      } else {
        print('Фото не было выбрано');
      }
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при получении фото: $e');
      // В случае ошибки показываем сообщение пользователю
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Не удалось получить фото: $e')));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      // Используем CameraService для выбора фото из галереи
      final CameraService cameraService = CameraService();
      final XFile? photo = await cameraService.pickFromGallery();

      if (photo != null) {
        setState(() {
          _isPhotoTaken = true;
          _photoPath = photo.path;
        });
      } else {
        print('Фото не было выбрано');
      }
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при выборе фото из галереи: $e');
      // В случае ошибки показываем сообщение пользователю
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось выбрать фото из галереи: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Создание персонажа',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Виджет прогресса (3 шага)
              const Text(
                'Шаги создания персонажа:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Center(
                      child: Text('1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 4,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Center(
                      child: Text('2', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 4,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Center(
                      child: Text('3', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Текстовое поле ввода имени
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
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Адаптивный контейнер под фото
              const Text(
                'Фотография персонажа:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Контейнер с квадратным соотношением сторон 1:1
              Container(
                width: double.infinity,
                height: 250, // Фиксированная высота для квадратного отображения
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Stack(
                  children: [
                    // Основное изображение с квадратным форматом
                    Center(
                      child:
                          _isPhotoTaken
                              ? _photoPath != null
                                  ? AspectRatio(
                                    aspectRatio: 1.0, // 1:1 соотношение
                                    child: Image.file(
                                      File(_photoPath!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Text('Фото не доступно')
                              : const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              ),
                    ),
                    // Рамка на видоискатель (полупрозрачная)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200, // Ширина рамки
                        height: 200, // Высота рамки
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Кнопки сделать фото и выбрать из галереи
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _takePhoto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Сделать фото'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _pickFromGallery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Из галереи'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
