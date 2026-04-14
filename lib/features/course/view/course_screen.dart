import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../viewmodel/course_viewmodel.dart';

class CourseScreen extends ConsumerWidget {
  final int courseId;

  const CourseScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final lessonsAsync = ref.watch(courseLessonsProvider(courseId));

    return Scaffold(
      body: courseAsync.when(
        data: (course) => CustomScrollView(
          slivers: [
            // Course Header
            SliverAppBar(
              expandedHeight: 220.h,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  course.title,
                  style: TextStyle(fontSize: 16.sp),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppCachedImage(
                      imageUrl: course.thumbnailUrl,
                      borderRadius: 0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Course Info
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teacher info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          child: Icon(Icons.person_rounded, size: 20.sp),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.teacherName ?? 'Teacher',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                course.subjectName ?? '',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (course.teacherId != null)
                          TextButton(
                            onPressed: () => context
                                .push('/teachers/${course.teacherId}'),
                            child: const Text('View Profile'),
                          ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Stats
                    Row(
                      children: [
                        _CourseStatChip(
                          icon: Icons.star_rounded,
                          label: course.rating.toStringAsFixed(1),
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 8.w),
                        _CourseStatChip(
                          icon: Icons.people_rounded,
                          label: '${course.studentsCount} students',
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8.w),
                        _CourseStatChip(
                          icon: Icons.play_circle_rounded,
                          label: '${course.lessonsCount} lessons',
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Description
                    if (course.description != null) ...[
                      Text(
                        'About this course',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        course.description!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Progress
                    if (course.isEnrolled) ...[
                      ProgressIndicatorWidget(
                        progress: course.progressPercent / 100,
                        showLabel: true,
                        height: 10,
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Lessons header
                    Text(
                      'Lessons',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Lessons List
            lessonsAsync.when(
              data: (lessons) => SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList.separated(
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, index) {
                    final lesson = lessons[index];
                    final isAccessible = course.isEnrolled || lesson.isFree;

                    return _LessonTile(
                      index: index + 1,
                      title: lesson.title,
                      duration: _formatDuration(lesson.durationSeconds),
                      isCompleted: lesson.isCompleted,
                      isFree: lesson.isFree,
                      isLocked: !isAccessible,
                      hasQuiz: lesson.hasQuiz,
                      onTap: isAccessible
                          ? () => context.push(
                                '/courses/$courseId/lessons/${lesson.id}',
                              )
                          : null,
                    );
                  },
                ),
              ),
              loading: () => SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const ShimmerList(itemCount: 5, itemHeight: 70),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: AppErrorWidget(
                  message: 'Failed to load lessons',
                  onRetry: () =>
                      ref.invalidate(courseLessonsProvider(courseId)),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: 'Failed to load course',
          onRetry: () => ref.invalidate(courseDetailProvider(courseId)),
        ),
      ),
      // Enroll Button (sticky bottom)
      bottomNavigationBar: courseAsync.whenOrNull(
        data: (course) => course.isEnrolled
            ? null
            : Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(enrollCourseProvider(courseId));
                        ref.invalidate(courseDetailProvider(courseId));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.school_rounded),
                          SizedBox(width: 8.w),
                          Text(
                            course.price != null && course.price! > 0
                                ? 'Enroll - \$${course.price!.toStringAsFixed(2)}'
                                : 'Enroll Now - Free',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }
}

class _CourseStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CourseStatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final int index;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isFree;
  final bool isLocked;
  final bool hasQuiz;
  final VoidCallback? onTap;

  const _LessonTile({
    required this.index,
    required this.title,
    required this.duration,
    this.isCompleted = false,
    this.isFree = false,
    this.isLocked = false,
    this.hasQuiz = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: 0.5)
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Row(
            children: [
              // Index circle
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success
                      : isLocked
                          ? Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                          : AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(Icons.check_rounded,
                          size: 18.sp, color: Colors.white)
                      : isLocked
                          ? Icon(Icons.lock_rounded,
                              size: 16.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)
                          : Text(
                              '$index',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isLocked
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                        if (hasQuiz) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Quiz',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                        if (isFree) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Free',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_outline_rounded,
                color: isLocked
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : AppColors.primary,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
