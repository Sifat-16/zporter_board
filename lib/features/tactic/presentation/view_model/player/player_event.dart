import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';

sealed class PlayerEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PlayerLoadEvent extends PlayerEvent{
  final List<PlayerModel> home;
  final List<PlayerModel> other;
  final List<PlayerModel> away;
  final List<PlayerModel> playing;

  PlayerLoadEvent({required this.away, required this.home, required this.other, required this.playing});

  @override
  // TODO: implement props
  List<Object?> get props => [home, away, other, playing];
}

class PlayerTypeLoadEvent extends PlayerEvent{
  final PlayerType playerType;

  PlayerTypeLoadEvent({required this.playerType});

  @override
  // TODO: implement props
  List<Object?> get props => [playerType];
}

class PlayerPlayingLoadEvent extends PlayerEvent{

  PlayerPlayingLoadEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PlayerAddToPlayingEvent extends PlayerEvent{
  final PlayerModel playerModel;
  PlayerAddToPlayingEvent({required this.playerModel});
  @override
  // TODO: implement props
  List<Object?> get props => [playerModel];
}

