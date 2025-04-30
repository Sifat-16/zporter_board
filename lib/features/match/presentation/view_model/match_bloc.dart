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
import 'package:zporter_board/features/match/domain/usecases/create_period_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_sub_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  FetchMatchUsecase _fetchMatchUsecase;
  UpdateMatchScoreUsecase _updateMatchScoreUsecase;
  UpdateMatchTimeUsecase _updateMatchTimeUsecase;
  CreateNewMatchUseCase _createNewMatchUseCase;
  DeleteMatchUseCase _deleteMatchUseCase;
  ClearMatchDbUseCase _clearMatchDbUseCase;
  UpdateSubUseCase _updateSubUseCase;
  CreatePeriodUseCase _createPeriodUseCase;
  MatchBloc({
    required FetchMatchUsecase fetchMatchUsecase,
    required UpdateMatchScoreUsecase updateMatchScoreUsecase,
    required UpdateMatchTimeUsecase updateMatchTimeUsecase,
    required CreateNewMatchUseCase createNewMatchUseCase,
    required DeleteMatchUseCase deleteMatchUseCase,
    required ClearMatchDbUseCase clearMatchDbUseCase,
    required UpdateSubUseCase updateSubUseCase,
    required CreatePeriodUseCase createPeriodUseCase,
  }) : _fetchMatchUsecase = fetchMatchUsecase,
       _updateMatchScoreUsecase = updateMatchScoreUsecase,
       _updateMatchTimeUsecase = updateMatchTimeUsecase,
       _createNewMatchUseCase = createNewMatchUseCase,
       _deleteMatchUseCase = deleteMatchUseCase,
       _clearMatchDbUseCase = clearMatchDbUseCase,
       _updateSubUseCase = updateSubUseCase,
       _createPeriodUseCase = createPeriodUseCase,
       super(MatchState.initial()) {
    on<MatchLoadEvent>(_onLoadMatches);
    on<MatchPeriodSelectEvent>(_onMatchPeriodSelected);
    on<MatchScoreUpdateEvent>(_onMatchScoreUpdate);
    on<MatchUpdateEvent>(_onMatchUpdate);
    on<MatchTimeUpdateEvent>(_onMatchTimeUpdate);
    on<CreateNewMatchEvent>(_createNewMatch);
    on<DeleteMatchEvent>(_deleteMatch);
    on<UpdateMatchEvent>(_updateMatch);
    on<ClearMatchDbEvent>(_clearMatchDb);
    on<SubUpdateEvent>(_subUpdate);
    on<CreateNewPeriodEvent>(_createNewPeriod);
    on<ChangePeriodModeEvent>(_changePeriodMode);
  }

  FutureOr<void> _onLoadMatches(
    MatchLoadEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      FootballMatch? match = await _fetchMatchUsecase.call(null);

      MatchPeriod? selectedPeriod = match.matchPeriod.firstOrNull;

      emit(
        state.copyWith(
          match: match,
          selectedPeriod: selectedPeriod,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(failureMessage: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> _onMatchPeriodSelected(
    MatchPeriodSelectEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      MatchPeriod? selectedPeriod = state.match?.matchPeriod[event.index];
      emit(
        state.copyWith(
          selectedPeriod: selectedPeriod,
          selectedPeriodId: selectedPeriod?.periodNumber,
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
      FootballMatch? footballMatch = state.match;
      FootballMatch updatedMatch = await _updateMatchTimeUsecase.call(
        UpdateMatchTimeRequest(
          matchId: footballMatch?.id ?? "",
          footballMatch: footballMatch!,
          matchTimeUpdateStatus: event.matchTimeUpdateStatus,
          matchPeriodId: event.periodId,
        ),
      );
      zlog(data: "Updated match time status ${updatedMatch.status}");
      add(UpdateMatchEvent(footballMatch: updatedMatch));
    } catch (e) {
      debug(data: "Error while updating time ${e.toString()}");
    }
  }

  FutureOr<void> _updateMatch(
    UpdateMatchEvent event,
    Emitter<MatchState> emit,
  ) {
    FootballMatch match = event.footballMatch;
    MatchPeriod? matchPeriod = state.selectedPeriod;
    if (matchPeriod != null) {
      int index = match.matchPeriod.indexWhere(
        (p) => p.periodNumber == matchPeriod?.periodNumber,
      );
      if (index != -1) {
        matchPeriod = match.matchPeriod[index];
      }
    }
    emit(
      state.copyWith(match: event.footballMatch, selectedPeriod: matchPeriod),
    );
  }

  FutureOr<void> _createNewMatch(
    CreateNewMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    BotToast.showLoading();
    try {
      FootballMatch newMatch = await _createNewMatchUseCase.call(null);

      emit(
        state.copyWith(
          match: newMatch,
          selectedPeriod: newMatch.matchPeriod.first,
          selectedPeriodId: newMatch.matchPeriod.first.periodNumber,
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
      bool isDeleted = await _deleteMatchUseCase.call(state.match?.id ?? "");
      if (isDeleted) {
        add(MatchLoadEvent());
      } else {
        BotToast.showText(text: "Something went wrong!");
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

  FutureOr<void> _createNewPeriod(
    CreateNewPeriodEvent event,
    Emitter<MatchState> emit,
  ) async {
    FootballMatch? match = state.match;
    List<MatchPeriod> periods = match?.matchPeriod ?? [];
    int index = 0;
    for (var p in periods) {
      if (p.periodNumber > index) {
        index = p.periodNumber;
      }
    }
    MatchPeriod newMatchPeriod = MatchPeriod(
      periodNumber: index + 1,
      timerMode: TimerMode.UP,
      intervals: [],
    );
    newMatchPeriod = await _createPeriodUseCase.call(newMatchPeriod);
    periods.add(newMatchPeriod);

    match?.matchPeriod = periods;
    MatchPeriod selectedPeriod = newMatchPeriod;
    int selectedPeriodId = newMatchPeriod.periodNumber;

    if (match != null) {
      add(UpdateMatchEvent(footballMatch: match));
    }

    emit(
      state.copyWith(
        selectedPeriod: selectedPeriod,
        selectedPeriodId: selectedPeriodId,
      ),
    );
  }

  FutureOr<void> _changePeriodMode(
    ChangePeriodModeEvent event,
    Emitter<MatchState> emit,
  ) {
    MatchPeriod? matchPeriod = state.selectedPeriod;
    matchPeriod = matchPeriod?.copyWith(timerMode: event.newMode);
    emit(state.copyWith(selectedPeriod: matchPeriod));
  }
}
