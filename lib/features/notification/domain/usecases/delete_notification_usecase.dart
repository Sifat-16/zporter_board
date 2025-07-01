import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// A use case for deleting a single notification.
///
/// This class encapsulates the business logic for removing a notification
/// from the local cache. It requires the ID of the notification to be deleted.
class DeleteNotificationUseCase
    implements UseCase<void, DeleteNotificationParams> {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  /// Executes the use case.
  @override
  Future<void> call(DeleteNotificationParams params) async {
    return await repository.deleteNotification(params.notificationId);
  }
}

/// Parameters required for the [DeleteNotificationUseCase].
class DeleteNotificationParams {
  final String notificationId;

  DeleteNotificationParams(this.notificationId);
}
