import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final subjects = ref.watch(subjectsProvider);
    final featuredTeachers = ref.watch(featuredTeachersProvider);
    final recommendedCourses = ref.watch(recommendedCoursesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(subjectsProvider);
          ref.invalidate(featuredTeachersProvider);
          ref.read(recommendedCoursesProvider.notifier).loadInitial();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              expandedHeight: 120.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 16.h),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  user?.name ?? 'Student',
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Streak badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.local_fire_department,
                                    color: AppColors.accent, size: 18.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  '${user?.currentStreak ?? 0}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => context.push('/settings'),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              child: Icon(Icons.person_rounded,
                                  color: Colors.white, size: 22.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Search courses, teachers...',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Subjects Grid
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Subjects',
                onSeeAll: () => context.push('/subjects'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110.h,
                child: subjects.when(
                  data: (data) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, index) {
                      final subject = data[index];
                      return GestureDetector(
                        onTap: () =>
                            context.push('/subjects/${subject.id}'),
                        child: Container(
                          width: 90.w,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.book_rounded,
                                  color: AppColors.primary,
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                subject.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 5,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, __) => ShimmerLoading(
                      width: 90.w,
                      height: 100.h,
                      borderRadius: 16,
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error loading subjects'),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

            // Featured Teachers
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Featured Teachers',
                onSeeAll: () => context.push('/teachers'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 170.h,
                child: featuredTeachers.when(
                  data: (data) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, index) {
                      final teacher = data[index];
                      return GestureDetector(
                        onTap: () =>
                            context.push('/teachers/${teacher.id}'),
                        child: Container(
                          width: 140.w,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30.r,
                                backgroundColor:
                                    AppColors.secondary.withValues(alpha: 0.1),
                                child: Icon(Icons.person_rounded,
                                    size: 30.sp,
                                    color: AppColors.secondary),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                teacher.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                teacher.subjectName ?? '',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star_rounded,
                                      size: 14.sp,
                                      color: AppColors.accent),
                                  SizedBox(width: 2.w),
                                  Text(
                                    teacher.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (_, __) => ShimmerLoading(
                      width: 140.w,
                      height: 160.h,
                      borderRadius: 16,
                    ),
                  ),
                  error: (err, _) =>
                      Center(child: Text('Error loading teachers')),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

            // Recommended Courses
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Recommended For You',
                onSeeAll: () => context.push('/courses'),
              ),
            ),
            recommendedCourses.when(
              data: (courses) => SliverPadding(
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
                      progressPercent: course.isEnrolled
                          ? course.progressPercent
                          : null,
                      onTap: () =>
                          context.push('/courses/${course.id}'),
                    );
                  },
                ),
              ),
              loading: () => SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList.separated(
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, __) => ShimmerLoading(
                    width: double.infinity,
                    height: 90.h,
                    borderRadius: 12,
                  ),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: AppErrorWidget(
                  message: 'Failed to load courses',
                  onRetry: () => ref
                      .read(recommendedCoursesProvider.notifier)
                      .loadInitial(),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
