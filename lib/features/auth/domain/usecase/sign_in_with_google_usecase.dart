import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/data/model/user_model.dart';
import 'package:zporter_board/features/auth/data/repository/auth_repository_impl.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';
import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';

class SignInWithGoogleUseCase extends UseCase<UserEntity?, dynamic>{

  AuthRepository authRepository;

  SignInWithGoogleUseCase({required this.authRepository});

  @override
  Future<UserEntity?> call(param) async{
    UserEntity? userEntity = await authRepository.signInWithGoogle();
    if(userEntity!=null){
      debug(data: "Checking the user exists");
      UserEntity? mongoUser = await authRepository.fetchUser(uid: userEntity.uid);
      if(mongoUser==null){
        debug(data: "Creating the user exists");
        mongoUser = await authRepository.createUser(userModel: UserModel.fromEntity(userEntity));
      }
      userEntity = mongoUser;
    }
    return userEntity;
  }


}