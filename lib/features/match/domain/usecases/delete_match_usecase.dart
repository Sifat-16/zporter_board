import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';

class DeleteMatchUseCase extends UseCase<bool, String> {
  MatchRepository matchRepository;

  DeleteMatchUseCase({required this.matchRepository});

  @override
  Future<bool> call(param) async {
    return await matchRepository.deleteMatch(param);
  }
}
