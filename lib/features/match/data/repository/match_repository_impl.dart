import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';

class MatchRepositoryImpl implements MatchRepository{
  MatchDataSource matchDataSource;
  MatchRepositoryImpl({required this.matchDataSource});
  @override
  Future<List<FootballMatch>> getAllMatches() async{
    return await matchDataSource.getAllMatches();
  }

}