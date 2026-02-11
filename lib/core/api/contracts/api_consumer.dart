import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../errors/failure.dart';
import '../request_handler/response_wrapper.dart';

/// Abstract contract for API consumer implementations.
///
/// Provides both raw data access and wrapped response methods.
// ignore: unintended_html_in_doc_comment
/// All methods return Either<Failure, T> for functional error handling.
abstract class ApiConsumer {
  // ============= RAW DATA METHODS =============
  // Use these when you want direct access to response data

  /// Perform a GET request and return raw data
  Future<Either<Failure, T>> get<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a GET request and return a list of items
  Future<Either<Failure, List<T>>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) itemConverter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a POST request and return raw data
  Future<Either<Failure, T>> post<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a PUT request and return raw data
  Future<Either<Failure, T>> put<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a DELETE request and return raw data
  Future<Either<Failure, T>> delete<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a PATCH request and return raw data
  Future<Either<Failure, T>> patch<T>({
    required String endpoint,
    required T Function(dynamic) converter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a multipart POST request (for file uploads)
  Future<Either<Failure, T>> postMultipart<T>({
    required String endpoint,
    required FormData data,
    required T Function(Map<String, dynamic>) converter,
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
    Map<String, String>? headers,
    Options? options,
  });

  // ============= WRAPPED RESPONSE METHODS =============
  // Use these when your API returns responses in ApiResponse format

  /// Perform a GET request and return wrapped response
  Future<Either<Failure, ApiResponse<T>>> getWrapped<T>({
    required String endpoint,
    required T Function(dynamic) dataConverter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a GET request and return wrapped list response
  Future<Either<Failure, ApiListResponse<T>>> getListWrapped<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) itemConverter,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  /// Perform a POST request and return wrapped response
  Future<Either<Failure, ApiResponse<T>>> postWrapped<T>({
    required String endpoint,
    required T Function(dynamic) dataConverter,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  });

  // ============= REQUEST MANAGEMENT =============

  /// Cancel all pending requests
  void cancelAllRequests([String? reason]);

  /// Cancel requests by tag
  void cancelRequestsByTag(String tag, [String? reason]);

  /// Get the number of pending requests
  int get pendingRequestCount;
}
