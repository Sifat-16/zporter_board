import 'package:equatable/equatable.dart';

/// The base class for all events related to the [NotificationSettingsBloc].
abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the current notification settings.
class LoadNotificationSettings extends NotificationSettingsEvent {}

/// Event to update the subscription status for a specific topic.
class ToggleSubscription extends NotificationSettingsEvent {
  final String topic;
  final bool isSubscribed;

  const ToggleSubscription({required this.topic, required this.isSubscribed});

  @override
  List<Object> get props => [topic, isSubscribed];
}
