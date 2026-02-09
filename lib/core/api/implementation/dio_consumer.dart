import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../errors/error_handler.dart';
import '../../errors/failure.dart';
import '../config/constants.dart';
import '../config/network_config.dart';
import '../contracts/api_consumer.dart';
import '../interceptors/cancellation_interceptor.dart';
import '../request_handler/response_wrapper.dart';

/// Dio-based implementation of ApiConsumer.
///
/// Features:
/// - Type-safe response handling with ApiResponse wrapper
/// - Proper error handling and mapping
/// - Request cancellation support
/// - Extensible via interceptors
class DioConsumer implements ApiConsumer {
  final Dio _dio;
  final CancellationInterceptor _cancellationInterceptor;

  DioConsumer(
    NetworkConfig config, {
    CancellationInterceptor? cancellationInterceptor,
  }) : _cancellationInterceptor =
           cancellationInterceptor ?? CancellationInterceptor(),
       _dio = Dio(
         BaseOptions(
           baseUrl: config.baseUrl,
           connectTimeout: config.connectTimeout,
           receiveTimeout: config.receiveTimeout,
           sendTimeout: config.sendTimeout,
           responseType: config.defaultResponseType,
           validateStatus: config.validateStatus,
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
             ...config.defaultHeaders,
           },
         ),
       ) {
    // Validate config before setup
    config.validate();

    // Add cancellation interceptor first
    _dio.interceptors.add(_cancellationInterceptor);

    // Add user-provided interceptors
    for (var interceptor in config.interceptors) {
      _dio.interceptors.add(interceptor);
    }

    // Add logging interceptor last (if enabled)
    if (config.enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }
  }

  /// Core request handler with error mapping and type-safe conversion
  Future<Either<Failure, T>> _request<T>({
    required Future<Response> Function() request,
    required T Function(dynamic) converter,
  }) async {
    try {
      final response = await request();

      if (!ResponseCode.isSuccess(response.statusCode)) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final data = converter(response.data);
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handle(e, stackTrace: StackTrace.current));
    }
  }

  @override
  Future<Either<Failure, T>> get<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  Future<Either<Failure, List<T>>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) itemConverter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return get<List<T>>(
      endpoint: endpoint,
      converter: (data) => _convertList(data, itemConverter),
      queryParameters: queryParameters,
      headers: headers,
      options: options,
    );
  }

  @override
  Future<Either<Failure, ApiResponse<T>>> getWrapped<T>({
    required String endpoint,
    required T Function(dynamic) dataConverter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return get<ApiResponse<T>>(
      endpoint: endpoint,
      converter: (data) =>
          ApiResponse.fromJson(data as Map<String, dynamic>, dataConverter),
      queryParameters: queryParameters,
      headers: headers,
      options: options,
    );
  }

  @override
  Future<Either<Failure, ApiListResponse<T>>> getListWrapped<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) itemConverter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return get<ApiListResponse<T>>(
      endpoint: endpoint,
      converter: (data) =>
          ApiListResponse.fromJson(data as Map<String, dynamic>, itemConverter),
      queryParameters: queryParameters,
      headers: headers,
      options: options,
    );
  }

  @override
  Future<Either<Failure, T>> post<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  Future<Either<Failure, ApiResponse<T>>> postWrapped<T>({
    required String endpoint,
    required T Function(dynamic) dataConverter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return post<ApiResponse<T>>(
      endpoint: endpoint,
      converter: (responseData) => ApiResponse.fromJson(
        responseData as Map<String, dynamic>,
        dataConverter,
      ),
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
    );
  }

  @override
  Future<Either<Failure, T>> put<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  Future<Either<Failure, T>> delete<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  Future<Either<Failure, T>> patch<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(headers, options),
      ),
      converter: converter,
    );
  }

  @override
  Future<Either<Failure, T>> postMultipart<T>({
    required String endpoint,
    required FormData data,
    required T Function(Map<String, dynamic>) converter,
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
    Map<String, String>? headers,
    Options? options,
  }) async {
    return _request(
      request: () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: _buildOptions(headers, options),
      ),
      converter: (data) {
        if (data is! Map<String, dynamic>) {
          throw const ParseFailure(
            message: 'Expected Map<String, dynamic> for multipart response',
          );
        }
        return converter(data);
      },
    );
  }

  @override
  void cancelAllRequests([String? reason]) {
    _cancellationInterceptor.cancelAll(reason);
  }

  @override
  void cancelRequestsByTag(String tag, [String? reason]) {
    _cancellationInterceptor.cancelByTag(tag, reason);
  }

  @override
  int get pendingRequestCount => _cancellationInterceptor.pendingRequestCount;

  /// Helper to convert list responses with proper error handling
  List<T> _convertList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) itemConverter,
  ) {
    if (data is! List) {
      throw const ParseFailure(
        message: 'Expected List but received different type',
      );
    }

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw ParseFailure(
          message:
              'Expected Map<String, dynamic> for list item but received ${item.runtimeType}',
        );
      }
      return itemConverter(item);
    }).toList();
  }

  /// Build Dio Options from headers and custom options
  Options _buildOptions(Map<String, String>? headers, Options? options) {
    if (options != null) {
      return options.copyWith(headers: {...?options.headers, ...?headers});
    }
    return Options(headers: headers);
  }

  /// Expose the underlying Dio instance for advanced use cases
  Dio get dio => _dio;
}
