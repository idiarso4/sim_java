import 'package:dio/dio.dart';

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Server exceptions
class ServerException extends AppException {
  const ServerException({
    String message = 'Server error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);

  factory ServerException.fromDioException(DioException e) {
    try {
      final response = e.response;
      final statusCode = response?.statusCode;
      final data = response?.data;
      
      String message = 'Server error';
      Map<String, dynamic>? errors;
      
      if (data != null) {
        if (data is Map) {
          message = data['message']?.toString() ?? message;
          if (data['errors'] != null) {
            errors = Map<String, dynamic>.from(data['errors']);
          }
        } else if (data is String) {
          message = data;
        }
      }
      
      switch (statusCode) {
        case 400:
          return BadRequestException(
            message: message,
            error: e,
            stackTrace: e.stackTrace,
          );
        case 401:
          return UnauthorizedException(
            message: message,
            error: e,
            stackTrace: e.stackTrace,
          );
        case 403:
          return ForbiddenException(
            message: message,
            error: e,
            stackTrace: e.stackTrace,
          );
        case 404:
          return NotFoundException(
            message: message,
            error: e,
            stackTrace: e.stackTrace,
          );
        case 422:
          return ValidationException(
            message: message,
            errors: errors,
            error: e,
            stackTrace: e.stackTrace,
          );
        case 500:
        case 502:
        case 503:
        case 504:
          return ServerException(
            message: message,
            error: e,
            stackTrace: e.stackTrace,
          );
        default:
          return ServerException(
            message: message,
            error: e,
            stackTrace: e.stackTrace,
          );
      }
    } catch (_) {
      return ServerException(
        message: e.message ?? 'An error occurred',
        error: e,
        stackTrace: e.stackTrace,
      );
    }
  }
}

class BadRequestException extends ServerException {
  const BadRequestException({
    String message = 'Bad request',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException({
    String message = 'Unauthorized',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
}

class ForbiddenException extends ServerException {
  const ForbiddenException({
    String message = 'Forbidden',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
}

class NotFoundException extends ServerException {
  const NotFoundException({
    String message = 'Not found',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
}

class ValidationException extends ServerException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    String message = 'Validation failed',
    this.errors,
    dynamic error,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
  
  @override
  String toString() => 'ValidationException: $message${errors != null ? ' $errors' : ''}';
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException({
    String message = 'Cache error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

class CacheNotExistException extends CacheException {
  const CacheNotExistException({
    String message = 'Cache does not exist',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException({
    String message = 'Network error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    String message = 'No internet connection',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

class TimeoutException extends NetworkException {
  const TimeoutException({
    String message = 'Request timed out',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Local storage exceptions
class LocalStorageException extends AppException {
  const LocalStorageException({
    String message = 'Local storage error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({
    String message = 'Permission denied',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Platform exceptions
class PlatformException extends AppException {
  const PlatformException({
    String message = 'Platform error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Format exceptions
class FormatException extends AppException {
  const FormatException({
    String message = 'Format error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    String message = 'Authentication failed',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    String message = 'Database error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

/// File system exceptions
class FileSystemException extends AppException {
  const FileSystemException({
    String message = 'File system error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}
