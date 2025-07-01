import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// A use case for deleting all notifications.
///
/// This class encapsulates the business logic for clearing the entire
/// notification history from the local cache. It takes no parameters.
class DeleteAllNotificationsUseCase implements UseCase<void, dynamic> {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  /// Executes the use case.
  @override
  Future<void> call(dynamic params) async {
    return await repository.deleteAllNotifications();
  }
}
