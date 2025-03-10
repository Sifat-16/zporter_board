import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';

class FetchMatchUsecase extends UseCase<List<FootballMatch>, dynamic>{

  MatchRepository matchRepository;

  FetchMatchUsecase({required this.matchRepository});

  @override
  Future<List<FootballMatch>> call(param) async{
    return await matchRepository.getAllMatches();
  }

}