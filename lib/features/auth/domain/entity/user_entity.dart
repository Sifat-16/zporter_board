// class UserEntity {
//   final String uid;
//   final String? email;
//   final String? displayName;
//   final String? photoURL;
//   final bool isAnonymous;
//
//   UserEntity({
//     required this.uid,
//     this.email,
//     this.displayName,
//     this.photoURL,
//     this.isAnonymous = false,
//   });
// }

import 'package:equatable/equatable.dart';

/// Enum for different account types, making it scalable for the future.
enum AccountType { free, premium }

/// The central User entity for the entire application.
/// This class represents a user's data, whether they are a guest or fully registered.
class UserEntity extends Equatable {
  final String uid;
  final String? name;
  final String? email;
  final String? fcmToken; // For push notifications
  final AccountType accountType; // To distinguish between free/premium
  final String userType; // e.g., 'guest' or 'google'
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const UserEntity({
    required this.uid,
    this.name,
    this.email,
    this.fcmToken,
    required this.accountType,
    required this.userType,
    this.creationTime,
    this.lastSignInTime,
  });

  /// An empty user representation, useful for initial states.
  static const empty = UserEntity(
    uid: '',
    accountType: AccountType.free,
    userType: '',
  );

  /// A convenience method to create a copy of the user object with some fields updated.
  /// This is crucial for immutable state management in BLoC.
  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? fcmToken,
    AccountType? accountType,
    String? userType,
    DateTime? creationTime,
    DateTime? lastSignInTime,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      accountType: accountType ?? this.accountType,
      userType: userType ?? this.userType,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        fcmToken,
        accountType,
        userType,
        creationTime,
        lastSignInTime,
      ];
}
