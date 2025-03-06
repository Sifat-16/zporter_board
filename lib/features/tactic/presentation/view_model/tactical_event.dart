import 'package:equatable/equatable.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';

sealed class TacticalEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TacticalBoardLoadEvent extends TacticalEvent{
  final List<PlayerModel> home;
  final List<PlayerModel> other;
  final List<PlayerModel> away;
  final List<PlayerModel> playing;

  TacticalBoardLoadEvent({required this.away, required this.home, required this.other, required this.playing});

  @override
  // TODO: implement props
  List<Object?> get props => [home, away, other, playing];
}

class TacticalBoardLoadPlayerTypeEvent extends TacticalEvent{
  final PlayerType playerType;

  TacticalBoardLoadPlayerTypeEvent({required this.playerType});

  @override
  // TODO: implement props
  List<Object?> get props => [playerType];
}

class TacticalBoardLoadPlayerPlayingEvent extends TacticalEvent{

  TacticalBoardLoadPlayerPlayingEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TacticalBoardPlayerAddToPlayingEvent extends TacticalEvent{
  final PlayerModel playerModel;
  TacticalBoardPlayerAddToPlayingEvent({required this.playerModel});
  @override
  // TODO: implement props
  List<Object?> get props => [playerModel];
}

