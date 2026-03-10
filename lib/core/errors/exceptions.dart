class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException($statusCode): $message';
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}
