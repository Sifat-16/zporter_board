import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';

class UpdateMatchScoreRequest{
  ObjectId matchId;
  MatchScore newScore;
  UpdateMatchScoreRequest({required this.matchId, required this.newScore});

}