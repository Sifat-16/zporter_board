import 'package:zporter_board/features/notification/data/model/notification_model.dart';

/// Abstract interface for the local data source of notifications.
///
/// This contract defines the methods that any local notification data source
/// implementation must provide. It ensures a clean separation between the
/// data layer's implementation details (like Sembast) and the repository
/// that uses it.
abstract class NotificationLocalDataSource {
  /// Caches a single notification to the local database.
  Future<void> cacheNotification(NotificationModel notification);

  /// Retrieves all cached notifications from the local database.
  Future<List<NotificationModel>> getCachedNotifications();

  /// Marks a specific notification as read in the local database.
  Future<void> markNotificationAsRead(String notificationId);

  /// Deletes a specific notification from the local database.
  Future<void> deleteNotification(String notificationId);

  /// Deletes all notifications from the local database.
  Future<void> deleteAllNotifications();

  /// Gets the count of unread notifications.
  Future<int> getUnreadNotificationCount();
}
