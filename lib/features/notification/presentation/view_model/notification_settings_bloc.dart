import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/get_notification_settings_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/update_notification_settings_usecase.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_state.dart';

/// A BLoC that manages the state of the notification settings screen.
///
/// It handles fetching the user's current subscription preferences and
/// updating them when the user toggles a subscription on or off.
class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final GetNotificationSettingsUseCase getNotificationSettings;
  final UpdateNotificationSettingsUseCase updateNotificationSettings;

  NotificationSettingsBloc({
    required this.getNotificationSettings,
    required this.updateNotificationSettings,
  }) : super(NotificationSettingsInitial()) {
    on<LoadNotificationSettings>(_onLoadNotificationSettings);
    on<ToggleSubscription>(_onToggleSubscription);
  }

  /// Handles the [LoadNotificationSettings] event.
  Future<void> _onLoadNotificationSettings(
    LoadNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    emit(NotificationSettingsLoading());
    try {
      final settings = await getNotificationSettings(null);
      emit(NotificationSettingsLoaded(settings));
    } catch (e) {
      emit(NotificationSettingsError(
          'Failed to load settings: ${e.toString()}'));
    }
  }

  /// Handles the [ToggleSubscription] event.
  Future<void> _onToggleSubscription(
    ToggleSubscription event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    try {
      await updateNotificationSettings(
        UpdateNotificationSettingsParams(
          topic: event.topic,
          isSubscribed: event.isSubscribed,
        ),
      );
      // After updating, reload the settings to ensure UI consistency.
      final settings = await getNotificationSettings(null);
      emit(NotificationSettingsLoaded(settings));
    } catch (e) {
      emit(NotificationSettingsError(
          'Failed to update setting: ${e.toString()}'));
      // If the update fails, it's good practice to reload the previous state.
      add(LoadNotificationSettings());
    }
  }
}
