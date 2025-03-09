import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class UpdateMatchTimeRequest{
   ObjectId matchId;
   FootballMatch footballMatch;
   MatchTimeUpdateStatus matchTimeUpdateStatus;

  UpdateMatchTimeRequest({required this.matchId, required this.footballMatch, required this.matchTimeUpdateStatus});

}