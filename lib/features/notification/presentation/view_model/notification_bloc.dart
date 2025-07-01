import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_state.dart';

/// A BLoC that manages the state of the notification list screen.
///
/// It handles fetching, marking as read, and deleting notifications by
/// coordinating with the corresponding use cases.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationAsReadUseCase markNotificationAsRead;
  final DeleteNotificationUseCase deleteNotification;
  final DeleteAllNotificationsUseCase deleteAllNotifications;

  NotificationBloc({
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.deleteNotification,
    required this.deleteAllNotifications,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<NotificationsUpdated>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<DeleteAllNotifications>(_onDeleteAllNotifications);
  }

  /// Handles the [LoadNotifications] and [NotificationsUpdated] events.
  Future<void> _onLoadNotifications(
    NotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await getNotifications(null);
      if (notifications.isEmpty) {
        emit(NotificationEmpty());
      } else {
        emit(NotificationLoaded(notifications));
      }
    } catch (e) {
      emit(NotificationError('Failed to load notifications: ${e.toString()}'));
    }
  }

  /// Handles the [MarkNotificationAsRead] event.
  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markNotificationAsRead(MarkAsReadParams(event.notificationId));
      // Refresh the list to show the updated state
      add(LoadNotifications());
    } catch (e) {
      // Optionally emit an error state if marking as read fails
      print('Failed to mark notification as read: ${e.toString()}');
    }
  }

  /// Handles the [DeleteNotification] event.
  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await deleteNotification(DeleteNotificationParams(event.notificationId));
      // Refresh the list
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to delete notification: ${e.toString()}'));
    }
  }

  /// Handles the [DeleteAllNotifications] event.
  Future<void> _onDeleteAllNotifications(
    DeleteAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await deleteAllNotifications(null);
      // Refresh the list, which should now be empty
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError(
          'Failed to delete all notifications: ${e.toString()}'));
    }
  }
}
