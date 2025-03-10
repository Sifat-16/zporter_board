import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState>{
  PlayerBloc():
        super(PlayerInitialState()){
    on<PlayerLoadEvent>(_onLoadPlayer);
    on<PlayerTypeLoadEvent>(_onLoadPlayerType);
    on<PlayerPlayingLoadEvent>(_onLoadPlayerPlaying);
    on<PlayerAddToPlayingEvent>(_addPlayerToPlaying);
  }

   List<PlayerModel> home = [];
   List<PlayerModel> other = [];
   List<PlayerModel> away = [];

   List<PlayerModel> playing = [];



  FutureOr<void> _onLoadPlayer(PlayerLoadEvent event, Emitter<PlayerState> emit) {
    home = event.home;
    other = event.other;
    away = event.away;
    playing = event.playing;
    for (var player in playing) {
      if(player.playerType==PlayerType.HOME){
        home.removeWhere((e)=>e.id==player.id);

      }else if(player.playerType==PlayerType.AWAY){
        away.removeWhere((e)=>e.id==player.id);
      }else{
        other.removeWhere((e)=>e.id==player.id);
      }
    }
    emit(PlayerLoadedState(away: away, home: home, other: other, playing: playing));
  }

  FutureOr<void> _onLoadPlayerType(PlayerTypeLoadEvent event, Emitter<PlayerState> emit) {
    if(event.playerType==PlayerType.AWAY){
      emit(AwayPlayerLoadedState(away: away));
    }else if(event.playerType==PlayerType.HOME){
      emit(HomePlayerLoadedState(home: home));
    }else if(event.playerType==PlayerType.OTHER){
      emit(OtherPlayerLoadedState(other: other));
    }
  }

  FutureOr<void> _onLoadPlayerPlaying(PlayerPlayingLoadEvent event, Emitter<PlayerState> emit) {
    emit(PlayingPlayerLoadedState(playing: playing));
  }

  FutureOr<void> _addPlayerToPlaying(PlayerAddToPlayingEvent event, Emitter<PlayerState> emit) {


    PlayerModel player = event.playerModel;
    if(player.playerType==PlayerType.HOME){
      home.removeWhere((e)=>e.id==player.id);
    }else if(player.playerType==PlayerType.AWAY){
      away.removeWhere((e)=>e.id==player.id);
    }else{
      other.removeWhere((e)=>e.id==player.id);
    }

    playing.add(player);
    emit(PlayerAddToPlayingSuccessState(playerModel: player));
  }
}