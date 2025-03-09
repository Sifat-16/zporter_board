import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState>{
  FetchMatchUsecase _fetchMatchUsecase;
  UpdateMatchScoreUsecase _updateMatchScoreUsecase;
  UpdateMatchTimeUsecase _updateMatchTimeUsecase;
  MatchBloc({required FetchMatchUsecase fetchMatchUsecase, required UpdateMatchScoreUsecase updateMatchScoreUsecase, required UpdateMatchTimeUsecase updateMatchTimeUsecase})
      : _fetchMatchUsecase=fetchMatchUsecase,
        _updateMatchScoreUsecase=updateMatchScoreUsecase,
        _updateMatchTimeUsecase = updateMatchTimeUsecase,
        super(MatchInitialState()){
    on<MatchLoadEvent>(_onLoadMatches);
    on<MatchSelectEvent>(_onMatchSelected);
    on<MatchScoreUpdateEvent>(_onMatchScoreUpdate);
    on<MatchUpdateEvent>(_onMatchUpdate);
    on<MatchTimeUpdateEvent>(_onMatchTimeUpdate);

  }

  List<FootballMatch>? matches;
  FootballMatch? selectedMatch;
  int selectedIndex = 0;


  FutureOr<void> _onLoadMatches(MatchLoadEvent event, Emitter<MatchState> emit) async{
    emit(MatchLoadInProgressState());
    try{
      matches = await _fetchMatchUsecase.call(null);
      selectedMatch = matches!.first;
      emit(MatchUpdateState());
    }catch(e){
      emit(MatchLoadFailureState(failureMessage: e.toString()));
    }
  }

  FutureOr<void> _onMatchSelected(MatchSelectEvent event, Emitter<MatchState> emit) async{
    try{
      selectedMatch = matches![event.index];
      selectedIndex = event.index;
      emit(MatchUpdateState());
    }catch(e){

    }
  }

  FutureOr<void> _onMatchScoreUpdate(MatchScoreUpdateEvent event, Emitter<MatchState> emit) async{

    try{
      FootballMatch updatedMatch = await _updateMatchScoreUsecase.call(UpdateMatchScoreRequest(matchId: event.matchId, newScore: event.newScore));
      _updateMatch(updatedMatch);
      emit(MatchUpdateState());

    }catch(e){

    }

  }

  FutureOr<void> _onMatchUpdate(MatchUpdateEvent event, Emitter<MatchState> emit) {
    emit(MatchUpdateState());
  }

  FutureOr<void> _onMatchTimeUpdate(MatchTimeUpdateEvent event, Emitter<MatchState> emit) async{

    try{
      FootballMatch? footballMatch = matches?.firstWhere((t)=>t.id==event.matchId);
      FootballMatch updatedMatch = await _updateMatchTimeUsecase.call(UpdateMatchTimeRequest(matchId: footballMatch!.id, footballMatch: footballMatch, matchTimeUpdateStatus: event.matchTimeUpdateStatus));
      _updateMatch(updatedMatch);
      emit(MatchUpdateState());
    }catch(e){
      debug(data: "Error while updating time ${e.toString()}");
    }
  }

  _updateMatch(FootballMatch updatedMatch){
    int index = matches?.indexWhere((m)=>m.id==updatedMatch.id)??-1;
    if(index!=-1){
      matches?[index] = updatedMatch;
      selectedMatch = matches?[selectedIndex];
    }
  }
}