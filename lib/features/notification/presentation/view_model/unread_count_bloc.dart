import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_state.dart';

/// A BLoC to manage the unread notification count for the badge icon.
///
/// This BLoC is designed to be globally accessible to allow different parts
/// of the app (like the NotificationService) to update the count.
class UnreadCountBloc extends Bloc<UnreadCountEvent, UnreadCountState> {
  final NotificationRepository notificationRepository;

  UnreadCountBloc({required this.notificationRepository})
      : super(const UnreadCountInitial()) {
    on<LoadUnreadCount>(_onLoadUnreadCount);
    on<IncrementUnreadCount>(_onIncrementUnreadCount);
    on<ResetUnreadCount>(_onResetUnreadCount);
  }

  /// Handles the [LoadUnreadCount] event to get the initial count.
  Future<void> _onLoadUnreadCount(
    LoadUnreadCount event,
    Emitter<UnreadCountState> emit,
  ) async {
    try {
      final count = await notificationRepository.getUnreadNotificationCount();
      emit(UnreadCountLoaded(count));
    } catch (_) {
      // If loading fails, just default to 0.
      emit(const UnreadCountLoaded(0));
    }
  }

  /// Handles the [IncrementUnreadCount] event.
  void _onIncrementUnreadCount(
    IncrementUnreadCount event,
    Emitter<UnreadCountState> emit,
  ) {
    final newCount = state.count + 1;
    emit(UnreadCountLoaded(newCount));
  }

  /// Handles the [ResetUnreadCount] event.
  void _onResetUnreadCount(
    ResetUnreadCount event,
    Emitter<UnreadCountState> emit,
  ) {
    emit(const UnreadCountLoaded(0));
  }
}
