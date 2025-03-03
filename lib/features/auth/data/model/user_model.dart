import 'package:firebase_auth/firebase_auth.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoURL,
    super.isAnonymous,
  });

  // Factory method to map from Firebase User
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      isAnonymous: firebaseUser.isAnonymous,
    );
  }


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );
  }

  // Convert UserModel to JSON (for MongoDB storage)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
    };
  }

  // Optional: Convert UserModel back to UserEntity if needed
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      isAnonymous: isAnonymous,
    );
  }

  /// Convert `UserEntity` to `UserModel`
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      isAnonymous: entity.isAnonymous,
    );
  }
}