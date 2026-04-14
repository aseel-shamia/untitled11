import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/app_constants.dart';
import '../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthInterceptor(this._ref, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.tokenKey);

    if (token != null && token.isNotEmpty) {
      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        try {
          await _refreshToken();
          final newToken = await _storage.read(key: AppConstants.tokenKey);
          if (newToken != null) {
            options.headers['Authorization'] = 'Bearer $newToken';
          }
        } catch (e) {
          // Token refresh failed, clear storage
          await _clearAuth();
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.cancel,
              error: 'Session expired. Please login again.',
            ),
          );
        }
      } else {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await _refreshToken();
        final token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        await _clearAuth();
      }
    }
    handler.next(err);
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await Dio().post(
      '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'];
      await _storage.write(key: AppConstants.tokenKey, value: data['token']);
      if (data['refresh_token'] != null) {
        await _storage.write(
          key: AppConstants.refreshTokenKey,
          value: data['refresh_token'],
        );
      }
    } else {
      throw Exception('Token refresh failed');
    }
  }

  Future<void> _clearAuth() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }
}
