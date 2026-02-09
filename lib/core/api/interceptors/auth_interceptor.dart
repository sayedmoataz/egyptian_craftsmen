import 'dart:async';

import 'package:dio/dio.dart';

import '../config/constants.dart';

/// Consolidated authentication interceptor that handles:
/// 1. Token injection in requests
/// 2. Token refresh on 401 responses
/// 3. Request queueing during refresh to prevent race conditions
///
/// This interceptor follows the Single Responsibility Principle by focusing
/// solely on authentication concerns without coupling to app-specific logic.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function()? getRefreshToken;
  final Future<AuthTokens> Function(String refreshToken)? onRefreshToken;
  final Future<void> Function(AuthTokens tokens)? onTokensRefreshed;
  final Future<void> Function()? onRefreshFailed;
  final String headerKey;

  bool _isRefreshing = false;
  final List<_RequestQueueItem> _requestQueue = [];

  AuthInterceptor({
    required this.getAccessToken,
    this.getRefreshToken,
    this.onRefreshToken,
    this.onTokensRefreshed,
    this.onRefreshFailed,
    this.headerKey = 'Authorization',
  }) {
    // Validate refresh token configuration
    if (onRefreshToken != null) {
      assert(
        getRefreshToken != null,
        'getRefreshToken must be provided when onRefreshToken is set',
      );
      assert(
        onTokensRefreshed != null,
        'onTokensRefreshed must be provided when onRefreshToken is set',
      );
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[headerKey] = 'Bearer $token';
      }
      handler.next(options);
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors if refresh is configured
    if (err.response?.statusCode == ResponseCode.unauthorized &&
        onRefreshToken != null) {
      try {
        final newToken = await _refreshTokenWithQueue(err.requestOptions);

        // Retry the original request with new token
        final retryResponse = await _retryRequest(err.requestOptions, newToken);
        return handler.resolve(retryResponse);
      } on DioException catch (e) {
        return handler.reject(e);
      } catch (e) {
        return handler.reject(
          DioException(requestOptions: err.requestOptions, error: e),
        );
      }
    }

    handler.next(err);
  }

  /// Refresh the token with proper queue management to handle concurrent requests
  Future<String> _refreshTokenWithQueue(RequestOptions failedRequest) async {
    // If already refreshing, queue this request and wait
    if (_isRefreshing) {
      final completer = Completer<String>();
      _requestQueue.add(
        _RequestQueueItem(requestOptions: failedRequest, completer: completer),
      );
      return completer.future;
    }

    // Start refresh process
    _isRefreshing = true;

    try {
      final refreshToken = await getRefreshToken!();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('Refresh token not available');
      }

      // Call the refresh endpoint
      final tokens = await onRefreshToken!(refreshToken);

      // Save new tokens
      await onTokensRefreshed!(tokens);

      // Complete all queued requests with the new token
      _completeQueuedRequests(tokens.accessToken);

      return tokens.accessToken;
    } catch (e) {
      // Fail all queued requests
      _failQueuedRequests(e);

      // Notify that refresh failed
      await onRefreshFailed?.call();

      rethrow;
    } finally {
      _isRefreshing = false;
      _requestQueue.clear();
    }
  }

  /// Complete all queued requests with the new access token
  void _completeQueuedRequests(String newToken) {
    for (final item in _requestQueue) {
      item.completer.complete(newToken);
    }
  }

  /// Fail all queued requests
  void _failQueuedRequests(dynamic error) {
    for (final item in _requestQueue) {
      item.completer.completeError(error);
    }
  }

  /// Retry a failed request with a new access token
  Future<Response> _retryRequest(
    RequestOptions options,
    String newToken,
  ) async {
    // Create new options with updated token
    final newOptions = options.copyWith(
      headers: {...options.headers, headerKey: 'Bearer $newToken'},
    );

    // Retry the request
    final dio = Dio();
    return dio.fetch(newOptions);
  }
}

/// Data class to hold access and refresh tokens
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }
}

/// Internal class to manage queued requests during token refresh
class _RequestQueueItem {
  final RequestOptions requestOptions;
  final Completer<String> completer;

  _RequestQueueItem({required this.requestOptions, required this.completer});
}
