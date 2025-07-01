import 'package:sembast/sembast.dart';
import 'package:zporter_board/config/database/local/sembastdb.dart';
import 'package:zporter_board/features/notification/data/data_source/notification_local_data_source.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';

/// The key for the Sembast store where notifications are stored.
const String kNotificationsStore = 'notifications';

/// The Sembast implementation of the [NotificationLocalDataSource].
///
/// This class handles all the database operations for notifications, such as
/// saving, retrieving, updating, and deleting them from the local Sembast
/// database.
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final Database _sembastDb;
  final _store = stringMapStoreFactory.store(kNotificationsStore);

  NotificationLocalDataSourceImpl(this._sembastDb);

  /// Provides access to the Sembast database instance.
  Database get _db => _sembastDb;

  @override
  Future<void> cacheNotification(NotificationModel notification) async {
    await _store.record(notification.id).put(await _db, notification.toMap());
  }

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    final snapshots = await _store.find(
      await _db,
      finder: Finder(sortOrders: [SortOrder('sentTime', false)]),
    );
    return snapshots
        .map((snapshot) => NotificationModel.fromMap(snapshot.value))
        .toList();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    final record = _store.record(notificationId);
    await record.update(await _db, {'isRead': true});
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _store.record(notificationId).delete(await _db);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _store.delete(await _db);
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    final count = await _store.count(
      await _db,
      filter: Filter.equals('isRead', false),
    );
    return count;
  }
}
