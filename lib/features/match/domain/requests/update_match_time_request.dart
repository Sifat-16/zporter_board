import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';

class UpdateMatchTimeRequest {
  String matchId; // <<< Changed from ObjectId to String
  int matchPeriodId;
  FootballMatch footballMatch; // Contains the full updated match state
  MatchTimeUpdateStatus
  matchTimeUpdateStatus; // The status related to the update action

  UpdateMatchTimeRequest({
    required this.matchId,
    required this.matchPeriodId,
    required this.footballMatch,
    required this.matchTimeUpdateStatus,
  });
}
