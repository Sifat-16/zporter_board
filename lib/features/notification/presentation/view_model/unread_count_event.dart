import 'package:equatable/equatable.dart';

/// The base class for all events related to the [UnreadCountBloc].
abstract class UnreadCountEvent extends Equatable {
  const UnreadCountEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize and load the current unread count from the repository.
class LoadUnreadCount extends UnreadCountEvent {}

/// Event to increment the unread count, typically called when a new
/// notification is received.
class IncrementUnreadCount extends UnreadCountEvent {}

/// Event to reset the unread count to zero, typically called when the
/// user opens the notification screen.
class ResetUnreadCount extends UnreadCountEvent {}
