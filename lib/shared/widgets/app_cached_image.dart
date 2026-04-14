import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shimmer_loading.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => ShimmerLoading(
          width: width ?? double.infinity,
          height: height ?? 120.h,
          borderRadius: borderRadius,
        ),
        errorWidget: (_, __, ___) => _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 32.sp,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
