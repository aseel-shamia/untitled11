import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    const channel = AndroidNotificationChannel(
      'tawjihi_channel',
      'Tawjihi Notifications',
      description: 'Notifications for Tawjihi learning app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Subscribe to topics
    await _messaging.subscribeToTopic('all_students');
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Future<void> subscribeToCourseTopic(int courseId) async {
    await _messaging.subscribeToTopic('course_$courseId');
  }

  Future<void> unsubscribeFromCourseTopic(int courseId) async {
    await _messaging.unsubscribeFromTopic('course_$courseId');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'tawjihi_channel',
          'Tawjihi Notifications',
          channelDescription: 'Notifications for Tawjihi learning app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'],
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Handle navigation based on data
    final route = message.data['route'] as String?;
    if (route != null) {
      // Navigation will be handled by the app
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    final route = response.payload;
    if (route != null) {
      // Navigation will be handled by the app
    }
  }

  // Schedule study reminder
  Future<void> scheduleStudyReminder({
    required int hour,
    required int minute,
  }) async {
    // TODO: Implement scheduled local notification
  }
}
