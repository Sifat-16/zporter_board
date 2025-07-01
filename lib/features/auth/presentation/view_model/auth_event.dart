import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// The base class for all authentication events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched once when the application is first opened to initialize
/// the authentication state.
class AppOpened extends AuthEvent {}

/// An internal event that is dispatched when the Firebase auth state changes.
/// It carries the nullable Firebase user object.
class AuthUserChanged extends AuthEvent {
  final auth.User? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Dispatched when the user requests to sign in with Google.
class GoogleSignInRequested extends AuthEvent {}

/// Dispatched when the user requests to sign out.
class SignOutRequested extends AuthEvent {}
