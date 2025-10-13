/// Base class for all custom exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final String? technicalDetails;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.technicalDetails,
  });

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}${technicalDetails != null ? ' | $technicalDetails' : ''}';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}

/// Exception thrown when platform operation fails
class PlatformException extends AppException {
  const PlatformException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}

/// Exception thrown when database operation fails
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}

/// Exception thrown when network operation fails
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.technicalDetails,
  });
}
