import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Using Equatable for value equality comparison
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({required this.message, this.code, this.originalError});

  @override
  List<Object?> get props => [message, code, originalError];

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure related to server/API communication
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Failure related to local cache/storage
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.originalError});
}

/// Failure related to platform-specific operations (e.g., Windows process detection)
class PlatformFailure extends Failure {
  const PlatformFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Failure related to database operations
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Failure related to authentication
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code, super.originalError});
}

/// Failure related to network connectivity
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Failure related to invalid input or validation
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Unknown/unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}
