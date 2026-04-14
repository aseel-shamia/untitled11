import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showLabel;

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showLabel)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              '${(clampedProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: progressColor ?? AppColors.primary,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clampedProgress,
            minHeight: height.h,
            backgroundColor: backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
