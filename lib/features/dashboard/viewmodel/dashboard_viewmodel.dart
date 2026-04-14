import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/dashboard_model.dart';
import '../data/repositories/dashboard_repository.dart';

final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  await repo.updateLocalStreak();
  return repo.getDashboard();
});

final achievementsProvider =
    FutureProvider<List<AchievementModel>>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getAchievements();
});
