import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(localStorageProvider));
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageService _storage;

  ThemeModeNotifier(this._storage) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _storage.getThemeMode();
    switch (saved) {
      case 'light':
        state = ThemeMode.light;
      case 'dark':
        state = ThemeMode.dark;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode.name);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // User Profile Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      size: 30.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Student',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                    icon: const Icon(Icons.edit_rounded),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Theme Section
          _SectionTitle(title: 'Appearance'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.brightness_6_rounded,
                  title: 'Theme',
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.phone_android),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (modes) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(modes.first);
                    },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailing: Text(
                    'English',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {
                    // TODO: Show language picker
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Notifications Section
          _SectionTitle(title: 'Notifications'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  title: 'Push Notifications',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle notifications
                    },
                  ),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.alarm_rounded,
                  title: 'Study Reminders',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Toggle reminders
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // About Section
          _SectionTitle(title: 'About'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Tawjihi',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Logout Button
          SizedBox(
            height: 52.h,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content:
                        const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                }
              },
              icon: Icon(Icons.logout_rounded, color: AppColors.error),
              label: Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Version
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right_rounded, size: 22.sp)
              : null),
    );
  }
}
