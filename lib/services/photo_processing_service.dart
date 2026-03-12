/// Абстрактный класс для сервиса обработки фото
abstract class PhotoProcessingService {
  /// Обработка изображения с помощью ИИ модели
  /// Принимает путь к изображению и промт для обработки
  Future<String?> processImageWithAI(String imagePath, String prompt) async {
    throw UnimplementedError('Метод должен быть реализован в подклассе');
  }

  /// Преобразование файла изображения в base64
  Future<String?> imageToBase64(String imagePath) async {
    throw UnimplementedError('Метод должен быть реализован в подклассе');
  }
}
