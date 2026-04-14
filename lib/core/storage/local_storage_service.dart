import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

class LocalStorageService {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.userBox);
    await Hive.openBox(AppConstants.coursesBox);
    await Hive.openBox(AppConstants.lessonsBox);
    await Hive.openBox(AppConstants.progressBox);
    await Hive.openBox(AppConstants.cacheBox);
  }

  // Generic cache methods
  Future<void> cacheData(String boxName, String key, dynamic data) async {
    final box = Hive.box(boxName);
    final cacheEntry = {
      'data': jsonEncode(data),
      'timestamp': DateTime.now().toIso8601String(),
    };
    await box.put(key, cacheEntry);
  }

  T? getCachedData<T>(
    String boxName,
    String key,
    T Function(dynamic) fromJson, {
    Duration maxAge = const Duration(hours: 1),
  }) {
    final box = Hive.box(boxName);
    final cached = box.get(key);

    if (cached == null) return null;

    final timestamp = DateTime.parse(cached['timestamp'] as String);
    if (DateTime.now().difference(timestamp) > maxAge) {
      box.delete(key);
      return null;
    }

    return fromJson(jsonDecode(cached['data'] as String));
  }

  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  Future<void> clearAll() async {
    await Hive.box(AppConstants.userBox).clear();
    await Hive.box(AppConstants.coursesBox).clear();
    await Hive.box(AppConstants.lessonsBox).clear();
    await Hive.box(AppConstants.progressBox).clear();
    await Hive.box(AppConstants.cacheBox).clear();
  }

  // Progress tracking
  Future<void> saveVideoProgress(String lessonId, Duration position) async {
    final box = Hive.box(AppConstants.progressBox);
    await box.put('video_$lessonId', position.inSeconds);
  }

  Duration? getVideoProgress(String lessonId) {
    final box = Hive.box(AppConstants.progressBox);
    final seconds = box.get('video_$lessonId') as int?;
    return seconds != null ? Duration(seconds: seconds) : null;
  }

  // Theme
  Future<void> saveThemeMode(String mode) async {
    final box = Hive.box(AppConstants.userBox);
    await box.put(AppConstants.themeKey, mode);
  }

  String? getThemeMode() {
    final box = Hive.box(AppConstants.userBox);
    return box.get(AppConstants.themeKey) as String?;
  }

  // Locale
  Future<void> saveLocale(String locale) async {
    final box = Hive.box(AppConstants.userBox);
    await box.put(AppConstants.localeKey, locale);
  }

  String? getLocale() {
    final box = Hive.box(AppConstants.userBox);
    return box.get(AppConstants.localeKey) as String?;
  }

  // Streak
  Future<void> updateStreak() async {
    final box = Hive.box(AppConstants.progressBox);
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastActive = box.get('last_active_date') as String?;
    final currentStreak = box.get('current_streak') as int? ?? 0;

    if (lastActive == today) return;

    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')[0];

    if (lastActive == yesterday) {
      await box.put('current_streak', currentStreak + 1);
    } else {
      await box.put('current_streak', 1);
    }

    await box.put('last_active_date', today);
  }

  int getCurrentStreak() {
    final box = Hive.box(AppConstants.progressBox);
    return box.get('current_streak') as int? ?? 0;
  }
}
