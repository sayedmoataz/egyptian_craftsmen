import 'package:dio/dio.dart';

import '../config/network_config.dart';
import '../contracts/api_consumer.dart';
import '../implementation/dio_consumer.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/cache_interceptor.dart';
import '../interceptors/cancellation_interceptor.dart';
import '../interceptors/dynamic_header_interceptor.dart';
import '../interceptors/error_logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

/// Factory for creating configured ApiConsumer instances.
/// 
/// Provides a fluent builder pattern for maximum flexibility while
/// maintaining sensible defaults.
/// 
/// Example usage:
/// ```dart
/// final apiConsumer = NetworkServiceFactory.create(
///   config: NetworkConfig(baseUrl: 'https://api.example.com'),
///   auth: AuthConfig(
///     getAccessToken: () => prefs.getAccessToken(),
///     getRefreshToken: () => prefs.getRefreshToken(),
///     onRefreshToken: (refreshToken) async {
///       final response = await dio.post('/refresh', data: {'token': refreshToken});
///       return AuthTokens.fromJson(response.data);
///     },
///     onTokensRefreshed: (tokens) => prefs.saveTokens(tokens),
///     onRefreshFailed: () => navigateToLogin(),
///   ),
///   enableLogging: true,
///   enableRetry: true,
///   enableCache: true,
/// );
/// ```
class NetworkServiceFactory {
  /// Create a fully configured ApiConsumer instance
  static ApiConsumer create({
    required NetworkConfig config,
    AuthConfig? auth,
    DynamicHeadersConfig? dynamicHeaders,
    ErrorLoggingConfig? errorLogging,
    CacheConfig? cache,
  }) {
    final interceptors = <Interceptor>[];

    // Create cancellation interceptor (needed by DioConsumer)
    final cancellationInterceptor = CancellationInterceptor();

    // Add auth interceptor if configured
    if (auth != null) {
      interceptors.add(
        AuthInterceptor(
          getAccessToken: auth.getAccessToken,
          getRefreshToken: auth.getRefreshToken,
          onRefreshToken: auth.onRefreshToken,
          onTokensRefreshed: auth.onTokensRefreshed,
          onRefreshFailed: auth.onRefreshFailed,
          headerKey: auth.headerKey,
        ),
      );
    }

    // Add dynamic headers interceptor
    if (dynamicHeaders != null) {
      interceptors.add(
        DynamicHeadersInterceptor(
          getHeaders: dynamicHeaders.getHeaders,
        ),
      );
    }

    // Add retry interceptor
    if (config.enableRetry) {
      interceptors.add(
        RetryInterceptor(
          maxRetries: config.maxRetries,
          initialDelay: config.retryDelay,
        ),
      );
    }

    // Add cache interceptor
    if (cache != null) {
      interceptors.add(
        CacheInterceptor(
          defaultCacheDuration: cache.defaultDuration,
          maxCacheSize: cache.maxSize,
        ),
      );
    }

    // Add error logging interceptor
    if (errorLogging != null) {
      interceptors.add(
        ErrorLoggingInterceptor(
          logError: errorLogging.logError,
        ),
      );
    }

    // Create config with all interceptors
    final finalConfig = config.copyWith(
      interceptors: [...interceptors, ...config.interceptors],
    );

    return DioConsumer(
      finalConfig,
      cancellationInterceptor: cancellationInterceptor,
    );
  }

  /// Create a basic ApiConsumer with minimal configuration
  static ApiConsumer createBasic({
    required String baseUrl,
    bool enableLogging = false,
  }) {
    return create(
      config: NetworkConfig(
        baseUrl: baseUrl,
        enableLogging: enableLogging,
        enableRetry: false,
      ),
    );
  }

  /// Create an ApiConsumer with authentication support
  static ApiConsumer createWithAuth({
    required String baseUrl,
    required Future<String?> Function() getAccessToken,
    Future<String?> Function()? getRefreshToken,
    Future<AuthTokens> Function(String refreshToken)? onRefreshToken,
    Future<void> Function(AuthTokens tokens)? onTokensRefreshed,
    Future<void> Function()? onRefreshFailed,
    bool enableLogging = false,
  }) {
    return create(
      config: NetworkConfig(
        baseUrl: baseUrl,
        enableLogging: enableLogging,
      ),
      auth: AuthConfig(
        getAccessToken: getAccessToken,
        getRefreshToken: getRefreshToken,
        onRefreshToken: onRefreshToken,
        onTokensRefreshed: onTokensRefreshed,
        onRefreshFailed: onRefreshFailed,
      ),
    );
  }
}

/// Configuration for authentication interceptor
class AuthConfig {
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function()? getRefreshToken;
  final Future<AuthTokens> Function(String refreshToken)? onRefreshToken;
  final Future<void> Function(AuthTokens tokens)? onTokensRefreshed;
  final Future<void> Function()? onRefreshFailed;
  final String headerKey;

  const AuthConfig({
    required this.getAccessToken,
    this.getRefreshToken,
    this.onRefreshToken,
    this.onTokensRefreshed,
    this.onRefreshFailed,
    this.headerKey = 'Authorization',
  });
}

/// Configuration for dynamic headers interceptor
class DynamicHeadersConfig {
  final Future<Map<String, String>> Function() getHeaders;

  const DynamicHeadersConfig({
    required this.getHeaders,
  });
}

/// Configuration for error logging interceptor
class ErrorLoggingConfig {
  final void Function(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic> context,
  ) logError;

  const ErrorLoggingConfig({
    required this.logError,
  });
}

/// Configuration for cache interceptor
class CacheConfig {
  final Duration defaultDuration;
  final int maxSize;

  const CacheConfig({
    this.defaultDuration = const Duration(minutes: 5),
    this.maxSize = 100,
  });
}