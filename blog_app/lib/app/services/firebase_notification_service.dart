// ///
// /// Firebase Notification Service
// /// Handles both local notifications and Firebase Cloud Messaging (FCM)
// ///
// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FirebaseNotificationService extends GetxService {
//   static final FirebaseNotificationService _instance =
//       FirebaseNotificationService._internal();

//   factory FirebaseNotificationService() => _instance;

//   FirebaseNotificationService._internal();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   // Observable state
//   final fcmToken = ''.obs;
//   final isTokenRefreshed = false.obs;
//   final notificationPermission = false.obs;

//   /// Initialize the notification service
//   Future<void> init() async {
//     // Initialize local notifications
//     await _initLocalNotifications();

//     // Request permissions
//     await _requestPermissions();

//     // Get FCM token
//     await _getFCMToken();

//     // Setup message handlers
//     await _setupMessageHandlers();

//     // Handle token refresh
//     _messaging.onTokenRefresh.listen((newToken) {
//       fcmToken.value = newToken;
//       isTokenRefreshed.value = true;
//       _saveTokenToServer(newToken);
//       print('🔄 FCM Token refreshed: $newToken');
//     });
//   }

//   // ============================================================
//   // LOCAL NOTIFICATIONS
//   // ============================================================

//   /// Initialize local notifications plugin
//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
//         );

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
//     );
//   }

//   /// Request notification permissions
//   Future<void> _requestPermissions() async {
//     // For Android 13+
//     if (await _isAndroidVersionAbove(33)) {
//       final status = await Permission.notification.request();
//       notificationPermission.value = status.isGranted;
//     }

//     // Request iOS permissions
//     final iosPermission = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );

//     notificationPermission.value =
//         iosPermission.authorizationStatus == AuthorizationStatus.authorized;
//   }

//   /// Get FCM token
//   Future<void> _getFCMToken() async {
//     try {
//       final token = await _messaging.getToken();
//       fcmToken.value = token ?? '';
//       print('📱 FCM Token: ${fcmToken.value}');
//     } catch (e) {
//       print('❌ Error getting FCM token: $e');
//     }
//   }

//   /// Save token to your server
//   Future<void> _saveTokenToServer(String token) async {
//     // TODO: Implement API call to save token
//     print('💾 Saving token to server: $token');
//   }

//   // ============================================================
//   // MESSAGE HANDLERS
//   // ============================================================

//   /// Setup all message handlers
//   Future<void> _setupMessageHandlers() async {
//     // Foreground message handler
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Background message handler (when app is terminated)
//     FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

//     // Message when app is opened from terminated state
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }

//     // Message when app is in background and opened
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }

//   /// Handle foreground messages
//   void _handleForegroundMessage(RemoteMessage message) {
//     print('📨 Foreground message received');

//     // Show local notification
//     _showLocalNotificationFromMessage(message);

//     // Handle in-app notification
//     _handleInAppNotification(message);
//   }

//   /// Handle background messages (static method)
//   @pragma('vm:entry-point')
//   static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     print('📨 Background message received');
//     // You can show local notification here if needed
//   }

//   /// Handle message when app is opened
//   void _handleMessage(RemoteMessage message) {
//     print('📨 Message opened from: ${message.from}');
//     _navigateToScreen(message);
//   }

//   // ============================================================
//   // LOCAL NOTIFICATION HELPERS
//   // ============================================================

//   /// Show local notification from FCM message
//   Future<void> _showLocalNotificationFromMessage(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;

//     final data = message.data;

//     await _localNotifications.show(
//       DateTime.now().millisecond,
//       notification.title ?? 'Notification',
//       notification.body ?? '',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'fcm_channel',
//           'FCM Notifications',
//           channelDescription: 'Firebase Cloud Messaging notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       payload: jsonEncode(data),
//     );
//   }

//   /// Show local notification from your app
//   Future<void> showLocalNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const NotificationDetails details = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'blog_channel',
//         'Blog Notifications',
//         channelDescription: 'Notifications from Blog App',
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: true,
//         enableLights: true,
//         enableVibration: true,
//         playSound: true,
//         icon: '@mipmap/ic_launcher',
//       ),
//       iOS: DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       ),
//     );

//     await _localNotifications.show(id, title, body, details, payload: payload);
//   }

//   // ============================================================
//   // NOTIFICATION HANDLERS
//   // ============================================================

//   /// Handle tap on local notification
//   void _onDidReceiveNotificationResponse(NotificationResponse response) {
//     final payload = response.payload;
//     if (payload != null) {
//       try {
//         final data = jsonDecode(payload);
//         _handleNotificationPayload(data);
//       } catch (e) {
//         _handleNotificationPayload(payload);
//       }
//     }
//   }

//   /// Handle local notification tap (iOS)
//   void _onDidReceiveLocalNotification(
//     int id,
//     String? title,
//     String? body,
//     String? payload,
//   ) {
//     if (payload != null) {
//       try {
//         final data = jsonDecode(payload);
//         _handleNotificationPayload(data);
//       } catch (e) {
//         _handleNotificationPayload(payload);
//       }
//     }
//   }

//   /// Handle notification payload
//   void _handleNotificationPayload(dynamic payload) {
//     if (payload is Map) {
//       final type = payload['type'] ?? payload['notification_type'];
//       final postId = payload['post_id'];
//       final commentId = payload['comment_id'];

