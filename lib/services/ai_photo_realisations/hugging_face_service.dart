import 'dart:convert';
import 'dart:typed_data';
import 'package:heroff/secret/secrets.dart';
import 'package:heroff/services/ai_photo_service.dart';
import 'package:dio/dio.dart';
import 'package:heroff/utils/talker_config.dart';

/// Реализация сервиса Hugging Face
class HuggingFaceService implements AIPhotoService {
  static const String _apiKey = Secrets.HUGGING_FACE_API_KEY;

  // ✅ НОВЫЙ базовый URL (2026)
  static const String _baseUrl =
      'https://router.huggingface.co/hf-inference/models';

  // Модель для i2i с поддержкой инструкций
  static const String _modelId = 'FireRedTeam/FireRed-Image-Edit-1.1';

  // Используем Dio с логгером
  final Dio _dio = TalkerConfig.createDioWithLogger();

  @override
  String get serviceName => 'HuggingFace';

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
    return base64Encode(result);
  }

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

    int retries = 0;
    const int maxRetries = 3;

    while (retries < maxRetries) {
      try {
        TalkerConfig.log('Отправка запроса к Hugging Face API');
        
        final response = await _dio.post(
          '$_baseUrl/$_modelId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
              // ✅ Ждать загрузку модели (до 30 сек на бесплатном тарифе)
              'X-Wait-For-Model': 'true',
            },
          ),
          data: payload,
        );

        if (response.statusCode == 200) {
          // ✅ Успех — возвращаем байты изображения
          TalkerConfig.log('Успешно получено изображение от Hugging Face API');
          return response.data;
        } else if (response.statusCode == 503) {
          // ⏳ Модель "спит" — ждём и повторяем
          retries++;
          await Future.delayed(Duration(seconds: 5 + retries * 2));
          continue;
        } else if (response.statusCode == 410) {
          // ❌ Старый URL — не должно произойти с новым _baseUrl
          TalkerConfig.logErrorCustom('Используйте новый endpoint: $_baseUrl');
          throw Exception('Используйте новый endpoint: $_baseUrl');
        } else if (response.statusCode == 401) {
          TalkerConfig.logErrorCustom('Неверный токен или нет прав на Inference Providers');
          throw Exception('Неверный токен или нет прав на Inference Providers');
        } else if (response.statusCode == 400) {
          // 🔄 Попробуем отправить как binary (некоторые модели требуют)
          TalkerConfig.logWarning('Получен статус 400, пробуем отправить как binary');
          return await _sendAsBinary(
            imageBytes,
            prompt,
            negativePrompt,
            guidanceScale,
          );
        } else {
          // 📋 Дебаг-информация
          TalkerConfig.logErrorCustom('HF API Error ${response.statusCode}: ${response.data}');
          throw Exception(
            'HF API Error ${response.statusCode}: ${response.data}',
          );
        }
      } on DioException catch (e, stackTrace) {
        TalkerConfig.logError(e, stackTrace: stackTrace);
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          retries++;
          if (retries >= maxRetries) {
            rethrow;
          }
          await Future.delayed(Duration(seconds: 5 + retries * 2));
          continue;
        } else {
          rethrow;
        }
      } catch (e, stackTrace) {
        TalkerConfig.logError(e, stackTrace: stackTrace);
        rethrow;
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
    try {
      TalkerConfig.log('Отправка запроса к Hugging Face API в бинарном формате');
      
      final response = await _dio.post(
        '$_baseUrl/$_modelId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/octet-stream',
            'X-Wait-For-Model': 'true',
            // ⚠️ Параметры в заголовках работают не для всех моделей
            'X-Prompt': prompt,
            'X-Guidance-Scale': guidanceScale.toString(),
          },
        ),
        data: imageBytes,
      );

      if (response.statusCode == 200) {
        TalkerConfig.log('Успешно получено изображение от Hugging Face API (binary)');
        return response.data;
      }
      
      TalkerConfig.logErrorCustom('Binary request failed: ${response.statusCode}\n${response.data}');
      throw Exception(
        'Binary request failed: ${response.statusCode}\n${response.data}',
      );
    } on DioException catch (e, stackTrace) {
      TalkerConfig.logError(e, stackTrace: stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      TalkerConfig.logError(e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
