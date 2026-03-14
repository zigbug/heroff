abstract class AIPhotoService {
  Future<String?> processImageWithAI(String base64image, String prompt);

  // Метод для получения названия сервиса
  String get serviceName;
}
