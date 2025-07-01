import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// A use case for updating a user's notification settings for a specific topic.
///
/// This class encapsulates the business logic for subscribing or unsubscribing
/// from a notification topic (e.g., 'app_updates').
class UpdateNotificationSettingsUseCase
    implements UseCase<void, UpdateNotificationSettingsParams> {
  final NotificationRepository repository;

  UpdateNotificationSettingsUseCase(this.repository);

  /// Executes the use case.
  @override
  Future<void> call(UpdateNotificationSettingsParams params) async {
    return await repository.updateNotificationSettings(
      params.topic,
      params.isSubscribed,
    );
  }
}

/// Parameters required for the [UpdateNotificationSettingsUseCase].
class UpdateNotificationSettingsParams {
  final String topic;
  final bool isSubscribed;

  UpdateNotificationSettingsParams({
    required this.topic,
    required this.isSubscribed,
  });
}
