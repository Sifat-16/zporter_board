// // lib/core/services/user_id_service.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zporter_tactical_board/app/generator/random_generator.dart';
//
// class UserIdService {
//   final FirebaseAuth _firebaseAuth;
//   final SharedPreferences _prefs;
//
//   static const _localUserIdKey = 'local_user_id';
//
//   UserIdService({
//     required FirebaseAuth firebaseAuth,
//     required SharedPreferences prefs,
//   }) : _firebaseAuth = firebaseAuth,
//        _prefs = prefs;
//
//   String? _currentLocalId;
//
//   /// Gets the current operational user ID.
//   /// Returns Firebase UID if logged in, otherwise returns the local temporary ID
//   /// (generating one if it doesn't exist).
//   String getCurrentUserId() {
//     final firebaseUser = _firebaseAuth.currentUser;
//     if (firebaseUser != null) {
//       // If logged in, Firebase UID is the source of truth
//       // Clear local ID if it exists, as it's superseded.
//       // (Do this carefully, perhaps only after successful sync - see sync logic later)
//       // _prefs.remove(_localUserIdKey); // Be careful with removal timing
//       // _currentLocalId = null;
//       return firebaseUser.uid;
//     } else {
//       // Not logged into Firebase, use local ID
//       if (_currentLocalId == null) {
//         _currentLocalId = _prefs.getString(_localUserIdKey);
//         if (_currentLocalId == null) {
//           _currentLocalId = RandomGenerator.generateId();
//           _prefs.setString(_localUserIdKey, _currentLocalId!);
//           print("Generated new local user ID: $_currentLocalId");
//         }
//       }
//       return _currentLocalId!;
//     }
//   }
//
//   /// Checks if the user is currently authenticated with Firebase.
//   bool isFirebaseLoggedIn() {
//     return _firebaseAuth.currentUser != null;
//   }
//
//   /// Gets the stored local user ID, if one exists. Used for sync checks.
//   String? getStoredLocalUserId() {
//     return _prefs.getString(_localUserIdKey);
//   }
//
//   /// Clears the stored local user ID. Call this AFTER successful data sync.
//   Future<void> clearLocalUserId() async {
//     _currentLocalId = null;
//     await _prefs.remove(_localUserIdKey);
//     print("Cleared local user ID.");
//   }
//
//   /// Forces refresh of the current user ID state, e.g., after login/logout
//   void refreshUserIdState() {
//     _currentLocalId = _prefs.getString(_localUserIdKey); // Re-read from prefs
//     // No need to return anything, just updates internal state for next getCurrentUserId call
//   }
// }
