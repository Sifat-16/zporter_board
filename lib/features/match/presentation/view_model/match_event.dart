import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';

enum MatchTimeUpdateStatus { START, PAUSE, STOP }

class MatchEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MatchLoadEvent extends MatchEvent {}

class MatchPeriodSelectEvent extends MatchEvent {
  final int index;
  MatchPeriodSelectEvent({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class MatchScoreUpdateEvent extends MatchEvent {
  final String matchId;
  final MatchScore newScore;
  MatchScoreUpdateEvent({required this.matchId, required this.newScore});

  @override
  // TODO: implement props
  List<Object?> get props => [matchId, newScore];
}

class SubUpdateEvent extends MatchEvent {
  final String matchId;
  final MatchSubstitutions matchSubstitutions;
  SubUpdateEvent({required this.matchId, required this.matchSubstitutions});

  @override
  // TODO: implement props
  List<Object?> get props => [matchId, matchSubstitutions];
}

class MatchTimeUpdateEvent extends MatchEvent {
  final int periodId;
  final MatchTimeUpdateStatus matchTimeUpdateStatus;
  final TimerMode timerMode;

  MatchTimeUpdateEvent({
    required this.periodId,
    required this.timerMode,
    required this.matchTimeUpdateStatus,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [matchTimeUpdateStatus, periodId, timerMode];
}

class MatchUpdateEvent extends MatchEvent {}

class UpdateMatchEvent extends MatchEvent {
  final FootballMatch footballMatch;
  UpdateMatchEvent({required this.footballMatch});

  @override
  // TODO: implement props
  List<Object?> get props => [footballMatch];
}

class CreateNewMatchEvent extends MatchEvent {}

class CreateNewPeriodEvent extends MatchEvent {}

class DeleteMatchEvent extends MatchEvent {
  DeleteMatchEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ClearMatchDbEvent extends MatchEvent {}

class ChangePeriodModeEvent extends MatchEvent {
  final int periodNumber;
  final TimerMode newMode;
  ChangePeriodModeEvent({required this.periodNumber, required this.newMode});
  @override
  // TODO: implement props
  List<Object?> get props => [periodNumber, newMode];
}

class IncreaseExtraTimeEvent extends MatchEvent {}

class DecreaseExtraTimeEvent extends MatchEvent {}
