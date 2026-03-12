import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageStorageService {
  static const String _imageKeyPrefix = 'stored_image_';
  static const String _imageKeysKey = 'image_keys';

  /// Сохраняет изображение в shared preferences
  /// Возвращает уникальный ключ для изображения
  static Future<String> saveImage(Uint8List imageBytes, {String? key}) async {
    final prefs = await SharedPreferences.getInstance();

    // Если ключ не указан, генерируем уникальный
    final imageKey =
        key ?? '${_imageKeyPrefix}${DateTime.now().millisecondsSinceEpoch}';

    // Конвертируем байты в base64 строку для сохранения
    final base64Image = base64Encode(imageBytes);

    // Сохраняем изображение
    await prefs.setString(imageKey, base64Image);

    // Добавляем ключ в список сохраненных изображений
    final currentKeys = prefs.getStringList(_imageKeysKey) ?? [];
    if (!currentKeys.contains(imageKey)) {
      currentKeys.add(imageKey);
      await prefs.setStringList(_imageKeysKey, currentKeys);
    }

    return imageKey;
  }

  /// Загружает изображение из shared preferences по ключу
  static Future<Uint8List?> loadImage(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final base64Image = prefs.getString(key);
    if (base64Image == null) {
      return null;
    }

    try {
      return base64Decode(base64Image);
    } catch (e) {
      debugPrint('Ошибка декодирования изображения: $e');
      return null;
    }
  }

  /// Удаляет изображение из shared preferences
  static Future<bool> deleteImage(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final result = prefs.remove(key);

    // Удаляем ключ из списка сохраненных изображений
    final currentKeys = prefs.getStringList(_imageKeysKey) ?? [];
    final updatedKeys = currentKeys..remove(key);
    await prefs.setStringList(_imageKeysKey, updatedKeys);

    return result;
  }

  /// Получает все ключи сохраненных изображений
  static Future<List<String>> getAllImageKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_imageKeysKey) ?? [];
  }

  /// Очищает все сохраненные изображения
  static Future<void> clearAllImages() async {
    final prefs = await SharedPreferences.getInstance();

    // Получаем все ключи изображений
    final keys = await getAllImageKeys();

    // Удаляем все изображения
    for (final key in keys) {
      prefs.remove(key);
    }

    // Очищаем список ключей
    await prefs.setStringList(_imageKeysKey, []);
  }

  /// Проверяет, существует ли изображение с указанным ключом
  static Future<bool> imageExists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
