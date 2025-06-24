import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sim_java_frontend/core/constants/strings.dart';
import 'package:sim_java_frontend/core/utils/logger.dart';
import 'package:sim_java_frontend/presentation/bloc/authentication/authentication_bloc.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}

class NetworkUtils {
  static final NetworkUtils _instance = NetworkUtils._internal();
  factory NetworkUtils() => _instance;
  NetworkUtils._internal();

  static const String _baseUrl = 'https://api.simjava.com/v1';
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _sendTimeout = Duration(seconds: 30);

  late final Dio _dio;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Initialize the Dio client
  void initialize({String? authToken}) {
    if (authToken != null) {
      _headers['Authorization'] = 'Bearer $authToken';
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        headers: _headers,
        responseType: ResponseType.json,
        validateStatus: (status) => status! < 500, // Consider all status codes < 500 as success
      ),
    );

    // Add interceptors
    _addInterceptors();
  }

  // Add interceptors for logging, auth, error handling, etc.
  void _addInterceptors() {
    // Logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          AppLogger.d('''
          *** Request ***
          URL: ${options.uri}
          Method: ${options.method}
          Headers: ${options.headers}
          Query Parameters: ${options.queryParameters}
          Data: ${options.data}
          ''');
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          AppLogger.d('''
          *** Response ***
          URL: ${response.requestOptions.uri}
          Status Code: ${response.statusCode}
          Headers: ${response.headers}
          Response: ${response.data}
          ''');
          return handler.next(response);
        },
        onError: (DioError error, handler) async {
          AppLogger.e('''
          *** Error ***
          URL: ${error.requestOptions.uri}
          Status Code: ${error.response?.statusCode}
          Message: ${error.message}
          Response: ${error.response?.data}
          Stack Trace: ${error.stackTrace}
          ''');
          return handler.next(error);
        },
      ),
    );

    // Token refresh interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Handle 401 Unauthorized errors
          if (error.response?.statusCode == 401) {
            // TODO: Implement token refresh logic
            // For now, just pass the error along
            return handler.next(error);
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Set authentication token
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear authentication token
  void clearAuthToken() {
    _headers.remove('Authorization');
    _dio.options.headers.remove('Authorization');
  }

  // Handle error responses
  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response.data;
      case 400:
        throw NetworkException(
          message: _getErrorMessage(response.data) ?? 'Bad Request',
          statusCode: response.statusCode,
          data: response.data,
        );
      case 401:
        throw NetworkException(
          message: _getErrorMessage(response.data) ?? 'Unauthorized',
          statusCode: response.statusCode,
          data: response.data,
        );
      case 403:
        throw NetworkException(
          message: _getErrorMessage(response.data) ?? 'Forbidden',
          statusCode: response.statusCode,
          data: response.data,
        );
      case 404:
        throw NetworkException(
          message: _getErrorMessage(response.data) ?? 'Resource not found',
          statusCode: response.statusCode,
          data: response.data,
        );
      case 422:
        throw NetworkException(
          message: _getErrorMessage(response.data) ?? 'Validation failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      case 500:
      default:
        throw NetworkException(
          message: _getErrorMessage(response.data) ?? 'Internal server error',
          statusCode: response.statusCode,
          data: response.data,
        );
    }
  }

  // Extract error message from response
  String? _getErrorMessage(dynamic data) {
    try {
      if (data == null) return null;
      
      if (data is String) {
        return data;
      } else if (data is Map) {
        if (data['message'] != null) {
          return data['message'].toString();
        } else if (data['error'] != null) {
          return data['error'].toString();
        } else if (data['errors'] != null) {
          // Handle validation errors
          final errors = data['errors'];
          if (errors is Map) {
            return errors.values.first is List 
                ? (errors.values.first as List).first.toString()
                : errors.values.first.toString();
          } else if (errors is List) {
            return errors.first.toString();
          }
        }
      }
      
      return 'An unknown error occurred';
    } catch (e) {
      AppLogger.e('Error parsing error message', e);
      return 'Failed to parse error message';
    }
  }

  // HTTP GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.sendTimeout) {
        throw NetworkException(message: 'Send timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Unexpected error in GET request', e);
      rethrow;
    }
  }

  // HTTP POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.sendTimeout) {
        throw NetworkException(message: 'Send timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Unexpected error in POST request', e);
      rethrow;
    }
  }

  // HTTP PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.sendTimeout) {
        throw NetworkException(message: 'Send timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Unexpected error in PUT request', e);
      rethrow;
    }
  }

  // HTTP DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.sendTimeout) {
        throw NetworkException(message: 'Send timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Unexpected error in DELETE request', e);
      rethrow;
    }
  }

  // HTTP PATCH request
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.sendTimeout) {
        throw NetworkException(message: 'Send timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Unexpected error in PATCH request', e);
      rethrow;
    }
  }

  // Download file
  Future<Response<dynamic>> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Error downloading file', e);
      rethrow;
    }
  }

  // Upload file
  Future<dynamic> uploadFile(
    String path,
    String filePath, {
    String fileKey = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        fileKey: await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _dio.post<dynamic>(
        path,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw NetworkException(message: 'Connection timeout');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw NetworkException(message: 'Receive timeout');
      } else if (e.type == DioErrorType.other) {
        if (e.error is SocketException) {
          throw NetworkException(message: 'No internet connection');
        } else if (e.error is FormatException) {
          throw NetworkException(message: 'Invalid response format');
        }
      }
      rethrow;
    } catch (e) {
      AppLogger.e('Error uploading file', e);
      rethrow;
    }
  }

  // Cancel all requests
  void cancelRequests({required CancelToken cancelToken}) {
    cancelToken.cancel('Request cancelled');
  }

  // Handle network connectivity
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
