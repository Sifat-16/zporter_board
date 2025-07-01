import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_event.dart';

/// A service that handles all Firebase Cloud Messaging (FCM) logic.
///
/// This service is responsible for initializing FCM, requesting notification
/// permissions, handling incoming messages, and managing topic subscriptions.
class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  NotificationService(this._firebaseMessaging, this._localNotificationsPlugin);

  /// Initializes the notification service.
  ///
  /// This configures FCM listeners and requests permissions. It should be
  /// called on app startup.
  Future<void> initialize() async {
    await _requestPermissions();
    await _configureForegroundNotifications();
    _configureMessageListeners();
    print("Notification Service Initialized FCM token ${await getFCMToken()}");
  }

  /// Requests notification permissions from the user.
  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  /// Configures local notifications for foreground messages on Android.
  Future<void> _configureForegroundNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Configures the listeners for incoming FCM messages.
  void _configureMessageListeners() {
    // Handles messages received while the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message Received: ${message.notification?.title}");
      // Add event to update the unread count
      sl<UnreadCountBloc>().add(IncrementUnreadCount());

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If it's a foreground notification on Android, display it using the local notifications plugin.
      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              icon: 'launch_background', // Ensure you have this drawable
            ),
          ),
        );
      }
    });

    // Handles messages that open the app from a background/terminated state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.notification?.title}');
      // Here you would typically navigate to the notification screen.
      // We will implement navigation later.
    });
  }

  /// Retrieves the unique FCM token for the device.
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }

  /// Subscribes the user to a specific notification topic.
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  /// Unsubscribes the user from a specific notification topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}
