import 'package:flutter/material.dart';

class AppConstants {
  const AppConstants._();

  static const String appName = 'Tawjihi';
  static const String fontFamily = 'Cairo';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingKey = 'onboarding_complete';
  static const String lastSyncKey = 'last_sync';

  // Hive Boxes
  static const String userBox = 'user_box';
  static const String coursesBox = 'courses_box';
  static const String lessonsBox = 'lessons_box';
  static const String progressBox = 'progress_box';
  static const String cacheBox = 'cache_box';

  // Pagination
  static const int pageSize = 20;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Supported Locales
  static const Locale arabicLocale = Locale('ar');
  static const Locale englishLocale = Locale('en');
  static const List<Locale> supportedLocales = [arabicLocale, englishLocale];
}
