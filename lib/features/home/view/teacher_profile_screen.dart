import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../viewmodel/teacher_viewmodel.dart';

class TeacherProfileScreen extends ConsumerWidget {
  final int teacherId;

  const TeacherProfileScreen({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherDetailProvider(teacherId));
    final coursesAsync = ref.watch(teacherCoursesProvider(teacherId));

    return Scaffold(
      body: teacherAsync.when(
        data: (teacher) => CustomScrollView(
          slivers: [
            // Profile Header
            SliverAppBar(
              expandedHeight: 280.h,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: teacher.avatarUrl != null
                              ? ClipOval(
                                  child: AppCachedImage(
                                    imageUrl: teacher.avatarUrl,
                                    width: 96.w,
                                    height: 96.w,
                                    borderRadius: 48,
                                  ),
                                )
                              : Icon(Icons.person_rounded,
                                  size: 50.sp, color: Colors.white),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          teacher.name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          teacher.subjectName ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _StatItem(
                              value: teacher.rating.toStringAsFixed(1),
                              label: 'Rating',
                              icon: Icons.star_rounded,
                            ),
                            _divider(),
                            _StatItem(
                              value: '${teacher.studentsCount}',
                              label: 'Students',
                              icon: Icons.people_rounded,
                            ),
                            _divider(),
                            _StatItem(
                              value: '${teacher.coursesCount}',
                              label: 'Courses',
                              icon: Icons.book_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bio Section
            if (teacher.bio != null && teacher.bio!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        teacher.bio!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Courses Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            coursesAsync.when(
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
                      teacherName: teacher.name,
                      rating: course.rating,
                      onTap: () => context.push('/courses/${course.id}'),
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
                  onRetry: () => ref.invalidate(teacherCoursesProvider(teacherId)),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: 'Failed to load teacher profile',
          onRetry: () => ref.invalidate(teacherDetailProvider(teacherId)),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
