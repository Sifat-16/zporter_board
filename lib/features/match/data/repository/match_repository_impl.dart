import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';

class MatchRepositoryImpl implements MatchRepository {
  MatchDataSource matchDataSource;
  MatchRepositoryImpl({required this.matchDataSource});
  @override
  Future<List<FootballMatch>> getAllMatches() async {
    return await matchDataSource.getAllMatches();
  }

  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    return await matchDataSource.updateMatchScore(updateMatchScoreRequest);
  }

  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    return await matchDataSource.updateMatchTime(updateMatchTimeRequest);
  }

  @override
  Future<FootballMatch> createMatch() async {
    return await matchDataSource.createMatch();
  }

  @override
  Future<bool> deleteMatch(String matchId) async {
    return await matchDataSource.deleteMatch(matchId);
  }
}
