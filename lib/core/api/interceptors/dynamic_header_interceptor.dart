import 'package:dio/dio.dart';

/// Interceptor that adds dynamic headers to each request.
///
/// Useful for headers that change frequently or are computed at runtime:
/// - Language/locale settings
/// - User preferences
/// - Device information
/// - Session-specific data
///
/// Example usage:
/// ```dart
/// DynamicHeadersInterceptor(
///   getHeaders: () async {
///     return {
///       'Accept-Language': await localeService.getCurrentLocale(),
///       'X-Device-Id': await deviceService.getDeviceId(),
///       'X-App-Version': packageInfo.version,
///     };
///   },
/// )
/// ```
class DynamicHeadersInterceptor extends Interceptor {
  final Future<Map<String, String>> Function() getHeaders;

  DynamicHeadersInterceptor({required this.getHeaders});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final headers = await getHeaders();
      options.headers.addAll(headers);
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to get dynamic headers: $e',
        ),
      );
    }
  }
}
