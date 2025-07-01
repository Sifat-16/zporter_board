import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';

/// A use case for fetching the list of all notifications.
///
/// This class encapsulates the business logic for retrieving notifications.
/// It calls the [NotificationRepository] to get the data, separating the
/// core business rule from the UI and data layers.
class GetNotificationsUseCase
    implements UseCase<List<NotificationModel>, dynamic> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  /// Executes the use case.
  ///
  /// Returns a list of [NotificationModel] objects.
  @override
  Future<List<NotificationModel>> call(dynamic params) async {
    return await repository.getNotifications();
  }
}
