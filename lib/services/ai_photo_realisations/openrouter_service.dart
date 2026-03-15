import 'dart:convert';
import 'dart:typed_data';
import 'package:heroff/secret/secrets.dart';
import 'package:heroff/services/ai_photo_service.dart';
import 'package:http/http.dart' as http;
import 'openrouter_response_dto.dart';

/// Реализация сервиса OpenRouter для генерации изображений
class OpenRouterService implements AIPhotoService {
  static const String _apiKey = Secrets.OPENROUTER_API_KEY;
  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  // Модель для i2i с поддержкой инструкций
  static const String _model = 'google/gemini-3.1-flash-image-preview-20260226';

  @override
  String get serviceName => 'OpenRouter';

  @override
  Future<String?> processImageWithAI(String base64image, String prompt) async {
    // Конвертируем base64 в Uint8List
    final imageBytes = base64Decode(base64image);

    // Вызываем метод generateImageToImage
    final result = await generateImageToImage(
      imageBytes: imageBytes,
      prompt: prompt,
    );

    // Конвертируем результат обратно в base64
    return result != null ? base64Encode(result) : null;
  }

  Future<Uint8List?> generateImageToImage({
    required Uint8List imageBytes,
    required String prompt,
    String negativePrompt = 'blurry, bad quality, distorted',
    double guidanceScale = 7.5,
  }) async {
    final base64Image = base64Encode(imageBytes);

    // 📦 Формат запроса для OpenRouter API
    final payload = {
      "model": _model,
      "messages": [
        {
          "role": "user",
          "content": [
            {"type": "text", "text": prompt},
            {
              "type": "image_url",
              "image_url": {"url": "data:image/png;base64,$base64Image"},
            },
          ],
        },
      ],
      "max_tokens": 500,
    };

    final uri = Uri.parse(_baseUrl);

    int retries = 0;
    const int maxRetries = 3;

    while (retries < maxRetries) {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // ✅ Успех — парсим JSON и извлекаем изображение
        final jsonResponse = json.decode(response.body);
        final dto = OpenRouterResponseDto.fromJson(jsonResponse);
        
        if (dto.choices.isNotEmpty &&
            dto.choices[0].message.images.isNotEmpty) {
          final imageUrl = dto.choices[0].message.images[0].imageUrl.url;
          
          // Извлекаем base64 часть из URL изображения
          if (imageUrl.startsWith('data:image')) {
            final base64Data = imageUrl.split(',').last;
            return base64Decode(base64Data);
          }
        }
        // Если не удалось получить изображение из ответа
        return null;
      } else if (response.statusCode == 429) {
        // ⏳ Лимит запросов — ждём и повторяем
        retries++;
        await Future.delayed(Duration(seconds: 5 + retries * 2));
        continue;
      } else if (response.statusCode == 401) {
        throw Exception('Неверный токен OpenRouter');
      } else {
        // 📋 Дебаг-информация
        print('❌ Ответ от сервера OpenRouter: ${response.statusCode}');
        print('📄 Тело: ${response.body}');
        throw Exception(
          'OpenRouter API Error ${response.statusCode}: ${response.body}',
        );
      }
    }
    throw Exception('Превышено количество попыток ($maxRetries)');
  }
}
