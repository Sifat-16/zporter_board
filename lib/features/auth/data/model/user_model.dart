// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';
//
// class UserModel extends UserEntity {
//   UserModel({
//     required super.uid,
//     super.email,
//     super.displayName,
//     super.photoURL,
//     super.isAnonymous,
//   });
//
//   // Factory method to map from Firebase User
//   factory UserModel.fromFirebaseUser(User firebaseUser) {
//     return UserModel(
//       uid: firebaseUser.uid,
//       email: firebaseUser.email,
//       displayName: firebaseUser.displayName,
//       photoURL: firebaseUser.photoURL,
//       isAnonymous: firebaseUser.isAnonymous,
//     );
//   }
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       uid: json['uid'] as String,
//       email: json['email'] as String?,
//       displayName: json['displayName'] as String?,
//       photoURL: json['photoURL'] as String?,
//       isAnonymous: json['isAnonymous'] as bool? ?? false,
//     );
//   }
//
//   // Convert UserModel to JSON (for MongoDB storage)
//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'email': email,
//       'displayName': displayName,
//       'photoURL': photoURL,
//       'isAnonymous': isAnonymous,
//     };
//   }
//
//   // Optional: Convert UserModel back to UserEntity if needed
//   UserEntity toEntity() {
//     return UserEntity(
//       uid: uid,
//       email: email,
//       displayName: displayName,
//       photoURL: photoURL,
//       isAnonymous: isAnonymous,
//     );
//   }
//
//   /// Convert `UserEntity` to `UserModel`
//   factory UserModel.fromEntity(UserEntity entity) {
//     return UserModel(
//       uid: entity.uid,
//       email: entity.email,
//       displayName: entity.displayName,
//       photoURL: entity.photoURL,
//       isAnonymous: entity.isAnonymous,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';

/// The data model for a user, extending the domain layer's [UserEntity].
///
/// This class is responsible for the practical implementation of the UserEntity,
/// specifically handling the conversion to and from Firestore data structures.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.name,
    super.email,
    super.fcmToken,
    required super.accountType,
    required super.userType,
    super.creationTime,
    super.lastSignInTime,
  });

  /// Factory constructor to create a [UserModel] from a JSON map (e.g., from Firestore).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'],
      email: json['email'],
      fcmToken: json['fcmToken'],
      accountType: _accountTypeFromString(json['accountType']),
      userType: json['userType'] ?? 'guest',
      creationTime: (json['creationTime'] as Timestamp?)?.toDate(),
      lastSignInTime: (json['lastSignInTime'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts the [UserModel] instance into a map for storing in Firestore.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'fcmToken': fcmToken,
      'accountType': accountType.toString().split('.').last,
      'userType': userType,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime,
    };
  }

  /// Helper function to safely convert a string from Firestore to an [AccountType] enum.
  static AccountType _accountTypeFromString(String? type) {
    if (type == 'premium') {
      return AccountType.premium;
    }
    return AccountType.free;
  }

  /// Creates a [UserModel] from a [UserEntity].
  /// This is useful for converting the domain object back to a data model for saving.
  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      fcmToken: entity.fcmToken,
      accountType: entity.accountType,
      userType: entity.userType,
      creationTime: entity.creationTime,
      lastSignInTime: entity.lastSignInTime,
    );
  }
}
