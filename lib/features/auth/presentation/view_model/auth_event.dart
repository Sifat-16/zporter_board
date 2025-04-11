import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GoogleSignInEvent extends AuthEvent {}

class AuthStatusEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
