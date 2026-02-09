/// Unified API response wrapper matching standard backend response formats.
///
/// Standard API Response Format:
/// ```json
/// {
///   "status": "success" | "error",
///   "message": "Human-readable message",
///   "data": { ... },
///   "meta": { "current_page": 1, ... },
///   "errors": { "field": ["error1", "error2"] }
/// }
/// ```
class ApiResponse<T> {
  /// Response status ('success' or 'error')
  final String status;

  /// Human-readable response message
  final String message;

  /// The parsed data payload (null if error or no content)
  final T? data;

  /// Pagination metadata (optional)
  final ApiMeta? meta;

  /// Validation errors map (optional)
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.meta,
    this.errors,
  });

  /// Whether the response indicates success
  bool get isSuccess => status == 'success';

  /// Whether the response indicates an error
  bool get isError => status == 'error';

  /// Whether there are validation errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Get the first error message from the errors map
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    
    final firstKey = errors!.keys.first;
    final errorValue = errors![firstKey];
    
    if (errorValue is List && errorValue.isNotEmpty) {
      return errorValue.first.toString();
    }
    
    return errorValue?.toString();
  }

  /// Get all error messages as a flat list
  List<String> get allErrors {
    if (errors == null || errors!.isEmpty) return [];

    final errorList = <String>[];
    
    for (final entry in errors!.entries) {
      if (entry.value is List) {
        errorList.addAll(
          (entry.value as List).map((e) => e.toString()),
        );
      } else {
        errorList.add(entry.value.toString());
      }
    }
    
    return errorList;
  }

  /// Create an ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'] != null
          ? ApiMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  /// Create a response for raw data (when no parsing is needed)
  factory ApiResponse.raw(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      data: json['data'] as T?,
      meta: json['meta'] != null
          ? ApiMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': toJsonT(data as T),
      if (meta != null) 'meta': meta!.toJson(),
      if (errors != null) 'errors': errors,
    };
  }

  /// Copy with new values
  ApiResponse<T> copyWith({
    String? status,
    String? message,
    T? data,
    ApiMeta? meta,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
      meta: meta ?? this.meta,
      errors: errors ?? this.errors,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(status: $status, message: $message, hasData: ${data != null}, hasErrors: $hasErrors)';
  }
}

/// Pagination metadata model
class ApiMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;

  const ApiMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
  });

  /// Check if there's a next page
  bool get hasNextPage => currentPage < lastPage;

  /// Check if there's a previous page
  bool get hasPreviousPage => currentPage > 1;

  /// Calculate total number of pages
  int get totalPages => lastPage;

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    final currentPage = json['current_page'] as int? ?? 1;
    final lastPage = json['last_page'] as int? ?? 1;

    return ApiMeta(
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      hasMore: json['has_more'] as bool? ?? (currentPage < lastPage),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'has_more': hasMore,
    };
  }

  @override
  String toString() {
    return 'ApiMeta(page: $currentPage/$lastPage, total: $total, hasMore: $hasMore)';
  }
}

/// Specialized response wrapper for list/paginated responses
class ApiListResponse<T> {
  final String status;
  final String message;
  final List<T> items;
  final ApiMeta? meta;
  final Map<String, dynamic>? errors;

  const ApiListResponse({
    required this.status,
    required this.message,
    required this.items,
    this.meta,
    this.errors,
  });

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
  bool get hasMore => meta?.hasMore ?? false;
  bool get hasNextPage => meta?.hasNextPage ?? false;
  bool get hasPreviousPage => meta?.hasPreviousPage ?? false;
  int get currentPage => meta?.currentPage ?? 1;
  int get totalPages => meta?.lastPage ?? 1;
  int get totalItems => meta?.total ?? items.length;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    // Handle different response structures
    List<dynamic> dataList = [];
    
    if (json['data'] is List) {
      dataList = json['data'] as List<dynamic>;
    } else if (json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['items'] is List) {
        dataList = dataMap['items'] as List<dynamic>;
      } else if (dataMap['data'] is List) {
        dataList = dataMap['data'] as List<dynamic>;
      }
    }

    return ApiListResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      items: dataList.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException(
            'Expected Map<String, dynamic> for list item but received ${item.runtimeType}',
          );
        }
        return itemFromJson(item);
      }).toList(),
      meta: json['meta'] != null
          ? ApiMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) itemToJson) {
    return {
      'status': status,
      'message': message,
      'data': items.map(itemToJson).toList(),
      if (meta != null) 'meta': meta!.toJson(),
      if (errors != null) 'errors': errors,
    };
  }

  @override
  String toString() {
    return 'ApiListResponse(status: $status, items: ${items.length}, page: ${meta?.currentPage}/${meta?.lastPage})';
  }
}