import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class AuthStateInitial extends AuthState {}

final class LogoutState extends AuthState {}

final class GoogleSignInProgress extends AuthStateInitial {}

// final class GoogleSignInSuccess extends AuthState{
//   final UserEntity userEntity;
//   const GoogleSignInSuccess({required this.userEntity});
//   @override
//   List<Object?> get props => [userEntity];
// }

final class GoogleSignInFailure extends AuthState {
  final String message;
  const GoogleSignInFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

final class AuthStatusInProgress extends AuthStateInitial {}

final class AuthStatusSuccess extends AuthState {
  final UserEntity userEntity;
  const AuthStatusSuccess({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}

final class AuthStatusFailure extends AuthState {
  final String message;
  const AuthStatusFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
