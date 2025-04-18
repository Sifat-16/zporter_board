import 'package:firebase_auth/firebase_auth.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source.dart';
import 'package:zporter_board/features/auth/data/model/user_model.dart';
import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthDataSource authDataSource;
  AuthRepositoryImpl({required this.authDataSource});
  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      UserCredential? userCredential = await authDataSource.signInWithGoogle();
      UserModel appUser = UserModel.fromFirebaseUser(userCredential!.user!);
      return appUser;
    } on Exception catch (e) {
      return null;
    }
  }

  @override
  Future<bool> signOutFromGoogle() async {
    try {
      return await authDataSource.signOutFromGoogle();
    } on Exception catch (e) {
      return true;
    }
  }

  @override
  Future<UserModel> createUser({required UserModel userModel}) async {
    return authDataSource.createUser(userModel: userModel);
  }

  @override
  Future<UserModel?> fetchUser({required String uid}) {
    return authDataSource.fetchUser(uid: uid);
  }

  @override
  Future<UserModel?> authStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await fetchUser(uid: user.uid);
  }

  @override
  Future<String> guestLogin() async {
    return await authDataSource.guestLogin();
  }
}
