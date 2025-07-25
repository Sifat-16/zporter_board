import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zporter_board/app.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/services/random_service.dart';
import 'package:zporter_tactical_board/app/services/injection_container.dart'
    hide sl;

import 'config/database/local/sembastdb.dart';
import 'core/services/notification_service.dart';
import 'features/notification/data/data_source/notification_local_data_source_impl.dart';
import 'features/notification/data/model/notification_model.dart';
import 'firebase_options.dart';

const String kUnreadNotificationCountKey = 'unread_notification_count';

// // NEW: A unified helper function to parse the FCM message.
// NotificationModel parseRemoteMessage(RemoteMessage message) {
//   final notification = message.notification;
//
//   // Extract media URLs from the data payload
//   List<String>? mediaUrls;
//   if (message.data.containsKey('mediaUrls')) {
//     try {
//       mediaUrls = List<String>.from(jsonDecode(message.data['mediaUrls']));
//     } catch (e) {
//       print('Error decoding mediaUrls: $e');
//     }
//   }
//
//   return NotificationModel(
//     id: message.messageId ?? RandomGenerator.generateId(),
//     title: notification?.title ?? 'No Title',
//     body: notification?.body ?? 'No Body',
//     sentTime: message.sentTime ?? DateTime.now(),
//     category: message.data['category'] ?? 'general',
//     isRead: false,
//     // Extract the cover image from the platform-specific notification object
//     coverImageUrl: defaultTargetPlatform == TargetPlatform.android
//         ? notification?.android?.imageUrl
//         : notification?.apple?.imageUrl,
//     mediaUrls: mediaUrls,
//   );
// }

// NEW: A unified helper function to parse the FCM message.
NotificationModel parseRemoteMessage(RemoteMessage message) {
  final notification = message.notification;

  // Extract media URLs from the data payload
  List<String>? mediaUrls;
  if (message.data.containsKey('mediaUrls')) {
    try {
      mediaUrls = List<String>.from(jsonDecode(message.data['mediaUrls']));
    } catch (e) {
      print('Error decoding mediaUrls: $e');
    }
  }

  // --- THE FIX IS HERE ---
  // We make the ID more robust by combining the messageId with the sentTime.
  // If messageId is null, we use the current time to ensure a unique key.
  final uniqueId = message.messageId ??
      (message.sentTime ?? DateTime.now()).millisecondsSinceEpoch.toString();

  return NotificationModel(
    id: uniqueId,
    title: notification?.title ?? 'No Title',
    body: notification?.body ?? 'No Body',
    sentTime: message.sentTime ?? DateTime.now(),
    category: message.data['category'] ?? 'general',
    isRead: false,
    coverImageUrl: defaultTargetPlatform == TargetPlatform.android
        ? notification?.android?.imageUrl
        : notification?.apple?.imageUrl,
    mediaUrls: mediaUrls,
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Use the new helper function to create the model
  final newNotification = parseRemoteMessage(message);

  // Manually initialize services and save the notification
  final sembastDb = await SembastDb().database;
  final localDataSource = NotificationLocalDataSourceImpl(sembastDb);
  await localDataSource.cacheNotification(newNotification);

  // Manually update the unread count in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final currentCount = prefs.getInt(kUnreadNotificationCountKey) ?? 0;
  await prefs.setInt(kUnreadNotificationCountKey, currentCount + 1);

  print("Background notification with media data saved.");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Or a specific limit
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await initializeTacticBoardDependencies();
  await init();
  await sl<NotificationService>().initialize();

  //Force landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((v) {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) {
          return ProviderScope(child: const App());
        },
      ),
    );
  });
}
