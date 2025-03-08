import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/PlayerDataModel.dart';

sealed class PlayerState extends Equatable{
  @override
  List<Object?> get props => [];
}

class PlayerInitialState extends PlayerState{

}


class PlayerLoadedState extends PlayerState{

  final List<PlayerModel> home;
  final List<PlayerModel> other;
  final List<PlayerModel> away;
  final List<PlayerModel> playing;


  PlayerLoadedState({required this.away, required this.home, required this.other, required this.playing});

  @override
  // TODO: implement props
  List<Object?> get props => [home, away, other, playing];
}

class HomePlayerLoadedState extends PlayerState{
  final List<PlayerModel> home;
  HomePlayerLoadedState({required this.home});
  @override
  // TODO: implement props
  List<Object?> get props => [home];
}

class OtherPlayerLoadedState extends PlayerState{
  final List<PlayerModel> other;
  OtherPlayerLoadedState({required this.other});
  @override
  // TODO: implement props
  List<Object?> get props => [other];
}

class AwayPlayerLoadedState extends PlayerState{
  final List<PlayerModel> away;
  AwayPlayerLoadedState({required this.away});
  @override
  // TODO: implement props
  List<Object?> get props => [away];
}

class PlayingPlayerLoadedState extends PlayerState{
  final List<PlayerModel> playing;
  PlayingPlayerLoadedState({required this.playing});
  @override
  // TODO: implement props
  List<Object?> get props => [playing];
}

class PlayerAddToPlayingSuccessState extends PlayerState{
  final PlayerModel playerModel;
  final String forceEmitKey;


  PlayerAddToPlayingSuccessState({required this.playerModel, String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [playerModel, forceEmitKey];
}

