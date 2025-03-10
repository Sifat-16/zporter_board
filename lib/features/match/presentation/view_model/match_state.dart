import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';

class MatchState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MatchInitialState extends MatchState{

}

class MatchUpdateState extends MatchState{
  final String forceEmitKey;
  MatchUpdateState({String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [forceEmitKey];
}

class MatchLoadInProgressState extends MatchState{

}

class MatchLoadSuccessState extends MatchState{
  final List<FootballMatch> matches;
  MatchLoadSuccessState({required this.matches});

  @override
  // TODO: implement props
  List<Object?> get props => [matches];
}

class MatchLoadFailureState extends MatchState{
  final String failureMessage;
  MatchLoadFailureState({required this.failureMessage});
  @override
  // TODO: implement props
  List<Object?> get props => [failureMessage];
}

class MatchSelectedState extends MatchState{
  final FootballMatch match;
  MatchSelectedState({required this.match});

  @override
  // TODO: implement props
  List<Object?> get props => [match];
}

