import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';

class UpdateSubUseCase extends UseCase<FootballMatch, UpdateSubRequest> {
  MatchRepository matchRepository;

  UpdateSubUseCase({required this.matchRepository});

  @override
  Future<FootballMatch> call(param) async {
    return await matchRepository.updateSub(param);
  }
}
