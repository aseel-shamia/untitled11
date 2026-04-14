import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import 'app_cached_image.dart';
import 'progress_indicator_widget.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String? thumbnailUrl;
  final String? teacherName;
  final double? rating;
  final int? lessonsCount;
  final int? progressPercent;
  final bool isEnrolled;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    this.thumbnailUrl,
    this.teacherName,
    this.rating,
    this.lessonsCount,
    this.progressPercent,
    this.isEnrolled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            AppCachedImage(
              imageUrl: thumbnailUrl,
              width: double.infinity,
              height: 140.h,
              borderRadius: 0,
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Teacher name
                  if (teacherName != null)
                    Text(
                      teacherName!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  SizedBox(height: 8.h),

                  // Rating & Lessons
                  Row(
                    children: [
                      if (rating != null) ...[
                        Icon(Icons.star_rounded,
                            size: 16.sp, color: AppColors.accent),
                        SizedBox(width: 4.w),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      if (lessonsCount != null) ...[
                        Icon(Icons.play_circle_outline,
                            size: 16.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant),
                        SizedBox(width: 4.w),
                        Text(
                          '$lessonsCount lessons',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Progress
                  if (isEnrolled && progressPercent != null) ...[
                    SizedBox(height: 8.h),
                    ProgressIndicatorWidget(
                      progress: progressPercent! / 100,
                      showLabel: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCardHorizontal extends StatelessWidget {
  final String title;
  final String? thumbnailUrl;
  final String? teacherName;
  final double? rating;
  final int? progressPercent;
  final VoidCallback? onTap;

  const CourseCardHorizontal({
    super.key,
    required this.title,
    this.thumbnailUrl,
    this.teacherName,
    this.rating,
    this.progressPercent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              AppCachedImage(
                imageUrl: thumbnailUrl,
                width: 100.w,
                height: 70.h,
                borderRadius: 8,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (teacherName != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        teacherName!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (progressPercent != null) ...[
                      SizedBox(height: 6.h),
                      ProgressIndicatorWidget(
                        progress: progressPercent! / 100,
                        height: 4,
                        showLabel: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
