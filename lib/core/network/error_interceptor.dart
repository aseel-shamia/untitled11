import 'package:dio/dio.dart';
import '../errors/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.badResponse:
        _handleBadResponse(err);
      case DioExceptionType.cancel:
        throw RequestCancelledException();
      case DioExceptionType.connectionError:
        throw NetworkException(
          message: 'No internet connection.',
        );
      default:
        throw UnknownException(
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
    handler.next(err);
  }

  void _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    String message = 'Something went wrong';

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(message: message);
      case 401:
        throw UnauthorizedException(message: message);
      case 403:
        throw ForbiddenException(message: message);
      case 404:
        throw NotFoundException(message: message);
      case 422:
        final errors = data is Map<String, dynamic>
            ? data['errors'] as Map<String, dynamic>?
            : null;
        throw ValidationException(message: message, errors: errors);
      case 429:
        throw TooManyRequestsException(message: message);
      case 500:
        throw ServerException(message: message);
      default:
        throw UnknownException(message: message);
    }
  }
}
