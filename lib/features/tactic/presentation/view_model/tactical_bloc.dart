import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_state.dart';

class TacticalBloc extends Bloc<TacticalEvent, TacticalState>{
  TacticalBloc():
        super(TacticalInitialState()){
    on<TacticalBoardLoadEvent>(_onLoadTacticalBoard);
    on<TacticalBoardLoadPlayerTypeEvent>(_onLoadTacticalBoardPlayerType);
    on<TacticalBoardLoadPlayerPlayingEvent>(_onLoadTacticalBoardPlayerPlaying);
    on<TacticalBoardPlayerAddToPlayingEvent>(_addPlayerToPlaying);
  }

   List<PlayerModel> home = [];
   List<PlayerModel> other = [];
   List<PlayerModel> away = [];

   List<PlayerModel> playing = [];



  FutureOr<void> _onLoadTacticalBoard(TacticalBoardLoadEvent event, Emitter<TacticalState> emit) {
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
    emit(TacticalBoardLoadedState(away: away, home: home, other: other, playing: playing));
  }

  FutureOr<void> _onLoadTacticalBoardPlayerType(TacticalBoardLoadPlayerTypeEvent event, Emitter<TacticalState> emit) {
    if(event.playerType==PlayerType.AWAY){
      emit(TacticalBoardLoadedAwayPlayerState(away: away));
    }else if(event.playerType==PlayerType.HOME){
      emit(TacticalBoardLoadedHomePlayerState(home: home));
    }else if(event.playerType==PlayerType.OTHER){
      emit(TacticalBoardLoadedOtherPlayerState(other: other));
    }
  }

  FutureOr<void> _onLoadTacticalBoardPlayerPlaying(TacticalBoardLoadPlayerPlayingEvent event, Emitter<TacticalState> emit) {
    emit(TacticalBoardLoadedPlayingPlayerState(playing: playing));
  }

  FutureOr<void> _addPlayerToPlaying(TacticalBoardPlayerAddToPlayingEvent event, Emitter<TacticalState> emit) {


    PlayerModel player = event.playerModel;
    if(player.playerType==PlayerType.HOME){
      home.removeWhere((e)=>e.id==player.id);
    }else if(player.playerType==PlayerType.AWAY){
      away.removeWhere((e)=>e.id==player.id);
    }else{
      other.removeWhere((e)=>e.id==player.id);
    }

    playing.add(player);
    emit(TacticalBoardPlayerAddToPlayingSuccessState(away: away, home: home, other: other, playing: playing));
  }
}