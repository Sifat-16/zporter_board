import 'package:equatable/equatable.dart';

/// The base class for all states related to the [UnreadCountBloc].
abstract class UnreadCountState extends Equatable {
  final int count;

  const UnreadCountState(this.count);

  @override
  List<Object> get props => [count];
}

/// The initial state, where the count is typically zero.
class UnreadCountInitial extends UnreadCountState {
  const UnreadCountInitial() : super(0);
}

/// The state representing the current number of unread notifications.
class UnreadCountLoaded extends UnreadCountState {
  const UnreadCountLoaded(super.count);
}
