import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/core/services/navigation_service.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/match/domain/usecases/clear_match_db_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/create_new_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/create_period_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_period_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_sub_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_tactical_board/app/core/dialogs/confirmation_dialog.dart';
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
  UpdateMatchPeriodUseCase _updateMatchPeriodUseCase;
  MatchBloc({
    required FetchMatchUsecase fetchMatchUsecase,
    required UpdateMatchScoreUsecase updateMatchScoreUsecase,
    required UpdateMatchTimeUsecase updateMatchTimeUsecase,
    required CreateNewMatchUseCase createNewMatchUseCase,
    required DeleteMatchUseCase deleteMatchUseCase,
    required ClearMatchDbUseCase clearMatchDbUseCase,
    required UpdateSubUseCase updateSubUseCase,
    required CreatePeriodUseCase createPeriodUseCase,
    required UpdateMatchPeriodUseCase updateMatchPeriodUseCase,
  }) : _fetchMatchUsecase = fetchMatchUsecase,
       _updateMatchScoreUsecase = updateMatchScoreUsecase,
       _updateMatchTimeUsecase = updateMatchTimeUsecase,
       _createNewMatchUseCase = createNewMatchUseCase,
       _deleteMatchUseCase = deleteMatchUseCase,
       _clearMatchDbUseCase = clearMatchDbUseCase,
       _updateSubUseCase = updateSubUseCase,
       _createPeriodUseCase = createPeriodUseCase,
       _updateMatchPeriodUseCase = updateMatchPeriodUseCase,
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
    on<IncreaseExtraTimeEvent>(_increaseExtraTime);
    on<DecreaseExtraTimeEvent>(_decreaseExtraTime);
    on<TimerRunOutEvent>(_onTimerRunOut);
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
      bool proceedToStart = true;
      if (event.matchTimeUpdateStatus == MatchTimeUpdateStatus.START) {
        // cross check if any timer is running or not
        List<MatchPeriod> runningPeriods = MatchUtils.checkAnyTimerRunning(
          match: footballMatch,
        );

        // If any timers are already running, ask for confirmation
        if (runningPeriods.isNotEmpty) {
          String runningTimersString;
          String dialogTitle;
          String dialogContent;

          // --- Construct Dialog Message ---
          if (runningPeriods.length == 1) {
            // Message for a single running timer
            final period = runningPeriods[0];
            runningTimersString =
                "Period ${period.periodNumber + 1}${period.extraPeriodStatus == TimeActiveStatus.RUNNING ? " (extra)" : ""}";
            dialogTitle = "Timer Already Running!";
            dialogContent =
                "Another timer ($runningTimersString) is currently active. Starting this timer will automatically stop the running one. Do you want to continue?";
          } else {
            // Message for multiple running timers
            runningTimersString = runningPeriods
                .map((period) {
                  return "Period ${period.periodNumber + 1}${period.extraPeriodStatus == TimeActiveStatus.RUNNING ? " (extra)" : ""}";
                })
                .join(
                  ", ",
                ); // Join with commas, e.g., "Period 1, Period 2 (extra)"
            dialogTitle = "Multiple Timers Running!";
            dialogContent =
                "The following timers are currently active: $runningTimersString. Starting this timer will automatically stop all running timers. Do you want to continue?";
          }
          // --- End Message Construction ---

          // --- Show Confirmation ---
          // Ensure you have a valid context, NavigationService.instance.currentContext might be risky if not guaranteed
          final context = NavigationService.instance.currentContext;
          bool? confirm;
          if (context != null && context.mounted) {
            // Check context validity
            confirm = await showConfirmationDialog(
              context: context,
              title: dialogTitle,
              content: dialogContent,
              confirmButtonText: "Stop Running & Start",
              cancelButtonText: "Cancel",
            );
          }

          // --- Handle Confirmation ---
          if (confirm == true) {
            zlog(
              data:
                  "User confirmed stopping ${runningPeriods.length} running timer(s).",
            );
            // Attempt to stop ALL currently running timers
            for (final periodToStop in runningPeriods) {
              try {
                zlog(
                  data:
                      "Stopping timer for Period ${periodToStop.periodNumber + 1} (Mode: ${periodToStop.extraPeriodStatus == TimeActiveStatus.RUNNING ? TimerMode.EXTRA : TimerMode.UP})...",
                );
                // Re-fetch the latest match state before stopping? Or assume footballMatch is current enough?
                // For simplicity, assume footballMatch is reasonably current.
                await _updateMatchTimeUsecase.call(
                  UpdateMatchTimeRequest(
                    matchId: footballMatch?.id ?? "",
                    // Pass the potentially modified footballMatch object from the Bloc's state if needed
                    footballMatch:
                        footballMatch!, // Use the currently held match object
                    matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                    matchPeriodId:
                        periodToStop.periodNumber, // ID of the period to stop
                    timerMode:
                        periodToStop.extraPeriodStatus ==
                                TimeActiveStatus.RUNNING
                            ? TimerMode
                                .EXTRA // Determine mode from the period being stopped
                            : TimerMode.UP,
                  ),
                );
                zlog(
                  data:
                      "Stopped timer for Period ${periodToStop.periodNumber + 1}.",
                );
                // Small delay might prevent rapid Firestore updates if needed, but often unnecessary
                // await Future.delayed(const Duration(milliseconds: 50));
              } catch (e) {
                BotToast.showText(
                  text:
                      "Error stopping timer for Period ${periodToStop.periodNumber + 1}.",
                );
                // If stopping fails, should we prevent the new timer from starting?
                proceedToStart = false;
                break; // Exit the loop if one stop fails
              }
            }
          } else {
            // User cancelled the confirmation dialog
            zlog(
              data: "User cancelled starting new timer due to running timers.",
            );
            proceedToStart = false; // Do not proceed to start the new timer
          }
        }
      }

      if (proceedToStart == true) {
        FootballMatch updatedMatch = await _updateMatchTimeUsecase.call(
          UpdateMatchTimeRequest(
            matchId: footballMatch?.id ?? "",
            footballMatch: footballMatch!,
            matchTimeUpdateStatus: event.matchTimeUpdateStatus,
            matchPeriodId: event.periodId,
            timerMode: event.timerMode,
          ),
        );

        add(UpdateMatchEvent(footballMatch: updatedMatch));
      }
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
      extraTime: ExtraTime(presetDuration: Duration(minutes: 3), intervals: []),
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

  FutureOr<void> _increaseExtraTime(
    IncreaseExtraTimeEvent event,
    Emitter<MatchState> emit,
  ) async {
    FootballMatch? match = state.match;
    MatchPeriod? matchPeriod = state.selectedPeriod;
    if (matchPeriod != null) {
      ExtraTime extraTime = matchPeriod.extraTime;
      Duration duration = extraTime.presetDuration;
      extraTime = extraTime.copyWith(
        presetDuration: duration + Duration(minutes: 1),
      );
      matchPeriod = matchPeriod.copyWith(extraTime: extraTime);
      matchPeriod = await _updateMatchPeriodUseCase.call(matchPeriod);

      if (match != null) {
        match = _updatePeriods(match, matchPeriod);
      }

      emit(state.copyWith(selectedPeriod: matchPeriod, match: match));
    }
  }

  FootballMatch _updatePeriods(FootballMatch match, MatchPeriod matchPeriod) {
    List<MatchPeriod> matchPeriods = match.matchPeriod;
    int index = matchPeriods.indexWhere(
      (t) => t.periodNumber == matchPeriod.periodNumber,
    );
    if (index != -1) {
      matchPeriods[index] = matchPeriod;
      match.matchPeriod = matchPeriods;
    }
    return match;
  }

  FutureOr<void> _decreaseExtraTime(
    DecreaseExtraTimeEvent event,
    Emitter<MatchState> emit,
  ) async {
    FootballMatch? match = state.match;
    MatchPeriod? matchPeriod = state.selectedPeriod;
    if (matchPeriod != null) {
      ExtraTime extraTime = matchPeriod.extraTime;
      Duration duration = extraTime.presetDuration;

      extraTime = extraTime.copyWith(
        presetDuration: duration - Duration(minutes: 1),
      );

      if (duration.inMinutes > 1) {
        matchPeriod = matchPeriod.copyWith(extraTime: extraTime);
        matchPeriod = await _updateMatchPeriodUseCase.call(matchPeriod);
        if (match != null) {
          match = _updatePeriods(match, matchPeriod);
        }
        emit(state.copyWith(selectedPeriod: matchPeriod, match: match));
      }
    }
  }

  FutureOr<void> _onTimerRunOut(
    TimerRunOutEvent event,
    Emitter<MatchState> emit,
  ) {}
}
