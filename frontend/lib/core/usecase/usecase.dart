import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class Failure {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'Failure(message: $message, error: $error)';
}
