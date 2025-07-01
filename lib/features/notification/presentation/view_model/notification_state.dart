import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';

/// The base class for all states related to the [NotificationBloc].
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

/// The initial state of the notification screen.
class NotificationInitial extends NotificationState {}

/// The state indicating that notifications are being loaded.
class NotificationLoading extends NotificationState {}

/// The state indicating that notifications have been successfully loaded.
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  const NotificationLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

/// The state indicating that there are no notifications to display.
class NotificationEmpty extends NotificationState {}

/// The state indicating that an error occurred while loading notifications.
class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
