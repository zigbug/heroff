import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger_plus/talker_dio_logger_plus.dart';
import 'package:dio/dio.dart';

class TalkerConfig {
  static final talker = TalkerFlutter.init();
  
  // Метод для настройки Dio с логгером
  static Dio createDioWithLogger() {
    final dio = Dio();
    
    // Добавляем Talker interceptor для логирования сетевых запросов
    dio.interceptors.add(
      AdvancedDioLogger(
        talker: talker,
        settings: AdvancedDioLoggerSettings(
          enabled: true,
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: true,
          printRequestData: true,
          printErrorData: true,
        ),
      ),
    );
    
    return dio;
  }
  
  // Метод для логирования ошибок
  static void logError(dynamic error, {StackTrace? stackTrace}) {
    talker.handle(error, stackTrace);
  }
  
  // Метод для обычного логирования
  static void log(String message) {
    talker.info(message);
  }
  
  // Метод для логирования варнингов
  static void logWarning(String message) {
    talker.warning(message);
  }
  
  // Метод для логирования ошибок
  static void logErrorCustom(String message) {
    talker.error(message);
  }
}