import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardModel with _$DashboardModel {
  const factory DashboardModel({
    @Default(0) @JsonKey(name: 'total_courses') int totalCourses,
    @Default(0) @JsonKey(name: 'completed_courses') int completedCourses,
    @Default(0) @JsonKey(name: 'in_progress_courses') int inProgressCourses,
    @Default(0) @JsonKey(name: 'total_points') int totalPoints,
    @Default(0) @JsonKey(name: 'current_streak') int currentStreak,
    @Default(0) @JsonKey(name: 'longest_streak') int longestStreak,
    @Default(0) @JsonKey(name: 'total_watch_minutes') int totalWatchMinutes,
    @Default([]) List<AchievementModel> achievements,
  }) = _DashboardModel;

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);
}

@freezed
class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    required int id,
    required String title,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @Default(false) @JsonKey(name: 'is_unlocked') bool isUnlocked,
    @JsonKey(name: 'unlocked_at') String? unlockedAt,
    @Default(0) int points,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}
