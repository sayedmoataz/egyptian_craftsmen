import 'package:dio/dio.dart';

import '../../api/config/network_config.dart';
import '../../api/contracts/api_consumer.dart';
import '../../api/factory/network_service_factory.dart';
import '../../api/interceptors/auth_interceptor.dart';
import '../../api/request_handler/request_queue.dart';
import '../../config/app_config.dart';
import '../../di/injection_container.dart';
import '../../errors/error_handler.dart';
import '../../network/network_info.dart';
import '../../routes/routes.dart';
import '../../services/services.dart';

Future<void> initNetworking() async {
  PerformanceService.instance.startOperation('API Networking Init');

  final apiConsumer = NetworkServiceFactory.create(
    config: NetworkConfig(
      baseUrl: AppConfig.baseUrl,
      enableLogging: AppConfig.enableLogging,
    ),
    auth: AuthConfig(
      getAccessToken: () => sl<AppPrefsManager>().getToken(),
      getRefreshToken: () => sl<AppPrefsManager>().getRefreshToken(),
      onRefreshToken: _handleTokenRefresh,
      onTokensRefreshed: _saveTokens,
      onRefreshFailed: _handleAuthFailure,
    ),
    dynamicHeaders: DynamicHeadersConfig(
      getHeaders: () async {
        final headers = <String, String>{};

        // Add language header
        final language = await sl<AppPrefsManager>().getLanguage();
        headers['Accept-Language'] = language;

        // Add country ID header (if needed)
        final countryId = await sl<AppPrefsManager>().getSelectedCountryId();
        if (countryId != null) {
          headers['X-Country-Id'] = countryId.toString();
        }

        return headers;
      },
    ),
    errorLogging: ErrorLoggingConfig(
      logError: (error, stackTrace, context) {
        ErrorHandler.errorHandlerConfig?.onLogError?.call(
          error,
          stackTrace,
          context,
        );
      },
    ),
    cache: const CacheConfig(),
  );

  sl.registerLazySingleton<ApiConsumer>(() => apiConsumer);

  // Register RequestQueue with NetworkInfo for auto-processing on reconnect
  final requestQueue = RequestQueue(sl<NetworkInfo>());
  requestQueue.consumer = apiConsumer;
  sl.registerLazySingleton<RequestQueue>(() => requestQueue);

  PerformanceService.instance.endOperation('API Networking Init');
}

// Add these helper methods in the same file or in your auth repository

Future<AuthTokens> _handleTokenRefresh(String refreshToken) async {
  try {
    // Call your refresh endpoint
    final dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
    final response = await dio.post(
      '/auth/refresh', // Your refresh endpoint
      data: {'refresh_token': refreshToken},
    );

    // Parse the response based on your API format
    return AuthTokens(
      accessToken: response.data['access_token'] as String,
      refreshToken: response.data['refresh_token'] as String,
    );
  } catch (e) {
    throw Exception('Token refresh failed: $e');
  }
}

Future<void> _saveTokens(AuthTokens tokens) async {
  await sl<AppPrefsManager>().setToken(tokens.accessToken);
  await sl<AppPrefsManager>().setRefreshToken(tokens.refreshToken);
}

Future<void> _handleAuthFailure() async {
  // Clear user data
  await sl<AppPrefsManager>().clearUserData();

  sl<NavigationService>().navigateTo(Routes.login);
}
