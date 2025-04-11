import 'package:zporter_board/features/scoreboard/data/model/score.dart';

class UpdateMatchScoreRequest {
  String matchId;
  MatchScore newScore;
  UpdateMatchScoreRequest({required this.matchId, required this.newScore});
}
