import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/usecases/create_new_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  FetchMatchUsecase _fetchMatchUsecase;
  UpdateMatchScoreUsecase _updateMatchScoreUsecase;
  UpdateMatchTimeUsecase _updateMatchTimeUsecase;
  CreateNewMatchUseCase _createNewMatchUseCase;
  DeleteMatchUseCase _deleteMatchUseCase;
  MatchBloc({
    required FetchMatchUsecase fetchMatchUsecase,
    required UpdateMatchScoreUsecase updateMatchScoreUsecase,
    required UpdateMatchTimeUsecase updateMatchTimeUsecase,
    required CreateNewMatchUseCase createNewMatchUseCase,
    required DeleteMatchUseCase deleteMatchUseCase,
  }) : _fetchMatchUsecase = fetchMatchUsecase,
       _updateMatchScoreUsecase = updateMatchScoreUsecase,
       _updateMatchTimeUsecase = updateMatchTimeUsecase,
       _createNewMatchUseCase = createNewMatchUseCase,
       _deleteMatchUseCase = deleteMatchUseCase,
       super(MatchState.initial()) {
    on<MatchLoadEvent>(_onLoadMatches);
    on<MatchSelectEvent>(_onMatchSelected);
    on<MatchScoreUpdateEvent>(_onMatchScoreUpdate);
    on<MatchUpdateEvent>(_onMatchUpdate);
    on<MatchTimeUpdateEvent>(_onMatchTimeUpdate);
    on<CreateNewMatchEvent>(_createNewMatch);
    on<DeleteMatchEvent>(_deleteMatch);
    on<UpdateMatchEvent>(_updateMatch);
  }

  // List<FootballMatch>? matches;
  // FootballMatch? selectedMatch;
  // int selectedIndex = 0;

  FutureOr<void> _onLoadMatches(
    MatchLoadEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      List<FootballMatch>? matches = await _fetchMatchUsecase.call(null);
      FootballMatch? selectedMatch = matches.first;
      zlog(data: "match loading is called ${matches}");

      emit(
        state.copyWith(
          matches: matches,
          selectedMatch: selectedMatch,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(failureMessage: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> _onMatchSelected(
    MatchSelectEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      FootballMatch? selectedMatch = state.matches?[event.index];
      int selectedIndex = event.index;
      emit(
        state.copyWith(
          selectedMatch: selectedMatch,
          selectedIndex: selectedIndex,
        ),
      );
    } catch (e) {}
  }

  FutureOr<void> _onMatchScoreUpdate(
    MatchScoreUpdateEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      FootballMatch updatedMatch = await _updateMatchScoreUsecase.call(
        UpdateMatchScoreRequest(
          matchId: event.matchId,
          newScore: event.newScore,
        ),
      );
      add(UpdateMatchEvent(footballMatch: updatedMatch));
    } catch (e) {}
  }

  FutureOr<void> _onMatchUpdate(
    MatchUpdateEvent event,
    Emitter<MatchState> emit,
  ) {
    emit(state.copyWith());
  }

  FutureOr<void> _onMatchTimeUpdate(
    MatchTimeUpdateEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      FootballMatch? footballMatch = state.matches?.firstWhere(
        (t) => t.id == event.matchId,
      );
      FootballMatch updatedMatch = await _updateMatchTimeUsecase.call(
        UpdateMatchTimeRequest(
          matchId: footballMatch?.id ?? "",
          footballMatch: footballMatch!,
          matchTimeUpdateStatus: event.matchTimeUpdateStatus,
        ),
      );
      add(UpdateMatchEvent(footballMatch: updatedMatch));
    } catch (e) {
      debug(data: "Error while updating time ${e.toString()}");
    }
  }

  FutureOr<void> _updateMatch(
    UpdateMatchEvent event,
    Emitter<MatchState> emit,
  ) {
    List<FootballMatch>? matches = state.matches;
    int index =
        matches?.indexWhere((m) => m.id == event.footballMatch.id) ?? -1;
    if (index != -1) {
      matches?[index] = event.footballMatch;
      // FootballMatch? selectedMatch = matches?[selectedIndex];
    }
    emit(state.copyWith(matches: matches));
  }

  // _updateMatch(FootballMatch updatedMatch) {
  //   int index = matches?.indexWhere((m) => m.id == updatedMatch.id) ?? -1;
  //   if (index != -1) {
  //     matches?[index] = updatedMatch;
  //     selectedMatch = matches?[selectedIndex];
  //   }
  //   emit(MatchUpdateState());
  // }

  FutureOr<void> _createNewMatch(
    CreateNewMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    BotToast.showLoading();
    try {
      List<FootballMatch>? matches = state.matches;
      FootballMatch? selectedMatch = state.selectedMatch;
      int? selectedIndex = state.selectedIndex;
      FootballMatch newMatch = await _createNewMatchUseCase.call(null);
      matches?.add(newMatch);
      selectedMatch = matches?.lastOrNull;
      selectedIndex =
          matches?.indexWhere((m) => m.id == selectedMatch?.id) ?? -1;

      emit(
        state.copyWith(
          matches: matches,
          selectedMatch: selectedMatch,
          selectedIndex: selectedIndex,
        ),
      );
    } catch (e) {
      BotToast.showText(text: "Something went wrong $e");
    }
    BotToast.cleanAll();
  }

  FutureOr<void> _deleteMatch(
    DeleteMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    BotToast.showLoading();
    try {
      int index = state.matches?.indexWhere((t) => t.id == event.matchId) ?? -1;

      if (index == -1) {
        BotToast.showText(text: "Invalid match id!!!");
      } else {
        bool isDeleted = await _deleteMatchUseCase.call(event.matchId);
        if (isDeleted) {
          List<FootballMatch>? matches = state.matches;
          FootballMatch? selectedMatch = state.selectedMatch;
          int? selectedIndex = state.selectedIndex;

          selectedIndex = index;
          matches?.removeAt(index);
          if ((matches ?? []).isEmpty) {
            add(CreateNewMatchEvent());
          } else {
            int length = matches?.length ?? 0;
            if (length <= index) {
              selectedIndex = index - 1;
            }
            selectedMatch = matches?.elementAt(selectedIndex);
            emit(
              state.copyWith(
                matches: matches,
                selectedMatch: selectedMatch,
                selectedIndex: selectedIndex,
              ),
            );
          }
        } else {
          BotToast.showText(text: "Something went wrong!");
        }
      }
    } catch (e) {
      BotToast.showText(text: "Something went wrong! $e");
    }

    BotToast.cleanAll();
  }
}
