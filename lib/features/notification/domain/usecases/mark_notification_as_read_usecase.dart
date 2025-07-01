import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// A use case for marking a single notification as read.
///
/// This class encapsulates the business logic required to update the read
/// status of a notification. It takes the notification's ID as a parameter.
class MarkNotificationAsReadUseCase implements UseCase<void, MarkAsReadParams> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  /// Executes the use case.
  @override
  Future<void> call(MarkAsReadParams params) async {
    return await repository.markNotificationAsRead(params.notificationId);
  }
}

/// Parameters required for the [MarkNotificationAsReadUseCase].
class MarkAsReadParams {
  final String notificationId;

  MarkAsReadParams(this.notificationId);
}
