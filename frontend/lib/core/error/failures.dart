import 'package:equatable/equatable.dart';

// Base Failure class
abstract class Failure extends Equatable {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure({
    this.message = 'An error occurred',
    this.error,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, error, stackTrace];

  @override
  String toString() => 'Failure(message: $message, error: $error)';
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Authentication failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    String message = 'Forbidden',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    String message = 'Validation failed',
    this.errors,
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);

  @override
  List<Object?> get props => [message, errors, error, stackTrace];
}

// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Resource not found',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Request timed out',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'Unknown error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Format failure
class FormatFailure extends Failure {
  const FormatFailure({
    String message = 'Format error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Platform failure
class PlatformFailure extends Failure {
  const PlatformFailure({
    String message = 'Platform error occurred',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    String message = 'Permission denied',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(message: message, error: error, stackTrace: stackTrace);
}

// Extension to convert exceptions to failures
extension ExceptionToFailure on Exception {
  Failure toFailure() {
    if (this is FormatException) {
      return const FormatFailure();
    } else if (this is UnimplementedError) {
      return const UnknownFailure(message: 'Not implemented');
    } else {
      return UnknownFailure(error: this);
    }
  }
}
