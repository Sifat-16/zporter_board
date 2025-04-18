import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';

abstract class MatchDataSource {
  Future<List<FootballMatch>> getAllMatches();
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  );
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  );
  Future<FootballMatch> createMatch({FootballMatch? footballMatch});
  Future<bool> deleteMatch(String matchId);
}
