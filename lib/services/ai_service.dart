import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'photo_processing_service.dart';

class AIService extends PhotoProcessingService {
  static const String _openRouterUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  @override
  /// Обработка изображения с помощью ИИ модели
  /// Принимает путь к изображению и промт для обработки
  Future<String?> processImageWithAI(String imagePath, String prompt) async {
    try {
      // Проверяем существование файла
      final file = File(imagePath);
      if (!await file.exists()) {
        print('Файл изображения не найден: $imagePath');
        return null;
      }

      // Преобразуем изображение в base64
      final base64Image = await imageToBase64(imagePath);
      if (base64Image == null) {
        print('Не удалось преобразовать изображение в base64');
        return null;
      }

      // Вызываем API ИИ модели
      return await _callAIAPI(base64Image, prompt);
    } catch (e) {
      print('Ошибка при обработке изображения с помощью ИИ: $e');
      return null;
    }
  }

  /// Вызов API ИИ модели
  Future<String?> _callAIAPI(String base64Image, String prompt) async {
    try {
      // Структура запроса к API (пример для OpenRouter)
      final request = {
        'model': "google/gemini-2.0-flash-001", // или другая модель
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    'убери весь задний фон, сделай так как-будто человек сидит на фоне зелёного хромакея',
              },
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
              },
            ],
          },
        ],
        'max_tokens': 300,
      };

      // Здесь нужно указать ваш API ключ
      // Для примера используем заглушку
      final apiKey =
          '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'; // Замените на реальный API ключ

      final response = await http.post(
        Uri.parse(_openRouterUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('200 ок');
        print('data $data');
        return data['choices'][0]['message']['content'];
      } else {
        print('Ошибка API: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Ошибка вызова AI API: $e');
      return null;
    }
  }

  @override
  /// Преобразование файла изображения в base64
  Future<String?> imageToBase64(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Ошибка преобразования изображения в base64: $e');
      return null;
    }
  }
}
