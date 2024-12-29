sealed class ApodServerException implements Exception {
  const ApodServerException({required this.message});

  final String message;
}

class InvalidRequestException extends ApodServerException {
  const InvalidRequestException({required super.message});
}

class RateLimitException extends ApodServerException {
  const RateLimitException() : super(message: '');
}

class ServerSideException extends ApodServerException {
  const ServerSideException() : super(message: '');
}

class NetworkException extends ApodServerException {
  const NetworkException() : super(message: '');
}
