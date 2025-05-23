import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/services/navigation_service.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';
import 'package:zporter_board/features/auth/domain/usecase/auth_status_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/guest_login_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_and_sync_match_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final AuthStatusUsecase _authStatusUsecase;
  final SignOutUseCase _signOutUseCase;
  final FetchAndSyncLocalMatchesUseCase _fetchAndSyncLocalMatchesUseCase;
  final GuestLoginUseCase _guestLoginUseCase;
  final MatchBloc _matchBloc;
  AuthBloc({
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required AuthStatusUsecase authStatusUsecase,
    required SignOutUseCase signOutUseCase,
    required FetchAndSyncLocalMatchesUseCase fetchAndSyncLocalMatchesUseCase,
    required GuestLoginUseCase guestLoginUseCase,
    required MatchBloc matchBloc,
  }) : _signInWithGoogleUseCase = signInWithGoogleUseCase,
       _authStatusUsecase = authStatusUsecase,
       _signOutUseCase = signOutUseCase,
       _fetchAndSyncLocalMatchesUseCase = fetchAndSyncLocalMatchesUseCase,
       _guestLoginUseCase = guestLoginUseCase,
       _matchBloc = matchBloc,
       super(AuthStateInitial()) {
    on<GoogleSignInEvent>(_signInWithGoogle);
    on<AuthStatusEvent>(_fetchAuthStatus);
    on<LogoutEvent>(_logout);
    on<GuestLoginEvent>(_guestLogin);
  }

  FutureOr<void> _signInWithGoogle(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    FootballMatch? matchesToSync;
    BuildContext? context = NavigationService.instance.currentContext;
    if (context != null) {
      matchesToSync = await _fetchAndSyncLocalMatchesUseCase.call(context);
    }
    try {
      emit(GoogleSignInProgress());
      UserEntity? userEntity = await _signInWithGoogleUseCase.call(null);
      if (userEntity == null) {
        emit(GoogleSignInFailure(message: "Something went wrong!"));
      } else {
        bool isMatchSynced = await _fetchAndSyncLocalMatchesUseCase.syncRemote(
          matchesToSync!,
        );
        emit(AuthStatusSuccess(userEntity: userEntity));
        _matchBloc.add(MatchLoadEvent());
      }
    } catch (e) {
      emit(GoogleSignInFailure(message: e.toString()));
    }
  }

  FutureOr<void> _fetchAuthStatus(
    AuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStatusInProgress());
      UserEntity? userEntity = await _authStatusUsecase.call(null);
      debug(data: "User identity fetched ${userEntity?.uid}");
      if (userEntity == null) {
        emit(AuthStatusFailure(message: "Something went wrong!"));
      } else {
        emit(AuthStatusSuccess(userEntity: userEntity));
      }
    } catch (e) {
      emit(AuthStatusFailure(message: e.toString()));
    }
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    bool signedOut = await _signOutUseCase.call(null);
    if (signedOut) {
      _matchBloc.add(ClearMatchDbEvent());
      emit(LogoutState());
    }
  }

  FutureOr<void> _guestLogin(
    GuestLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    String id = await _guestLoginUseCase.call(null);
    UserEntity userEntity = UserEntity(uid: id);
    emit(AuthStatusSuccess(userEntity: userEntity));
  }
}
