import 'dart:convert';
import 'dart:typed_data';
import 'package:heroff/secret/secrets.dart';
import 'package:http/http.dart' as http;

class HuggingFaceService {
  static const String _apiKey = Secrets.HUGGING_FACE_API_KEY;

  // ✅ НОВЫЙ базовый URL (2026)
  static const String _baseUrl =
      'https://router.huggingface.co/hf-inference/models';

  // Модель для i2i с поддержкой инструкций
  static const String _modelId = 'FireRedTeam/FireRed-Image-Edit-1.1';

  Future<Uint8List> generateImageToImage({
    required Uint8List imageBytes,
    required String prompt,
    String negativePrompt = 'blurry, bad quality, distorted',
    double guidanceScale = 7.5,
  }) async {
    final base64Image = base64Encode(imageBytes);

    // 📦 Формат запроса для нового router API
    final payload = {
      "inputs": base64Image, // ✅ Теперь image передаётся как строка в inputs
      "parameters": {
        "prompt": prompt,
        "negative_prompt": negativePrompt,
        "guidance_scale": guidanceScale,
      },
    };

    final uri = Uri.parse('$_baseUrl/$_modelId');

    int retries = 0;
    const int maxRetries = 3;

    while (retries < maxRetries) {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          // ✅ Ждать загрузку модели (до 30 сек на бесплатном тарифе)
          'X-Wait-For-Model': 'true',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // ✅ Успех — возвращаем байты изображения
        return response.bodyBytes;
      } else if (response.statusCode == 503) {
        // ⏳ Модель "спит" — ждём и повторяем
        retries++;
        await Future.delayed(Duration(seconds: 5 + retries * 2));
        continue;
      } else if (response.statusCode == 410) {
        // ❌ Старый URL — не должно произойти с новым _baseUrl
        throw Exception('Используйте новый endpoint: $_baseUrl');
      } else if (response.statusCode == 401) {
        throw Exception('Неверный токен или нет прав на Inference Providers');
      } else if (response.statusCode == 400) {
        // 🔄 Попробуем отправить как binary (некоторые модели требуют)
        return await _sendAsBinary(
          imageBytes,
          prompt,
          negativePrompt,
          guidanceScale,
        );
      } else {
        // 📋 Дебаг-информация
        print('❌ Ответ от сервера: ${response.statusCode}');
        print('📄 Тело: ${response.body}');
        throw Exception(
          'HF API Error ${response.statusCode}: ${response.body}',
        );
      }
    }
    throw Exception('Превышено количество попыток ($maxRetries)');
  }

  /// 🔄 Фолбэк: отправка изображения как raw bytes
  Future<Uint8List> _sendAsBinary(
    Uint8List imageBytes,
    String prompt,
    String negativePrompt,
    double guidanceScale,
  ) async {
    final uri = Uri.parse('$_baseUrl/$_modelId');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/octet-stream',
        'X-Wait-For-Model': 'true',
        // ⚠️ Параметры в заголовках работают не для всех моделей
        'X-Prompt': prompt,
        'X-Guidance-Scale': guidanceScale.toString(),
      },
      body: imageBytes,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception(
      'Binary request failed: ${response.statusCode}\n${response.body}',
    );
  }
}
