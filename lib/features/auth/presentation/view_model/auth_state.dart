import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';

/// An enumeration of the possible authentication statuses.
enum AuthStatus {
  /// The initial state before any authentication check has been performed.
  unknown,

  /// The state when a user (guest or registered) is authenticated.
  authenticated,

  /// The state when there is no user, not even a guest.
  /// This occurs on first launch before a guest ID is created, or after logout.
  unauthenticated,
}

/// The state class for the [AuthBloc].
///
/// It holds the current authentication status and the user object.
/// This single-class approach simplifies state management.
class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity user;

  const AuthState._({
    required this.status,
    this.user = UserEntity.empty,
  });

  /// The initial state of the application.
  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  /// The state for an authenticated user.
  const AuthState.authenticated(UserEntity user)
      : this._(status: AuthStatus.authenticated, user: user);

  /// The state for an unauthenticated user.
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
