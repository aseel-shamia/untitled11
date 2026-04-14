import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider), ref.watch(secureStorageProvider));
});

class AuthRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  AuthRepository(this._dio, this._secureStorage);

  Future<UserModel> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    final authData = AuthResponse.fromJson(response.data['data']['auth']);
    final user = UserModel.fromJson(response.data['data']['user']);

    await _secureStorage.saveToken(authData.token);
    if (authData.refreshToken != null) {
      await _secureStorage.saveRefreshToken(authData.refreshToken!);
    }
    await _secureStorage.saveUser(jsonEncode(user.toJson()));

    return user;
  }

  Future<UserModel> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );

    final authData = AuthResponse.fromJson(response.data['data']['auth']);
    final user = UserModel.fromJson(response.data['data']['user']);

    await _secureStorage.saveToken(authData.token);
    if (authData.refreshToken != null) {
      await _secureStorage.saveRefreshToken(authData.refreshToken!);
    }
    await _secureStorage.saveUser(jsonEncode(user.toJson()));

    return user;
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      await _secureStorage.clearAll();
    }
  }

  Future<UserModel> getProfile() async {
    final response = await _dio.get(ApiConstants.profile);
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel?> getCachedUser() async {
    final userJson = await _secureStorage.getUser();
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<bool> isAuthenticated() async {
    return await _secureStorage.hasToken();
  }
}
