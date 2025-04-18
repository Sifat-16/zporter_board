import 'package:zporter_board/features/auth/data/model/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithGoogle();
  Future<bool> signOutFromGoogle();
  Future<UserModel?> fetchUser({required String uid});
  Future<UserModel> createUser({required UserModel userModel});
  Future<UserModel?> authStatus();
  Future<String> guestLogin();
}
