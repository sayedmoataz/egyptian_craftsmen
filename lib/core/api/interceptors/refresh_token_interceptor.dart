import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(String accessToken, String refreshToken)
  saveTokens;
  final Future<Map<String, dynamic>> Function(String refreshToken)
  refreshTokenCall;
  final Future<void> Function() onRefreshFailed;

  RefreshTokenInterceptor({
    required this.getRefreshToken,
    required this.saveTokens,
    required this.refreshTokenCall,
    required this.onRefreshFailed,
  });

  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshToken = await getRefreshToken();
          if (refreshToken == null) {
            await onRefreshFailed();
            return handler.reject(err);
          }

          final response = await refreshTokenCall(refreshToken);
          await saveTokens(response['access_token'], response['refresh_token']);

          // Retry failed request
          final options = err.requestOptions;
          options.headers['Authorization'] =
              'Bearer ${response['access_token']}';

          final retryResponse = await Dio().fetch(options);
          return handler.resolve(retryResponse);
        } catch (e) {
          await onRefreshFailed();
          return handler.reject(err);
        } finally {
          _isRefreshing = false;
        }
      }
    }
    return handler.next(err);
  }
}
