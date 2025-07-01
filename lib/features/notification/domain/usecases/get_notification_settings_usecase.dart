import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// A use case for fetching the user's notification settings.
///
/// This class encapsulates the business logic for retrieving the user's
/// current topic subscription preferences.
class GetNotificationSettingsUseCase
    implements UseCase<Map<String, bool>, dynamic> {
  final NotificationRepository repository;

  GetNotificationSettingsUseCase(this.repository);

  /// Executes the use case.
  ///
  /// Returns a map where the key is the topic name (e.g., 'zporter_news')
  /// and the value is a boolean indicating if the user is subscribed.
  @override
  Future<Map<String, bool>> call(dynamic params) async {
    return await repository.getNotificationSettings();
  }
}
