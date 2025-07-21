import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/services/random_service.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_event.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

import 'navigation_service.dart';

/// A service that handles all Firebase Cloud Messaging (FCM) logic.
///
/// This service is responsible for initializing FCM, requesting notification
/// permissions, handling incoming messages, and managing topic subscriptions.
class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  RemoteMessage? initialMessage;
  // ⭐️ ADD THIS REPOSITORY
  // final NotificationRepository _notificationRepository;

  NotificationService(
    this._firebaseMessaging,
    this._localNotificationsPlugin,
    // this._notificationRepository,
  );

  /// Initializes the notification service.
  ///
  /// This configures FCM listeners and requests permissions. It should be
  /// called on app startup.
  Future<void> initialize() async {
    initialMessage = await _firebaseMessaging.getInitialMessage();
    await _requestPermissions();
    await _configureForegroundNotifications();
    _configureMessageListeners();
    // ⭐️ ADD THIS CALL TO SYNC SUBSCRIPTIONS ON STARTUP
    await _syncInitialTopicSubscriptions();
    print("Notification Service Initialized FCM token ${await getFCMToken()}");
  }

  Future<void> _syncInitialTopicSubscriptions() async {
    try {
      print('Syncing initial topic subscriptions...');
      final NotificationRepository _notificationRepository =
          sl.get<NotificationRepository>();
      final settings = await _notificationRepository.getNotificationSettings();
      for (final entry in settings.entries) {
        // If the setting is true (e.g., {'zporter_news': true}), subscribe.
        if (entry.value) {
          zlog(data: "Subscribing to topic ${entry.key}");
          await subscribeToTopic(entry.key);
        }
      }
    } catch (e) {
      print('Error syncing topic subscriptions: $e');
    }
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
      _saveNotification(message);
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
    // THE FIX IS HERE
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.notification?.title}');

      // Use a short delay to ensure the UI is ready after the app resumes.
      WidgetsBinding.instance.addPostFrameCallback((t) {
        NavigationService.instance.scaffoldKey.currentState?.openEndDrawer();
      });
    });
  }

  // NEW METHOD: Handles creating and saving the notification model
  Future<void> _saveNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final NotificationRepository _notificationRepository =
        sl.get<NotificationRepository>();
    final newNotification = NotificationModel(
      // Use a random ID for simplicity, or get one from the message data payload
      id: RandomGenerator.generateId(),
      title: notification.title ?? 'No Title',
      body: notification.body ?? 'No Body',
      sentTime: message.sentTime ?? DateTime.now(),
      // You should send the category in the `data` payload from your admin panel
      category: message.data['category'] ?? 'general',
      isRead: false,
    );

    await _notificationRepository.saveNotification(newNotification);

    // Tell the notification drawer to refresh its list
    if (sl.isRegistered<NotificationBloc>()) {
      sl<NotificationBloc>().add(NotificationsUpdated());
    }
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
