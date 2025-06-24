import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/core/network/network_info.dart';
import 'package:sim_java_frontend/core/utils/logger_utils.dart';

/// A utility class for handling API calls with Dio
class ApiUtils {
  final Dio _dio;
  final NetworkInfo networkInfo;
  
  // Singleton instance
  static final ApiUtils _instance = ApiUtils._internal(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
    NetworkInfo(),
  );
  
  factory ApiUtils() => _instance;
  
  ApiUtils._internal(this._dio, this.networkInfo) {
    // Add interceptors
    _addInterceptors();
  }
  
  // Initialize with custom Dio instance
  static void initialize(Dio dio, NetworkInfo networkInfo) {
    _instance._dio = dio;
    _addInterceptors();
  }
  
  // Add interceptors to Dio
  static void _addInterceptors() {
    _instance._dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Log request
          LoggerUtils.request(
            method: options.method,
            url: options.uri.toString(),
            headers: options.headers,
            queryParameters: options.queryParameters,
            body: options.data,
          );
          
          // Add auth token if available
          // final token = await _getAuthToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          LoggerUtils.response(
            method: response.requestOptions.method,
            url: response.requestOptions.uri.toString(),
            statusCode: response.statusCode ?? 0,
            headers: response.headers.map,
            body: response.data,
          );
          
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Log error
          LoggerUtils.e(
            'API Error',
            error,
            error.stackTrace,
            stackTrace: error.stackTrace,
          );
          
          // Handle token refresh if 401
          // if (error.response?.statusCode == 401) {
          //   return _handleTokenRefresh(error, handler);
          // }
          
          return handler.next(error);
        },
      ),
    );
  }
  
  // Handle token refresh
  // static Future<void> _handleTokenRefresh(
  //   DioException error,
  //   ErrorInterceptorHandler handler,
  // ) async {
  //   try {
  //     // Refresh token logic here
  //     // final newToken = await authRepository.refreshToken();
  //     
  //     // Update the request with new token
  //     error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
  //     
  //     // Repeat the request
  //     final response = await _instance._dio.fetch(error.requestOptions);
  //     return handler.resolve(response);
  //   } catch (e) {
  //     // If refresh fails, redirect to login
  //     // await _logout();
  //     return handler.next(error);
  //   }
  // }
  
  // Set base URL
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
  
  // Set auth token
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
  
  // Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  // Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // Generic PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // File upload
  Future<Response<T>> upload<T>(
    String path, {
    required String filePath,
    String fileKey = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _checkConnectivity();
      
      final formData = FormData.fromMap({
        ...?data,
        fileKey: await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });
      
      final response = await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // File download
  Future<Response> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        onReceiveProgress: onReceiveProgress,
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }
  
  // Handle response
  Response<T> _handleResponse<T>(Response<T> response) {
    // You can add common response handling here
    // For example, checking for custom error codes in the response
    
    // Example:
    // if (response.data is Map && response.data['status'] == 'error') {
    //   throw ServerException(
    //     message: response.data['message'] ?? 'An error occurred',
    //     statusCode: response.statusCode,
    //   );
    // }
    
    return response;
  }
  
  // Check internet connectivity
  Future<void> _checkConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      throw const NetworkException('No internet connection');
    }
  }
  
  // Handle Dio errors
  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkException('Connection timeout');
    } else if (error.type == DioExceptionType.badResponse) {
      // Handle different HTTP status codes
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      
      String message = 'An error occurred';
      
      if (responseData is Map) {
        message = responseData['message'] ?? message;
      } else if (responseData is String) {
        message = responseData;
      }
      
      switch (statusCode) {
        case 400:
          return BadRequestException(message);
        case 401:
          return UnauthorizedException(message);
        case 403:
          return ForbiddenException(message);
        case 404:
          return NotFoundException(message);
        case 422:
          return ValidationException(
            message: 'Validation failed',
            errors: responseData is Map ? responseData['errors'] : null,
          );
        case 500:
          return ServerException(message: message, statusCode: statusCode);
        default:
          return ServerException(
            message: message,
            statusCode: statusCode,
          );
      }
    } else if (error.type == DioExceptionType.cancel) {
      return const CancelRequestException('Request cancelled');
    } else if (error.type == DioExceptionType.unknown) {
      if (error.error is SocketException) {
        return const NetworkException('No internet connection');
      }
      return UnknownException(error.error?.toString() ?? 'An unknown error occurred');
    } else {
      return UnknownException(error.message ?? 'An unknown error occurred');
    }
  }
  
  // Handle generic errors
  Exception _handleError(dynamic error, StackTrace stackTrace) {
    LoggerUtils.e('API Error', error, stackTrace);
    
    if (error is Exception) {
      return error;
    } else {
      return UnknownException(error?.toString() ?? 'An unknown error occurred');
    }
  }
}

// Extension for BuildContext to easily access API utils
extension ApiUtilsExtension on BuildContext {
  ApiUtils get apiUtils => ApiUtils();
  
  // Convenience methods for common API calls
  
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      ApiUtils().get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      ApiUtils().post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      ApiUtils().put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      ApiUtils().delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) =>
      ApiUtils().download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
}
