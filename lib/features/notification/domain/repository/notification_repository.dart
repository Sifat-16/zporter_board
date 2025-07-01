import 'package:zporter_board/features/notification/data/model/notification_model.dart';

/// Abstract interface for the notification repository.
///
/// This contract defines the methods that the domain layer (use cases) will use
/// to interact with notification data, without needing to know where the data
/// comes from (e.g., local cache, remote server).
abstract class NotificationRepository {
  /// Saves a notification to the data source.
  Future<void> saveNotification(NotificationModel notification);

  /// Retrieves a list of all notifications.
  Future<List<NotificationModel>> getNotifications();

  /// Marks a specific notification as read.
  Future<void> markNotificationAsRead(String notificationId);

  /// Deletes a specific notification.
  Future<void> deleteNotification(String notificationId);

  /// Deletes all notifications.
  Future<void> deleteAllNotifications();

  /// Gets the current count of unread notifications.
  Future<int> getUnreadNotificationCount();

  /// Retrieves the user's current notification settings (topic subscriptions).
  ///
  /// Returns a map where the key is the topic name (e.g., 'news') and the
  /// value is a boolean indicating if the user is subscribed.
  Future<Map<String, bool>> getNotificationSettings();

  /// Updates a user's subscription status for a specific topic.
  Future<void> updateNotificationSettings(String topic, bool isSubscribed);
}
