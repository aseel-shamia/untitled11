import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../models/dashboard_model.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    ref.watch(dioProvider),
    ref.watch(localStorageProvider),
  );
});

class DashboardRepository {
  final Dio _dio;
  final LocalStorageService _localStorage;

  DashboardRepository(this._dio, this._localStorage);

  Future<DashboardModel> getDashboard() async {
    final response = await _dio.get(ApiConstants.dashboard);
    return DashboardModel.fromJson(response.data['data']);
  }

  Future<List<AchievementModel>> getAchievements() async {
    final response = await _dio.get(ApiConstants.achievements);
    return (response.data['data'] as List)
        .map((e) => AchievementModel.fromJson(e))
        .toList();
  }

  int getLocalStreak() {
    return _localStorage.getCurrentStreak();
  }

  Future<void> updateLocalStreak() async {
    await _localStorage.updateStreak();
  }
}
