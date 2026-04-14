import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          height: 65.h,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 24.sp),
              selectedIcon: Icon(Icons.home_rounded,
                  size: 24.sp, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined, size: 24.sp),
              selectedIcon: Icon(Icons.book_rounded,
                  size: 24.sp, color: AppColors.primary),
              label: 'My Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, size: 24.sp),
              selectedIcon: Icon(Icons.dashboard_rounded,
                  size: 24.sp, color: AppColors.primary),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: 24.sp),
              selectedIcon: Icon(Icons.settings_rounded,
                  size: 24.sp, color: AppColors.primary),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
