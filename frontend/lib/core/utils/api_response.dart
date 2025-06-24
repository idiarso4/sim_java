
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic rawData;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final String? errorType;
  final String? requestId;
  final DateTime? timestamp;
  final String? path;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.rawData,
    this.statusCode,
    this.errors,
    this.errorType,
    this.requestId,
    this.timestamp,
    this.path,
  });

  // Factory constructor for successful response
  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
    dynamic rawData,
    String? requestId,
    String? path,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message ?? 'Operation completed successfully',
      statusCode: statusCode ?? 200,
      rawData: rawData,
      requestId: requestId,
      timestamp: DateTime.now(),
      path: path,
    );
  }

  // Factory constructor for error response
  factory ApiResponse.error({
    String? message,
    int? statusCode,
    dynamic data,
    Map<String, dynamic>? errors,
    String? errorType,
    dynamic rawData,
    String? requestId,
    String? path,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message ?? 'An error occurred',
      statusCode: statusCode ?? 500,
      data: data,
      errors: errors,
      errorType: errorType,
      rawData: rawData,
      requestId: requestId,
      timestamp: DateTime.now(),
      path: path,
    );
  }

  // Create from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    try {
      final success = json['success'] as bool? ?? false;
      final message = json['message'] as String?;
      final statusCode = json['statusCode'] as int?;
      final errorType = json['errorType'] as String?;
      final requestId = json['requestId'] as String?;
      final path = json['path'] as String?;
      final timestamp = json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null;

      dynamic data;
      if (fromJsonT != null && json['data'] != null) {
        data = fromJsonT(json['data']);
      } else {
        data = json['data'] as T?;
      }

      final errors = json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'] as Map)
          : null;

      return ApiResponse<T>(
        success: success,
        message: message,
        data: data,
        statusCode: statusCode,
        errors: errors,
        errorType: errorType,
        rawData: json,
        requestId: requestId,
        timestamp: timestamp,
        path: path,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to parse API response: $e',
        statusCode: 500,
        rawData: json,
      );
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'statusCode': statusCode,
      'errors': errors,
      'errorType': errorType,
      'requestId': requestId,
      'timestamp': timestamp?.toIso8601String(),
      'path': path,
    };
  }

  // Check if response has data
  bool get hasData => data != null;

  // Check if response has errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  // Get first error message
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    final firstError = errors!.values.first;
    if (firstError is List) {
      return firstError.isNotEmpty ? firstError.first.toString() : null;
    }
    return firstError.toString();
  }

  // Get all error messages
  List<String> get allErrorMessages {
    final messages = <String>[];
    if (errors == null) return messages;
    
    for (final entry in errors!.entries) {
      if (entry.value is List) {
        for (final item in entry.value as List) {
          messages.add('${entry.key}: $item');
        }
      } else {
        messages.add('${entry.key}: ${entry.value}');
      }
    }
    
    return messages;
  }

  // Get error message for a specific field
  String? getErrorForField(String fieldName) {
    if (errors == null || !errors!.containsKey(fieldName)) return null;
    final error = errors![fieldName];
    if (error is List) {
      return error.isNotEmpty ? error.first.toString() : null;
    }
    return error.toString();
  }

  // Create a copy with updated values
  ApiResponse<T> copyWith({
    bool? success,
    String? message,
    T? data,
    dynamic rawData,
    int? statusCode,
    Map<String, dynamic>? errors,
    String? errorType,
    String? requestId,
    DateTime? timestamp,
    String? path,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      rawData: rawData ?? this.rawData,
      statusCode: statusCode ?? this.statusCode,
      errors: errors ?? this.errors,
      errorType: errorType ?? this.errorType,
      requestId: requestId ?? this.requestId,
      timestamp: timestamp ?? this.timestamp,
      path: path ?? this.path,
    );
  }

  // Convert to string
  @override
  String toString() {
    return 'ApiResponse{\n'
        '  success: $success,\n'
        '  message: $message,\n'
        '  statusCode: $statusCode,\n'
        '  data: $data,\n'
        '  errors: $errors,\n'
        '  errorType: $errorType,\n'
        '  requestId: $requestId,\n'
        '  timestamp: $timestamp,\n'
        '  path: $path\n'
        '}';
  }
}

