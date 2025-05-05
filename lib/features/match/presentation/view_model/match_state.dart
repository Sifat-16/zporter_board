import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart'; // Assuming this import is correct

// Define the status enum (re-added for completeness)
// Sentinel object used to detect if a parameter was provided to copyWith
const Object _sentinel = Object();

class MatchState {
  final FootballMatch? match;
  final int?
  selectedPeriodId; // Index of the selected match in the 'matches' list
  final MatchPeriod? selectedPeriod; // The actual selected match object
  final String? failureMessage;
  final bool isLoading;

  // Constructor with required status and optional data fields
  const MatchState({
    this.match,
    this.selectedPeriodId,
    this.selectedPeriod,
    this.failureMessage,
    this.isLoading = false,
  });

  // Factory constructor for the initial state
  factory MatchState.initial() {
    return const MatchState(
      match: null,
      selectedPeriodId: null,
      selectedPeriod: null,
      failureMessage: null,
      isLoading: false,
    );
  }

  // copyWith method using the sentinel pattern for nullable fields
  MatchState copyWith({
    Object? match = _sentinel,
    Object? selectedPeriodId = _sentinel,
    Object? selectedPeriod = _sentinel,
    Object? failureMessage = _sentinel,
    bool? isLoading,
  }) {
    return MatchState(
      match: match == _sentinel ? this.match : match as FootballMatch?,
      selectedPeriodId:
          selectedPeriodId == _sentinel
              ? this.selectedPeriodId
              : selectedPeriodId as int?,
      selectedPeriod:
          selectedPeriod == _sentinel
              ? this.selectedPeriod
              : selectedPeriod as MatchPeriod?,
      failureMessage:
          failureMessage == _sentinel
              ? this.failureMessage
              : failureMessage as String?,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
