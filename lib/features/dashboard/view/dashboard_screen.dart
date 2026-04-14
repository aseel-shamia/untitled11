import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../course/viewmodel/course_viewmodel.dart';
import '../viewmodel/dashboard_viewmodel.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final myCoursesAsync = ref.watch(myCoursesProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardProvider);
          ref.read(myCoursesProvider.notifier).loadInitial();
        },
        child: CustomScrollView(
          slivers: [
            // Stats Cards
            SliverToBoxAdapter(
              child: dashboardAsync.when(
                data: (dashboard) => Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Streak & Points Row
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.local_fire_department,
                              iconColor: AppColors.accent,
                              title: '${dashboard.currentStreak}',
                              subtitle: 'Day Streak',
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accent.withValues(alpha: 0.1),
                                  AppColors.accent.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.emoji_events_rounded,
                              iconColor: AppColors.secondary,
                              title: '${dashboard.totalPoints}',
                              subtitle: 'Points',
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary.withValues(alpha: 0.1),
                                  AppColors.secondary.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Courses & Watch Time Row
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.book_rounded,
                              iconColor: AppColors.primary,
                              title: '${dashboard.completedCourses}/${dashboard.totalCourses}',
                              subtitle: 'Courses Done',
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.1),
                                  AppColors.primary.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.access_time_rounded,
                              iconColor: AppColors.success,
                              title: '${dashboard.totalWatchMinutes ~/ 60}h',
                              subtitle: 'Watch Time',
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.success.withValues(alpha: 0.1),
                                  AppColors.success.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Achievements
                      if (dashboard.achievements.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Achievements',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/achievements'),
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 80.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: dashboard.achievements.take(5).length,
                            separatorBuilder: (_, __) =>
                                SizedBox(width: 12.w),
                            itemBuilder: (_, index) {
                              final achievement =
                                  dashboard.achievements[index];
                              return _AchievementBadge(
                                title: achievement.title,
                                isUnlocked: achievement.isUnlocked,
                                points: achievement.points,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                loading: () => Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ShimmerLoading(
                              width: double.infinity,
                              height: 100.h,
                              borderRadius: 16,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ShimmerLoading(
                              width: double.infinity,
                              height: 100.h,
                              borderRadius: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                error: (err, _) => AppErrorWidget(
                  message: 'Failed to load dashboard',
                  onRetry: () => ref.invalidate(dashboardProvider),
                ),
              ),
            ),

            // My Courses Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                child: Text(
                  'My Courses',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // My Courses List
            myCoursesAsync.when(
              data: (courses) => courses.isEmpty
                  ? SliverToBoxAdapter(
                      child: AppEmptyWidget(
                        message: 'No courses yet. Start learning today!',
                        icon: Icons.school_rounded,
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList.separated(
                        itemCount: courses.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (_, index) {
                          final course = courses[index];
                          return CourseCardHorizontal(
                            title: course.title,
                            thumbnailUrl: course.thumbnailUrl,
                            teacherName: course.teacherName,
                            rating: course.rating,
                            progressPercent: course.progressPercent,
                            onTap: () =>
                                context.push('/courses/${course.id}'),
                          );
                        },
                      ),
                    ),
              loading: () => SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const ShimmerList(itemCount: 3),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: AppErrorWidget(
                  message: 'Failed to load courses',
                  onRetry: () =>
                      ref.read(myCoursesProvider.notifier).loadInitial(),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String title;
  final bool isUnlocked;
  final int points;

  const _AchievementBadge({
    required this.title,
    required this.isUnlocked,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.accent.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUnlocked
              ? AppColors.accent.withValues(alpha: 0.3)
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked
                ? Icons.emoji_events_rounded
                : Icons.lock_rounded,
            color: isUnlocked
                ? AppColors.accent
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
