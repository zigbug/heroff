/// Константы приложения
class AppConstants {
  /// Название приложения
  static const String appName = 'Dungeons & Dragons';

  /// Версия приложения
  static const String appVersion = '1.0.0';

  /// URL API (пример)
  static const String apiUrl = 'https://api.dungeonsanddragons.com/v1';

  /// Размеры и отступы
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double borderRadius = 8.0;

  /// Время задержки для анимаций
  static const Duration animationDuration = Duration(milliseconds: 300);

  /// Максимальный размер фото в байтах (10MB)
  static const int maxPhotoSize = 10 * 1024 * 1024;
}
