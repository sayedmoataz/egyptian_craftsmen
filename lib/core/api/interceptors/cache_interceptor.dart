import 'dart:collection';
import 'package:dio/dio.dart';

/// Cache interceptor with LRU (Least Recently Used) eviction policy.
/// 
/// Features:
/// - Configurable cache size and duration
/// - LRU eviction when cache is full
/// - Per-request cache control via options.extra
/// 
/// Usage:
/// ```dart
/// // Enable cache for specific request
/// dio.get('/endpoint', options: Options(extra: {'cache': true}));
/// 
/// // Set custom cache duration
/// dio.get('/endpoint', options: Options(extra: {
///   'cache': true,
///   'cacheDuration': Duration(minutes: 10),
/// }));
/// ```
class CacheInterceptor extends Interceptor {
  final Duration defaultCacheDuration;
  final int maxCacheSize;
  final LinkedHashMap<String, CachedResponse> _cache = LinkedHashMap();

  CacheInterceptor({
    this.defaultCacheDuration = const Duration(minutes: 5),
    this.maxCacheSize = 100,
  }) : assert(maxCacheSize > 0, 'maxCacheSize must be positive');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only cache GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    // Check if caching is enabled for this request
    final cacheEnabled = options.extra['cache'] as bool? ?? false;
    if (!cacheEnabled) {
      return handler.next(options);
    }

    final key = _generateKey(options);
    final cached = _cache[key];

    if (cached != null && !cached.isExpired) {
      // Move to end (mark as recently used)
      _cache.remove(key);
      _cache[key] = cached;

      return handler.resolve(
        Response(
          requestOptions: options,
          data: cached.data,
          statusCode: 200,
          headers: Headers.fromMap({'X-Cache': ['HIT']}),
        ),
      );
    }

    // Remove expired entry if exists
    if (cached != null && cached.isExpired) {
      _cache.remove(key);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;

    // Only cache GET requests with 200 status
    if (options.method != 'GET' || response.statusCode != 200) {
      return handler.next(response);
    }

    final cacheEnabled = options.extra['cache'] as bool? ?? false;
    if (!cacheEnabled) {
      return handler.next(response);
    }

    final key = _generateKey(options);
    
    // Get custom duration if provided
    final customDuration = options.extra['cacheDuration'] as Duration?;
    final duration = customDuration ?? defaultCacheDuration;

    // Implement LRU eviction
    if (_cache.length >= maxCacheSize) {
      // Remove oldest (first) entry
      _cache.remove(_cache.keys.first);
    }

    // Add to cache (at the end, marking as most recently used)
    _cache[key] = CachedResponse(
      data: response.data,
      timestamp: DateTime.now(),
      duration: duration,
    );

    handler.next(response);
  }

  /// Generate cache key from request options
  String _generateKey(RequestOptions options) {
    final buffer = StringBuffer()
      ..write(options.path);

    // Include query parameters in key
    if (options.queryParameters.isNotEmpty) {
      final sortedParams = Map.fromEntries(
        options.queryParameters.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)),
      );
      buffer.write('?${Uri(queryParameters: sortedParams.map((k, v) => MapEntry(k, v.toString()))).query}');
    }

    return buffer.toString();
  }

  /// Clear all cached responses
  void clearCache() {
    _cache.clear();
  }

  /// Remove a specific cached entry
  void removeCached(String path, [Map<String, dynamic>? queryParams]) {
    final options = RequestOptions(
      path: path,
      queryParameters: queryParams ?? {},
    );
    final key = _generateKey(options);
    _cache.remove(key);
  }

  /// Get current cache size
  int get cacheSize => _cache.length;

  /// Check if cache contains a specific key
  bool containsKey(String path, [Map<String, dynamic>? queryParams]) {
    final options = RequestOptions(
      path: path,
      queryParameters: queryParams ?? {},
    );
    final key = _generateKey(options);
    return _cache.containsKey(key) && !_cache[key]!.isExpired;
  }
}

/// Represents a cached response with expiration
class CachedResponse {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CachedResponse({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > duration;
}