// Extension for handling Future responses
extension FutureApiResponse<T> on Future<ApiResponse<T>> {
  // Handle success and error cases
  Future<ApiResponse<T>> handleResponse({
    Function(T data)? onSuccess,
    Function(String message, Map<String, dynamic>? errors)? onError,
    Function()? onComplete,
  }) async {
    try {
      final response = await this;
      
      if (response.success) {
        if (onSuccess != null && response.data != null) {
          onSuccess(response.data as T);
        }
      } else {
        if (onError != null) {
          onError(
            response.message ?? 'An error occurred',
            response.errors,
          );
        }
      }
      
      return response;
    } catch (e, stackTrace) {
      debugPrint('Error handling API response: $e\n$stackTrace');
      if (onError != null) {
        onError('An unexpected error occurred', null);
      }
      return ApiResponse.error(
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    } finally {
      if (onComplete != null) {
        onComplete();
      }
    }
  }
}

// Extension for handling List responses
extension ListApiResponse<T> on ApiResponse<List<T>> {
  // Get item at index
  T? getItem(int index) {
    if (data == null || index < 0 || index >= data!.length) {
      return null;
    }
    return data![index];
  }


  // Get first item
  T? get first => data?.isNotEmpty == true ? data!.first : null;

  // Get last item
  T? get last => data?.isNotEmpty == true ? data!.last : null;

  // Get length
  int get length => data?.length ?? 0;

  // Check if empty
  bool get isEmpty => data?.isEmpty ?? true;

  // Check if not empty
  bool get isNotEmpty => data?.isNotEmpty ?? false;


  // Map items
  Iterable<R> mapItems<R>(R Function(T) mapper) {
    return data?.map(mapper) ?? const [];
  }

  // Filter items
  Iterable<T> whereItems(bool Function(T) test) {
    return data?.where(test) ?? const [];
  }

  // Find first item that matches the test
  T? firstWhereOrNull(bool Function(T) test) {
    return data?.firstWhere(test, orElse: () => null as T);
  }
}

// Extension for handling paginated responses
class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List).map(fromJsonT).toList(),
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map(toJsonT).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  // Create an empty paginated response
  factory PaginatedResponse.empty() {
    return PaginatedResponse<T>(
      items: [],
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      itemsPerPage: 10,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  // Check if the response is empty
  bool get isEmpty => items.isEmpty;

  // Check if the response is not empty
  bool get isNotEmpty => items.isNotEmpty;

  // Get the number of items
  int get length => items.length;

  // Get item at index
  T operator [](int index) => items[index];

  // Map items
  Iterable<R> map<R>(R Function(T) mapper) => items.map(mapper);

  // Filter items
  Iterable<T> where(bool Function(T) test) => items.where(test);
}

// Extension for handling paginated API responses
extension PaginatedApiResponse<T> on ApiResponse<PaginatedResponse<T>> {
  // Get items
  List<T> get items => data?.items ?? [];

  // Get current page
  int get currentPage => data?.currentPage ?? 1;


  // Get total pages
  int get totalPages => data?.totalPages ?? 1;


  // Get total items
  int get totalItems => data?.totalItems ?? 0;

  // Get items per page
  int get itemsPerPage => data?.itemsPerPage ?? 10;

  // Check if has next page
  bool get hasNextPage => data?.hasNextPage ?? false;

  // Check if has previous page
  bool get hasPreviousPage => data?.hasPreviousPage ?? false;

  // Check if response is empty
  bool get isEmpty => data?.isEmpty ?? true;

  // Check if response is not empty
  bool get isNotEmpty => data?.isNotEmpty ?? false;

  // Get number of items
  int get length => data?.length ?? 0;

  // Get item at index
  T? operator [](int index) => data?[index];

  // Map items
  Iterable<R> mapItems<R>(R Function(T) mapper) {
    return data?.map(mapper) ?? const [];
  }
  // Filter items
  Iterable<T> whereItems(bool Function(T) test) {
    return data?.where(test) ?? const [];
  }
  // Find first item that matches the test
  T? firstWhereOrNull(bool Function(T) test) {
    return data?.firstWhere(test, orElse: () => null as T);
  }
}
