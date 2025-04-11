import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';

class CreateNewMatchUseCase extends UseCase<FootballMatch, dynamic> {
  MatchRepository matchRepository;

  CreateNewMatchUseCase({required this.matchRepository});

  @override
  Future<FootballMatch> call(param) async {
    return await matchRepository.createMatch();
  }
}
