import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Сервис для работы с камерой устройства
class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Получение фото с камеры
  Future<XFile?> takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // Качество изображения
      );
      return photo;
    } catch (e) {
      // Логирование ошибки
      print('Ошибка при получении фото: $e');
      return null;
    }
  }

  /// Выбор фото из галереи
  Future<XFile?> selectPictureFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      return photo;
    } catch (e) {
      // Логирование ошибки
      print('Ошибка при выборе фото из галереи: $e');
      return null;
    }
  }

  /// Сохранение фото в файл
  Future<File?> savePicture(XFile photo, String filePath) async {
    try {
      final File file = File(filePath);
      await file.writeAsBytes(await photo.readAsBytes());
      return file;
    } catch (e) {
      // Логирование ошибки
      print('Ошибка при сохранении фото: $e');
      return null;
    }
  }
}