//       switch (type) {
//         case 'post_created':
//         case 'post_updated':
//         case 'post_deleted':
//         case 'new_comment':
//           if (postId != null) {
//             Get.toNamed('/post-details', arguments: {'postId': postId});
//           }
//           break;
//         case 'comment_added':
//           if (commentId != null) {
//             Get.toNamed('/comments', arguments: {'postId': postId});
//           }
//           break;
//         default:
//           Get.snackbar(
//             'Notification',
//             'You have a new notification',
//             snackPosition: SnackPosition.BOTTOM,
//             duration: const Duration(seconds: 3),
//           );
//       }
//     } else if (payload is String) {
//       _handleNotificationTap(payload);
//     }
//   }

//   /// Handle simple string payload
//   void _handleNotificationTap(String payload) {
//     switch (payload) {
//       case 'post_created':
//         Get.snackbar(
//           'Success 🎉',
//           'Post created successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: Colors.green.shade50,
//           colorText: Colors.green.shade700,
//         );
//         break;
//       case 'post_updated':
//         Get.snackbar(
//           'Success ✏️',
//           'Post updated successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: Colors.blue.shade50,
//           colorText: Colors.blue.shade700,
//         );
//         break;
//       case 'post_deleted':
//         Get.snackbar(
//           'Success 🗑️',
//           'Post deleted successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: Colors.red.shade50,
//           colorText: Colors.red.shade700,
//         );
//         break;
//       case 'comment_added':
//         Get.snackbar(
//           'Success 💬',
//           'Comment added successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: Colors.purple.shade50,
//           colorText: Colors.purple.shade700,
//         );
//         break;
//       default:
//         Get.snackbar(
//           'Notification',
//           'You have a new notification',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//         );
//     }
//   }

//   /// Handle in-app notification (show snackbar)
//   void _handleInAppNotification(RemoteMessage message) {
//     final notification = message.notification;
//     if (notification == null) return;

//     Get.snackbar(
//       notification.title ?? 'Notification',
//       notification.body ?? '',
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 4),
//       backgroundColor: Colors.blue.shade50,
//       colorText: Colors.blue.shade700,
//       margin: const EdgeInsets.all(12),
//       borderRadius: 12,
//       onTap: (_) {
//         _handleMessage(message);
//       },
//     );
//   }

//   /// Navigate to screen based on message
//   void _navigateToScreen(RemoteMessage message) {
//     final data = message.data;
//     final type = data['type'] ?? data['notification_type'];
//     final postId = data['post_id'];
//     final commentId = data['comment_id'];

//     switch (type) {
//       case 'post_created':
//       case 'post_updated':
//       case 'post_deleted':
//       case 'new_comment':
//         if (postId != null) {
//           Get.toNamed('/post-details', arguments: {'postId': postId});
//         }
//         break;
//       case 'comment_added':
//         if (commentId != null) {
//           Get.toNamed('/comments', arguments: {'postId': postId});
//         }
//         break;
//       default:
//         Get.snackbar(
//           'Notification',
//           'You have a new notification',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//         );
//     }
//   }

//   // ============================================================
//   // HELPER METHODS
//   // ============================================================

//   /// Send a test notification
//   Future<void> sendTestNotification() async {
//     await showLocalNotification(
//       id: DateTime.now().millisecondsSinceEpoch % 100000,
//       title: 'Test Notification',
//       body: 'This is a test notification from your app!',
//       payload: 'test',
//     );
//   }

//   /// Send notification for post creation
//   Future<void> showPostCreatedNotification(String postTitle) async {
//     await showLocalNotification(
//       id: DateTime.now().millisecondsSinceEpoch % 100000,
//       title: 'Post Created! 🎉',
//       body: 'Your post "$postTitle" has been created.',
//       payload: 'post_created',
//     );
//   }

//   /// Send notification for post update
//   Future<void> showPostUpdatedNotification(String postTitle) async {
//     await showLocalNotification(
//       id: DateTime.now().millisecondsSinceEpoch % 100000,
//       title: 'Post Updated! ✏️',
//       body: 'Your post "$postTitle" has been updated.',
//       payload: 'post_updated',
//     );
//   }

//   /// Send notification for post deletion
//   Future<void> showPostDeletedNotification(String postTitle) async {
//     await showLocalNotification(
//       id: DateTime.now().millisecondsSinceEpoch % 100000,
//       title: 'Post Deleted! 🗑️',
//       body: 'Your post "$postTitle" has been deleted.',
//       payload: 'post_deleted',
//     );
//   }

//   /// Send notification for comment
//   Future<void> showCommentAddedNotification() async {
//     await showLocalNotification(
//       id: DateTime.now().millisecondsSinceEpoch % 100000,
//       title: 'Comment Added! 💬',
//       body: 'Your comment has been added.',
//       payload: 'comment_added',
//     );
//   }

//   /// Cancel a specific notification
//   Future<void> cancelNotification(int id) async {
//     await _localNotifications.cancel(id);
//   }

//   /// Cancel all notifications
//   Future<void> cancelAllNotifications() async {
//     await _localNotifications.cancelAll();
//   }

//   /// Check if app is running on Android
//   bool get isAndroid => GetPlatform.isAndroid;

//   /// Check if app is running on iOS
//   bool get isIOS => GetPlatform.isIOS;

//   /// Check Android version
//   Future<bool> _isAndroidVersionAbove(int minVersion) async {
//     // Simplified - in production use device_info_plus
//     return true;
//   }
// }
