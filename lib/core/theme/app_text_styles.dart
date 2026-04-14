import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get displayLarge => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        height: 1.2,
      );

  static TextStyle get displayMedium => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        height: 1.2,
      );

  static TextStyle get headlineLarge => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        height: 1.3,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get titleLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle get labelLarge => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelMedium => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelSmall => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.5,
      );
}
