import 'package:equatable/equatable.dart';

/// The base class for all states related to the [NotificationSettingsBloc].
abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object> get props => [];
}

/// The initial state, before settings have been loaded.
class NotificationSettingsInitial extends NotificationSettingsState {}

/// The state indicating that the settings are being loaded.
class NotificationSettingsLoading extends NotificationSettingsState {}

/// The state indicating that the settings have been successfully loaded.
class NotificationSettingsLoaded extends NotificationSettingsState {
  /// A map representing the user's subscription status for each topic.
  ///
  /// Example: {'zporter_news': true, 'app_updates': false}
  final Map<String, bool> settings;

  const NotificationSettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

/// The state indicating that an error occurred while loading or updating settings.
class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  const NotificationSettingsError(this.message);

  @override
  List<Object> get props => [message];
}
