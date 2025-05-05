import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zporter_board/core/constant/firestore_constant.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
// Remove MongoDB related imports
// import 'package:mongo_dart/mongo_dart.dart' hide State;
// import 'package:zporter_board/config/database/remote/mongodb.dart';
// import 'package:zporter_board/core/constant/mongo_constant.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source.dart';
import 'package:zporter_board/features/auth/data/model/user_model.dart';

class AuthDataSourceImpl extends AuthDataSource {
  // Inject FirebaseFirestore instance instead of MongoDB
  final FirebaseFirestore firestore;
  final FirebaseAuth
  firebaseAuth; // Keep FirebaseAuth if needed elsewhere or pass it
  final GoogleSignIn googleSignIn; // Keep GoogleSignIn
  final UserIdService userIdService;

  AuthDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.userIdService,
  }); // Updated constructor

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // --- This part remains the same ---
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // Handle potential null googleUser if sign-in is cancelled
      if (googleUser == null) {
        debug(data: "Google Sign-In cancelled by user.");
        return null;
      }
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      // Handle potential null googleAuth
      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        BotToast.showText(
          text: "Google authentication failed to retrieve tokens.",
        );
        debug(data: "Google authentication failed to retrieve tokens.");
        return null;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      BotToast.showText(text: "Credential token acquired.");
      debug(
        data:
            "Credential token acquired.", // Avoid logging sensitive tokens directly
      );
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      return userCredential;
      // --- End of unchanged part ---
    } on FirebaseAuthException catch (e) {
      BotToast.showText(
        text:
            "FirebaseAuthException during Google Sign-In: ${e.message} code: ${e.code}",
      );
      debug(
        data:
            "FirebaseAuthException during Google Sign-In: ${e.message} code: ${e.code}",
      );
      // Handle specific Firebase auth errors (e.g., account-exists-with-different-credential)
      return null;
    } on Exception catch (e) {
      BotToast.showText(text: "Generic Exception during Google Sign-In: $e");
      debug(data: "Generic Exception during Google Sign-In: $e");
      return null;
    }
  }

  @override
  Future<bool> signOutFromGoogle() async {
    try {
      // --- This part remains the same ---
      await googleSignIn.signOut(); // Also sign out from Google
      await firebaseAuth.signOut();
      debug(data: "Successfully signed out.");
      return true;
      // --- End of unchanged part ---
    } on Exception catch (e) {
      debug(data: "Exception during Sign Out: $e");
      return false;
    }
  }

  @override
  Future<UserModel?> fetchUser({required String uid}) async {
    try {
      // Get reference to the user document in Firestore
      final DocumentReference userDocRef = firestore
          .collection(FirestoreConstants.usersCollection) // Use constant
          .doc(uid); // Use UID as the document ID

      // Get the document snapshot
      final DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Check if the document exists and has data
      if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
        debug(data: "User found in Firestore for UID: $uid");
        // Deserialize data from Firestore Map to UserModel
        // Ensure UserModel.fromJson handles Map<String, dynamic>
        return UserModel.fromJson(
          userDocSnapshot.data()! as Map<String, dynamic>,
        );
      } else {
        debug(data: "User not found in Firestore for UID: $uid");
        return null; // User document doesn't exist
      }
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during fetchUser: ${e.message} code: ${e.code}",
      );
      return null;
    } on Exception catch (e) {
      debug(data: "Generic Exception during fetchUser: $e");
      return null;
    }
  }

  @override
  Future<UserModel> createUser({required UserModel userModel}) async {
    // Ensure the userModel has a non-empty UID before trying to create
    if (userModel.uid.isEmpty) {
      debug(data: "Error: Attempted to create user with empty UID.");
      throw ArgumentError(
        "UserModel must have a valid UID to be created in Firestore.",
      );
    }

    try {
      // Get reference to the user document in Firestore (using UID as doc ID)
      final DocumentReference userDocRef = firestore
          .collection(FirestoreConstants.usersCollection) // Use constant
          .doc(userModel.uid); // Use UID as the document ID

      // Use `set` to create the document (or overwrite if it exists)
      // Ensure userModel.toJson() returns Map<String, dynamic>
      await userDocRef.set(userModel.toJson());

      debug(
        data: "User created/updated in Firestore with UID: ${userModel.uid}",
      );
      // Return the original userModel as confirmation
      return userModel;
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during createUser: ${e.message} code: ${e.code}",
      );
      // Re-throw or handle specific errors as needed
      throw Exception("Failed to create user in Firestore: ${e.message}");
    } on Exception catch (e) {
      debug(data: "Generic Exception during createUser: $e");
      // Re-throw or handle specific errors as needed
      throw Exception(
        "An unexpected error occurred while creating the user: $e",
      );
    }
  }

  @override
  Future<String> guestLogin() async {
    return userIdService.getCurrentUserId();
  }
}
