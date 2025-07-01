import 'package:equatable/equatable.dart';

/// The base class for all events related to the [NotificationBloc].
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch all notifications.
class LoadNotifications extends NotificationEvent {}

/// Event to mark a notification as read.
class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

/// Event to delete a single notification.
class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

/// Event to delete all notifications.
class DeleteAllNotifications extends NotificationEvent {}

/// Event triggered when the notifications have been updated
/// (e.g., by a background message) and the list needs to be refreshed.
class NotificationsUpdated extends NotificationEvent {
  const NotificationsUpdated();
}
