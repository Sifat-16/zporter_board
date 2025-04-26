import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/match/domain/usecases/clear_match_db_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/create_new_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_sub_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  FetchMatchUsecase _fetchMatchUsecase;
  UpdateMatchScoreUsecase _updateMatchScoreUsecase;
  UpdateMatchTimeUsecase _updateMatchTimeUsecase;
  CreateNewMatchUseCase _createNewMatchUseCase;
  DeleteMatchUseCase _deleteMatchUseCase;
  ClearMatchDbUseCase _clearMatchDbUseCase;
  UpdateSubUseCase _updateSubUseCase;
  MatchBloc({
    required FetchMatchUsecase fetchMatchUsecase,
    required UpdateMatchScoreUsecase updateMatchScoreUsecase,
    required UpdateMatchTimeUsecase updateMatchTimeUsecase,
    required CreateNewMatchUseCase createNewMatchUseCase,
    required DeleteMatchUseCase deleteMatchUseCase,
    required ClearMatchDbUseCase clearMatchDbUseCase,
    required UpdateSubUseCase updateSubUseCase,
  }) : _fetchMatchUsecase = fetchMatchUsecase,
       _updateMatchScoreUsecase = updateMatchScoreUsecase,
       _updateMatchTimeUsecase = updateMatchTimeUsecase,
       _createNewMatchUseCase = createNewMatchUseCase,
       _deleteMatchUseCase = deleteMatchUseCase,
       _clearMatchDbUseCase = clearMatchDbUseCase,
       _updateSubUseCase = updateSubUseCase,
       super(MatchState.initial()) {
    on<MatchLoadEvent>(_onLoadMatches);
    on<MatchSelectEvent>(_onMatchSelected);
    on<MatchScoreUpdateEvent>(_onMatchScoreUpdate);
    on<MatchUpdateEvent>(_onMatchUpdate);
    on<MatchTimeUpdateEvent>(_onMatchTimeUpdate);
    on<CreateNewMatchEvent>(_createNewMatch);
    on<DeleteMatchEvent>(_deleteMatch);
    on<UpdateMatchEvent>(_updateMatch);
    on<ClearMatchDbEvent>(_clearMatchDb);
    on<SubUpdateEvent>(_subUpdate);
  }

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
    FootballMatch? selectedMatch = state.selectedMatch;
    int index =
        matches?.indexWhere((m) => m.id == event.footballMatch.id) ?? -1;
    if (index != -1) {
      matches?[index] = event.footballMatch;

      if (selectedMatch?.id == matches?[index].id) {
        selectedMatch = matches?[index];
      }
    }

    emit(state.copyWith(matches: matches, selectedMatch: selectedMatch));
  }

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
      selectedIndex = (matches?.length ?? 0) - 1;

      zlog(data: "Selected index ${selectedMatch?.id} - ${newMatch.id}");

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
            zlog(data: "Matches are empty called new match");
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

  FutureOr<void> _clearMatchDb(
    ClearMatchDbEvent event,
    Emitter<MatchState> emit,
  ) async {
    await _clearMatchDbUseCase.call(null);
    add(MatchLoadEvent());
  }

  FutureOr<void> _subUpdate(
    SubUpdateEvent event,
    Emitter<MatchState> emit,
  ) async {
    zlog(data: "Bloc: Handling SubUpdateEvent for match ${event.matchId}");

    try {
      // 1. Prepare the request object for the use case
      final UpdateSubRequest request = UpdateSubRequest(
        matchId: event.matchId,
        matchSubstitutions: event.matchSubstitutions,
      );

      // 2. Call the use case to perform the update via the repository
      // The use case should return the fully updated FootballMatch object
      final FootballMatch updatedMatch = await _updateSubUseCase.call(request);
      zlog(
        data:
            "Bloc: Substitution update successful via use case for match ${updatedMatch.id}",
      );

      // 3. Trigger the internal state update handler with the latest match data
      // This reuses the logic in _updateMatch to keep the state consistent
      add(UpdateMatchEvent(footballMatch: updatedMatch));
    } catch (e, stackTrace) {
      // Catch potential errors from use case/repository
      zlog(data: "Bloc Error: Failed to update substitutions: $e\n$stackTrace");
      // Show error feedback to the user
      BotToast.showText(text: "Error updating substitutions: ${e.toString()}");
      // Optionally emit a state indicating failure
      // emit(state.copyWith(failureMessage: e.toString(), isLoading: false)); // Need isLoading if using loading state
    } finally {
      // Ensure loading indicator is always removed
    }
  }
}
