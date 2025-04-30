import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';

class UpdateMatchTimeRequest {
  String matchId; // <<< Changed from ObjectId to String
  int matchPeriodId;
  FootballMatch footballMatch; // Contains the full updated match state
  MatchTimeUpdateStatus
  matchTimeUpdateStatus; // The status related to the update action
  TimerMode timerMode;

  UpdateMatchTimeRequest({
    required this.matchId,
    required this.matchPeriodId,
    required this.footballMatch,
    required this.matchTimeUpdateStatus,
    required this.timerMode,
  });
}
