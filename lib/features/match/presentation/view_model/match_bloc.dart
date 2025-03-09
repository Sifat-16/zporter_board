import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState>{
  FetchMatchUsecase _fetchMatchUsecase;
  MatchBloc({required FetchMatchUsecase fetchMatchUsecase})
      : _fetchMatchUsecase=fetchMatchUsecase,
        super(MatchInitialState()){
    on<MatchLoadEvent>(_onLoadMatches);
    on<MatchSelectEvent>(_onMatchSelected);
  }

  List<FootballMatch>? matches;
  FootballMatch? selectedMatch;



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
      debug(data: "match selected change ${selectedMatch}");
      emit(MatchUpdateState());
    }catch(e){

    }
  }
}