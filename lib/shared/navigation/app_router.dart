import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/course/view/course_screen.dart';
import '../../features/course/view/quiz_screen.dart';
import '../../features/course/view/video_player_screen.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/home/view/teacher_profile_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../navigation/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main Shell with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // My Courses Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-courses',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Settings Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Detail Routes (outside shell)
      GoRoute(
        path: '/teachers/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TeacherProfileScreen(teacherId: id);
        },
      ),
      GoRoute(
        path: '/courses/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CourseScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/lessons/:lessonId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          final extra = state.extra as Map<String, dynamic>?;
          return VideoPlayerScreen(
            lessonId: lessonId,
            videoUrl: extra?['videoUrl'] as String?,
            title: extra?['title'] as String? ?? 'Lesson',
          );
        },
      ),
      GoRoute(
        path: '/lessons/:lessonId/quiz',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          return QuizScreen(lessonId: lessonId);
        },
      ),
    ],
  );
});
