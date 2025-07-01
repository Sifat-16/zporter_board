import 'package:shared_preferences/shared_preferences.dart';
import 'package:zporter_board/core/services/notification_service.dart';
import 'package:zporter_board/features/notification/data/data_source/notification_local_data_source.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// The concrete implementation of the [NotificationRepository].
///
/// This class acts as a single source of truth for notification data. It
/// coordinates between the local data source (for caching) and the notification
/// service (for handling FCM topic subscriptions). It also uses SharedPreferences
/// to persist the user's notification settings locally.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  final NotificationService notificationService;
  final SharedPreferences sharedPreferences;

  /// A list of all available notification topics.
  static const List<String> availableTopics = [
    'zporter_news',
    'app_updates',
    'pro_offers'
  ];

  NotificationRepositoryImpl({
    required this.localDataSource,
    required this.notificationService,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    return await localDataSource.cacheNotification(notification);
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return await localDataSource.getCachedNotifications();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    return await localDataSource.markNotificationAsRead(notificationId);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    return await localDataSource.deleteNotification(notificationId);
  }

  @override
  Future<void> deleteAllNotifications() async {
    return await localDataSource.deleteAllNotifications();
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    return await localDataSource.getUnreadNotificationCount();
  }

  @override
  Future<Map<String, bool>> getNotificationSettings() async {
    final settings = <String, bool>{};
    for (String topic in availableTopics) {
      // By default, users are subscribed to all topics.
      settings[topic] = sharedPreferences.getBool(topic) ?? true;
    }
    return settings;
  }

  @override
  Future<void> updateNotificationSettings(
      String topic, bool isSubscribed) async {
    // Persist the setting locally.
    await sharedPreferences.setBool(topic, isSubscribed);

    // Update the subscription with Firebase Messaging.
    if (isSubscribed) {
      await notificationService.subscribeToTopic(topic);
    } else {
      await notificationService.unsubscribeFromTopic(topic);
    }
  }
}
