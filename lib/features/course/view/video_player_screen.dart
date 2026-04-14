import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player/better_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/course_viewmodel.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final int lessonId;
  final String? videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.lessonId,
    this.videoUrl,
    required this.title,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late BetterPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initPlayer();
  }

  void _initPlayer() {
    final savedPosition = ref.read(videoProgressProvider(widget.lessonId));

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: BetterPlayerTheme.material,
        enableProgressBar: true,
        enablePlayPause: true,
        enableMute: true,
        enableFullscreen: true,
        enableSkips: true,
        enablePlaybackSpeed: true,
        skipForwardIcon: Icons.forward_10_rounded,
        skipBackIcon: Icons.replay_10_rounded,
        controlBarColor: Colors.black54,
        progressBarPlayedColor: AppColors.primary,
        progressBarHandleColor: AppColors.primary,
        progressBarBufferedColor: AppColors.primary.withValues(alpha: 0.3),
      ),
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      autoDetectFullscreenAspectRatio: true,
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl ?? '',
      videoFormat: BetterPlayerVideoFormat.hls,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 100 * 1024 * 1024, // 100MB
        maxCacheFileSize: 20 * 1024 * 1024, // 20MB
      ),
    );

    _controller = BetterPlayerController(betterPlayerConfiguration);
    _controller.setupDataSource(dataSource);

    _controller.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        setState(() => _isInitialized = true);
        // Resume playback from saved position
        if (savedPosition.inSeconds > 0) {
          _showResumeDialog(savedPosition);
        }
      }

      // Save progress periodically
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        final position = _controller.videoPlayerController?.value.position;
        if (position != null && position.inSeconds % 10 == 0) {
          ref
              .read(videoProgressProvider(widget.lessonId).notifier)
              .updateProgress(position);
        }
      }

      // Mark as completed
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        final duration =
            _controller.videoPlayerController?.value.duration;
        if (duration != null) {
          ref
              .read(videoProgressProvider(widget.lessonId).notifier)
              .updateProgress(duration);
        }
      }
    });
  }

  void _showResumeDialog(Duration savedPosition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resume Playback'),
        content: Text(
          'Resume from ${_formatDuration(savedPosition)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Start Over'),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.seekTo(savedPosition);
              Navigator.pop(ctx);
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    // Save final position
    final position = _controller.videoPlayerController?.value.position;
    if (position != null) {
      ref
          .read(videoProgressProvider(widget.lessonId).notifier)
          .updateProgress(position);
    }
    _controller.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
      body: Column(
        children: [
          // Video Player
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _controller),
          ),

          // Video info
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Speed selector
                  if (_isInitialized) ...[
                    Text(
                      'Playback Speed',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                          .map(
                            (speed) => ChoiceChip(
                              label: Text('${speed}x'),
                              selected: false,
                              onSelected: (_) {
                                _controller.setSpeed(speed);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
