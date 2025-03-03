import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/config/database/remote/mongodb.dart';
import 'package:zporter_board/core/constant/mongo_constant.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source.dart';
import 'package:zporter_board/features/auth/data/model/user_model.dart';

class AuthDataSourceImpl extends AuthDataSource{

  MongoDB mongoDB;
  AuthDataSourceImpl({required this.mongoDB});

  @override
  Future<UserCredential?> signInWithGoogle() async{
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      debug(data: "Credential token ${credential.accessToken} - ${credential.idToken}");
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } on Exception catch (e) {
      // TODO
      return null;
    }
  }

  @override
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<UserModel?> fetchUser({required String uid}) async{
    DbCollection? userCollection = mongoDB.db?.collection(MongoConstant.USER_COLLECTION);
    final userDoc = await userCollection?.findOne(where.eq('uid', uid));
    if (userDoc == null) return null;
    return UserModel.fromJson(userDoc);
  }

  @override
  Future<UserModel> createUser({required UserModel userModel}) async{
    DbCollection? userCollection = mongoDB.db?.collection(MongoConstant.USER_COLLECTION);
    await userCollection?.insertOne(userModel.toJson());
    // Return the newly created user
    return userModel;
  }

}