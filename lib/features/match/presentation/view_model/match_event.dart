import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

enum MatchTimeUpdateStatus{
  START,
  PAUSE,
  STOP
}

class MatchEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MatchLoadEvent extends MatchEvent{

}

class MatchSelectEvent extends MatchEvent{
  final int index;
  MatchSelectEvent({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class MatchScoreUpdateEvent extends MatchEvent{
  final ObjectId matchId;
  final MatchScore newScore;
  MatchScoreUpdateEvent({required this.matchId, required this.newScore});

  @override
  // TODO: implement props
  List<Object?> get props => [matchId, newScore];
}

class MatchTimeUpdateEvent extends MatchEvent{
  final ObjectId? matchId;
  final MatchTimeUpdateStatus matchTimeUpdateStatus;

  MatchTimeUpdateEvent({required this.matchId, required this.matchTimeUpdateStatus});

  @override
  // TODO: implement props
  List<Object?> get props => [matchId, matchTimeUpdateStatus];
}

class MatchUpdateEvent extends MatchEvent{

}

