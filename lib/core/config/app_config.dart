import '../../flavors.dart';

/// Application Configuration
class AppConfig {
  AppConfig._();

  // Environment
  static bool isProduction = F.isProd;
  static bool enableLogging = F.isDev;

  // API Configuration
  static String get baseUrl {
    return isProduction
        ? 'http://127.0.0.1:8000/api'
        : 'http://127.0.0.1:8000/api';
  }

  static String get storageUrl {
    return isProduction
        ? 'http://127.0.0.1:8000/api'
        : 'http://127.0.0.1:8000/api';
  }
}
