import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'Default Notifications',
        channelDescription: 'Default channel for app notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // 

  Future<void> showPostCreatedNotification(String postTitle) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Post Created! 🎉',
      body: 'Your post "$postTitle" has been created.',
      payload: 'post_created',
    );
  }

  Future<void> showPostUpdatedNotification(String postTitle) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Post Updated! ✏️',
      body: 'Your post "$postTitle" has been updated.',
      payload: 'post_updated',
    );
  }

Future<void> showPostDeletedNotification(String postTitle) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Post Deleted 🗑️',
      body: 'Your post "$postTitle" has been deleted.',
      payload: 'post_deleted',
    );
  }

  Future<void> showWelcomeNotification(String userName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Welcome Back! 👋',
      body: 'Hello $userName, welcome back to Blog App!',
      payload: 'welcome',
    );
  }

  // 

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
