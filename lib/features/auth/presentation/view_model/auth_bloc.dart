import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zporter_board/core/services/navigation_service.dart';
import 'package:zporter_board/core/services/notification_service.dart';
import 'package:zporter_board/core/services/random_service.dart';
import 'package:zporter_board/core/utils/random/random_utils.dart';
import 'package:zporter_board/features/auth/data/model/user_model.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_and_sync_match_usecase.dart';

/// The central BLoC for managing user authentication and identity.
///
/// This BLoC is the single source of truth for the user's state, handling
/// guest users, Google Sign-In, profile creation in Firestore, and FCM token management.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;
  final NotificationService _notificationService;

  static const _guestIdFileName = 'zporter_guest.id';

  StreamSubscription<auth.User?>? _userSubscription;

  static const _localUserIdKey = 'local_user_id';

  AuthBloc({
    required auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
    required SharedPreferences prefs,
    required NotificationService notificationService,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestore = firestore,
        _prefs = prefs,
        _notificationService = notificationService,
        super(const AuthState.unknown()) {
    on<AppOpened>(_onAppOpened);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  /// Initializes the authentication flow when the app starts.
  void _onAppOpened(AppOpened event, Emitter<AuthState> emit) {
    // Listen to real-time changes in Firebase auth state.
    _userSubscription = _firebaseAuth.authStateChanges().listen((user) {
      add(AuthUserChanged(user));
    });
  }

  /// Handles changes from the Firebase auth stream.
  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    final firebaseUser = event.user;
    if (firebaseUser != null) {
      // User is logged in with Google.
      final userEntity = await _getOrCreateGoogleUser(firebaseUser);
      emit(AuthState.authenticated(userEntity));
    } else {
      // User is not logged in with Google, treat as guest.
      final guestEntity = await _getOrCreateGuestUser();
      emit(AuthState.authenticated(guestEntity));
    }
  }

  /// Handles the Google Sign-In request.
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // THE FIX: Get the use case from the service locator here, ONLY when needed.
      final fetchAndSyncUseCase =
          GetIt.instance<FetchAndSyncLocalMatchesUseCase>();

      FootballMatch? matchesToSync;
      final BuildContext? context = NavigationService.instance.currentContext;
      if (context != null) {
        matchesToSync = await fetchAndSyncUseCase.call(context);
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User cancelled the sign-in

      final googleAuth = await googleUser.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);

      if (matchesToSync != null) {
        await fetchAndSyncUseCase.syncRemote(matchesToSync);
      }
      // The `_onAuthUserChanged` listener will automatically handle the state change.
    } catch (e) {
      print('Google Sign-In Failed: $e');
      // Re-emit the current state to avoid the UI getting stuck in a loading state.
      add(AuthUserChanged(_firebaseAuth.currentUser));
    }
  }

  /// Handles the sign-out request.
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    // The `_onAuthUserChanged` listener will automatically handle the state change.
  }

  /// Gets the existing guest user profile or creates a new one.
  // Future<UserEntity> _getOrCreateGuestUser() async {
  //   String? guestId = _prefs.getString(_localUserIdKey);
  //   if (guestId == null) {
  //     guestId = RandomGenerator.generateId();
  //     await _prefs.setString(_localUserIdKey, guestId);
  //   }
  //
  //   final userDoc = _firestore.collection('users').doc(guestId);
  //   final snapshot = await userDoc.get();
  //
  //   if (snapshot.exists) {
  //     final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  //     return await _updateTokenIfChanged(user);
  //   } else {
  //     final fcmToken = await _notificationService.getFCMToken();
  //     final newUser = UserEntity(
  //       uid: guestId,
  //       userType: 'guest',
  //       accountType: AccountType.free,
  //       fcmToken: fcmToken,
  //       creationTime: DateTime.now(),
  //     );
  //     await userDoc.set(UserModel.fromEntity(newUser).toJson());
  //     return newUser;
  //   }
  // }

  /// Gets the existing guest user profile or creates a new one with a durable fallback.
  Future<UserEntity> _getOrCreateGuestUser() async {
    String? guestId = _prefs.getString(_localUserIdKey);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_guestIdFileName');

    // SCENARIO 1: User is healthy. Proactively back up their ID to the file system.
    if (guestId != null && guestId.isNotEmpty) {
      if (!await file.exists()) {
        print("Proactively backing up existing guest ID to file system.");
        try {
          await file.writeAsString(guestId);
        } catch (e) {
          print("Failed to create proactive backup file: $e");
        }
      }
    }
    // SCENARIO 2: SharedPreferences is empty. Try to recover the ID from the backup file.
    else if (await file.exists()) {
      try {
        guestId = await file.readAsString();
        // Self-heal: If we found it in the file, restore it to SharedPreferences
        if (guestId != null && guestId.isNotEmpty) {
          await _prefs.setString(_localUserIdKey, guestId);
          print("Guest ID recovered from file system.");
        }
      } catch (e) {
        print("Error reading guest ID from file: $e");
      }
    }

    // SCENARIO 3: Both SharedPreferences and the file are empty. It's a true new user.
    // Generate a new ID and save it to BOTH places for future durability.
    if (guestId == null || guestId.isEmpty) {
      guestId = RandomGenerator.generateId();
      print("Generating a new guest ID and saving to both locations.");
      await _prefs.setString(_localUserIdKey, guestId);
      try {
        await file.writeAsString(guestId);
      } catch (e) {
        print("Error saving new guest ID to file: $e");
      }
    }

    // The rest of the logic remains identical, using the now-guaranteed guestId
    final userDoc = _firestore.collection('users').doc(guestId);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      return await _updateTokenIfChanged(user);
    } else {
      final fcmToken = await _notificationService.getFCMToken();
      final newUser = UserEntity(
        uid: guestId,
        userType: 'guest',
        accountType: AccountType.free,
        fcmToken: fcmToken,
        creationTime: DateTime.now(),
      );
      await userDoc.set(UserModel.fromEntity(newUser).toJson());
      return newUser;
    }
  }

  /// Gets the existing Google user profile or creates a new one.
  Future<UserEntity> _getOrCreateGoogleUser(auth.User firebaseUser) async {
    final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      return await _updateTokenIfChanged(user);
    } else {
      final fcmToken = await _notificationService.getFCMToken();
      final newUser = UserEntity(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName,
        email: firebaseUser.email,
        userType: 'google',
        accountType: AccountType.free,
        fcmToken: fcmToken,
        creationTime: firebaseUser.metadata.creationTime,
        lastSignInTime: firebaseUser.metadata.lastSignInTime,
      );
      await userDoc.set(UserModel.fromEntity(newUser).toJson());
      return newUser;
    }
  }

  /// Checks if the FCM token has changed and updates it in Firestore if needed.
  Future<UserEntity> _updateTokenIfChanged(UserEntity user) async {
    final newFcmToken = await _notificationService.getFCMToken();
    if (newFcmToken != null && newFcmToken != user.fcmToken) {
      final updatedUser = user.copyWith(fcmToken: newFcmToken);
      await _firestore.collection('users').doc(user.uid).set(
          UserModel.fromEntity(updatedUser).toJson(), SetOptions(merge: true));
      return updatedUser;
    }
    return user;
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
