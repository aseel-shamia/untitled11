import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          tertiary: AppColors.accent,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.textPrimaryLight,
          error: AppColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        cardColor: AppColors.cardLight,
        dividerColor: AppColors.dividerLight,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        cardTheme: CardTheme(
          color: AppColors.cardLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: AppColors.dividerLight, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundLight,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: TextStyle(
            color: AppColors.textTertiaryLight,
            fontSize: 14.sp,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.backgroundLight,
          selectedColor: AppColors.primary.withValues(alpha: 0.1),
          labelStyle: TextStyle(fontSize: 12.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          onPrimary: AppColors.backgroundDark,
          secondary: AppColors.secondaryLight,
          onSecondary: AppColors.backgroundDark,
          tertiary: AppColors.accent,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          error: AppColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.cardDark,
        dividerColor: AppColors.dividerDark,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textTertiaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        cardTheme: CardTheme(
          color: AppColors.cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: AppColors.dividerDark, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.backgroundDark,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            side: const BorderSide(color: AppColors.primaryLight),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundDark,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 14.sp,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
          labelStyle: TextStyle(fontSize: 12.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      );
}
