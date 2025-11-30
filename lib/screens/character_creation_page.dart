import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../theme.dart';
import '../services/camera_service.dart';
import '../blocs/character_creation/character_creation_bloc.dart';
import '../blocs/character_creation/character_creation_state.dart';
import '../blocs/character_creation/character_creation_event.dart';

class CharacterCreationPage extends StatelessWidget {
  const CharacterCreationPage({super.key});

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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
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
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child:
                    BlocBuilder<CharacterCreationBloc, CharacterCreationState>(
                      builder: (context, state) {
                        if (state is CharacterCreationLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CharacterCreationSuccess) {
                          return Stack(
                            children: [
                              // Основное изображение с квадратным форматом
                              Center(
                                child: AspectRatio(
                                  aspectRatio: 1.0, // 1:1 соотношение
                                  child: Image.file(
                                    File(state.photoPath),
                                    fit: BoxFit.cover,
                                  ),
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
                          );
                        } else if (state is CharacterCreationFailure) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.error,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // CharacterCreationInitial
                          return Stack(
                            children: [
                              const Center(
                                child: Icon(
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
                          );
                        }
                      },
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
                        onPressed: () {
                          context.read<CharacterCreationBloc>().add(
                            CharacterCreationTakePhoto(),
                          );
                        },
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
                        onPressed: () {
                          context.read<CharacterCreationBloc>().add(
                            CharacterCreationPickFromGallery(),
                          );
                        },
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

              // Кнопка "Далее" - появляется при заполнении имени и фото
              const SizedBox(height: 20),
              BlocBuilder<CharacterCreationBloc, CharacterCreationState>(
                builder: (context, state) {
                  // Временная проверка - в реальном приложении нужно передавать имя из TextField
                  bool isNameFilled =
                      true; // Это будет зависеть от значения в TextField
                  bool isPhotoTaken = state is CharacterCreationSuccess;

                  if (isNameFilled && isPhotoTaken) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Переход на следующий шаг (выбор расы)
                          // В реальном приложении здесь будет переход к следующему экрану
                          Navigator.pushNamed(context, '/race-selection');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Далее'),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
