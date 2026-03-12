import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Абстракция сервиса хранения изображений
abstract class ImageStorageService {
  /// Сохраняет изображение и возвращает путь к нему
  Future<String> saveImage(Uint8List imageBytes, {String? key});

  /// Загружает изображение по пути
  Future<Uint8List?> loadImage(String path);

  /// Удаляет изображение по пути
  Future<bool> deleteImage(String path);

  /// Получает все пути сохраненных изображений
  Future<List<String>> getAllImagePaths();

  /// Очищает все сохраненные изображения
  Future<void> clearAllImages();

  /// Проверяет, существует ли изображение по пути
  Future<bool> imageExists(String path);
}

/// Реализация сервиса хранения изображений
class ImageStorageServiceImpl implements ImageStorageService {
  static const String _imageKeysKey = 'image_paths';
  static const String _appDirectoryKey = 'app_images_directory';

  @override
  Future<String> saveImage(Uint8List imageBytes, {String? key}) async {
    final directoryPath = await _getAppDirectory();
    final directory = Directory(directoryPath);

    // Создаем директорию, если она не существует
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Генерируем уникальное имя файла
    final fileName =
        key ?? 'image_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '$directoryPath/$fileName';

    // Сохраняем изображение в файл
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    // Сохраняем путь в shared preferences
    final prefs = await SharedPreferences.getInstance();
    final currentPaths = prefs.getStringList(_imageKeysKey) ?? [];
    if (!currentPaths.contains(filePath)) {
      currentPaths.add(filePath);
      await prefs.setStringList(_imageKeysKey, currentPaths);
    }

    return filePath;
  }

  @override
  Future<Uint8List?> loadImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      debugPrint('Ошибка загрузки изображения: $e');
      return null;
    }
  }

  @override
  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      final exists = await file.exists();
      if (exists) {
        await file.delete();
      }

      // Удаляем путь из списка сохраненных изображений
      final prefs = await SharedPreferences.getInstance();
      final currentPaths = prefs.getStringList(_imageKeysKey) ?? [];
      final updatedPaths = currentPaths..remove(path);
      await prefs.setStringList(_imageKeysKey, updatedPaths);

      return exists;
    } catch (e) {
      debugPrint('Ошибка удаления изображения: $e');
      return false;
    }
  }

  @override
  Future<List<String>> getAllImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_imageKeysKey) ?? [];
  }

  @override
  Future<void> clearAllImages() async {
    // Получаем все пути изображений
    final paths = await getAllImagePaths();

    // Удаляем все файлы
    for (final path in paths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Ошибка удаления файла: $e');
      }
    }

    // Очищаем список путей
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_imageKeysKey, []);
  }

  @override
  Future<bool> imageExists(String path) async {
    final file = File(path);
    return await file.exists();
  }

  /// Получает путь к директории приложения для хранения изображений
  Future<String> _getAppDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_appDirectoryKey);

    if (savedPath != null && savedPath.isNotEmpty) {
      return savedPath;
    }

    // Если путь не сохранен, получаем новый путь
    final directory = await getApplicationDocumentsDirectory();
    final appDirectory = '${directory.path}/images';

    // Сохраняем путь в shared preferences
    await prefs.setString(_appDirectoryKey, appDirectory);

    return appDirectory;
  }
}
