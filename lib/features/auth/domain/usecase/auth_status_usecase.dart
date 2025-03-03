import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/auth/domain/entity/user_entity.dart';
import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';

class AuthStatusUsecase extends UseCase<UserEntity?, dynamic>{

  AuthRepository authRepository;

  AuthStatusUsecase({required this.authRepository});

  @override
  Future<UserEntity?> call(param) async{
    return authRepository.authStatus();
  }

}