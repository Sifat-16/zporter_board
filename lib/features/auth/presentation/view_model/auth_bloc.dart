import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';
import 'package:zporter_board/features/auth/domain/usecase/auth_status_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final AuthStatusUsecase _authStatusUsecase;
  AuthBloc({
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required AuthStatusUsecase authStatusUsecase
}):
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _authStatusUsecase = authStatusUsecase,
        super(AuthStateInitial()){

      on<GoogleSignInEvent> (_signInWithGoogle);
      on<AuthStatusEvent> (_fetchAuthStatus);
  }

  FutureOr<void> _signInWithGoogle(GoogleSignInEvent event, Emitter<AuthState> emit) async{
    try{
      emit(GoogleSignInProgress());
      UserEntity? userEntity = await _signInWithGoogleUseCase.call(null);
      if(userEntity==null){
        emit(GoogleSignInFailure(message: "Something went wrong!"));
      }else{
        emit(GoogleSignInSuccess(userEntity: userEntity));
      }
    }catch(e){
      emit(GoogleSignInFailure(message: e.toString()));
    }
  }

  FutureOr<void> _fetchAuthStatus(AuthStatusEvent event, Emitter<AuthState> emit) async{
    try{
      emit(AuthStatusInProgress());
      UserEntity? userEntity = await _authStatusUsecase.call(null);
      if(userEntity==null){
        emit(AuthStatusFailure(message: "Something went wrong!"));
      }else{
        emit(AuthStatusSuccess(userEntity: userEntity));
      }
    }catch(e){
      emit(AuthStatusFailure(message: e.toString()));
    }
  }
}