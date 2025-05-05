import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';

class ClearMatchDbUseCase extends UseCase<int, dynamic> {
  MatchRepository matchRepository;

  ClearMatchDbUseCase({required this.matchRepository});

  @override
  Future<int> call(param) async {
    return await matchRepository.clearMatchDb();
  }
}
