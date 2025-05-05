import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';

class GuestLoginUseCase extends UseCase<String, dynamic> {
  AuthRepository authRepository;

  GuestLoginUseCase({required this.authRepository});

  @override
  Future<String> call(param) async {
    return authRepository.guestLogin();
  }
}
