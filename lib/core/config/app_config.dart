/// Application Configuration
class AppConfig {
  AppConfig._();

  // Environment
  static const bool isProduction = true;
  static const bool enableLogging = true;
  static const String appVersion = '1.0.0';
  static const String apiVersion = 'v1';

  // API Configuration
  static String get baseUrl {
    return isProduction
        ? 'https://aelanji.cloud/api/$apiVersion'
        : 'https://aelanji.cloud/api/$apiVersion';
  }

  static String get storageUrl {
    return isProduction
        ? 'https://aelanji.cloud/storage'
        : 'https://aelanji.cloud/storage';
  }
}
