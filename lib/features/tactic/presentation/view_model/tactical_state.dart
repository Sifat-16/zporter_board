import 'package:equatable/equatable.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';

sealed class TacticalState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TacticalInitialState extends TacticalState{

}


class TacticalBoardLoadedState extends TacticalState{

  final List<PlayerModel> home;
  final List<PlayerModel> other;
  final List<PlayerModel> away;
  final List<PlayerModel> playing;


  TacticalBoardLoadedState({required this.away, required this.home, required this.other, required this.playing});

  @override
  // TODO: implement props
  List<Object?> get props => [home, away, other, playing];
}

class TacticalBoardLoadedHomePlayerState extends TacticalState{
  final List<PlayerModel> home;
  TacticalBoardLoadedHomePlayerState({required this.home});
  @override
  // TODO: implement props
  List<Object?> get props => [home];
}

class TacticalBoardLoadedOtherPlayerState extends TacticalState{
  final List<PlayerModel> other;
  TacticalBoardLoadedOtherPlayerState({required this.other});
  @override
  // TODO: implement props
  List<Object?> get props => [other];
}

class TacticalBoardLoadedAwayPlayerState extends TacticalState{
  final List<PlayerModel> away;
  TacticalBoardLoadedAwayPlayerState({required this.away});
  @override
  // TODO: implement props
  List<Object?> get props => [away];
}

class TacticalBoardLoadedPlayingPlayerState extends TacticalState{
  final List<PlayerModel> playing;
  TacticalBoardLoadedPlayingPlayerState({required this.playing});
  @override
  // TODO: implement props
  List<Object?> get props => [playing];
}

class TacticalBoardPlayerAddToPlayingSuccessState extends TacticalState{
  final List<PlayerModel> home;
  final List<PlayerModel> other;
  final List<PlayerModel> away;
  final List<PlayerModel> playing;


  TacticalBoardPlayerAddToPlayingSuccessState({required this.away, required this.home, required this.other, required this.playing});

  @override
  // TODO: implement props
  List<Object?> get props => [home.length, away.length, other.length, playing.length];
}

