abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.'});
}

class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Connection timed out.'});
}

class ServerException extends AppException {
  const ServerException({super.message = 'Internal server error.'})
      : super(statusCode: 500);
}

class BadRequestException extends AppException {
  const BadRequestException({super.message = 'Bad request.'})
      : super(statusCode: 400);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized.'})
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException({super.message = 'Forbidden.'})
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Not found.'})
      : super(statusCode: 404);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message = 'Validation failed.',
    this.errors,
  }) : super(statusCode: 422);
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException({super.message = 'Too many requests.'})
      : super(statusCode: 429);
}

class RequestCancelledException extends AppException {
  const RequestCancelledException({super.message = 'Request cancelled.'});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error.'});
}

class UnknownException extends AppException {
  const UnknownException({super.message = 'An unexpected error occurred.'});
}
