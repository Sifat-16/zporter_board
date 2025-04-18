import 'package:zporter_board/features/match/data/model/football_match.dart'; // Assuming this import is correct

// Define the status enum (re-added for completeness)
// Sentinel object used to detect if a parameter was provided to copyWith
const Object _sentinel = Object();

class MatchState {
  final List<FootballMatch>? matches;
  final int? selectedIndex; // Index of the selected match in the 'matches' list
  final FootballMatch? selectedMatch; // The actual selected match object
  final String? failureMessage;
  final bool isLoading;

  // Constructor with required status and optional data fields
  const MatchState({
    this.matches,
    this.selectedIndex,
    this.selectedMatch,
    this.failureMessage,
    this.isLoading = false,
  });

  // Factory constructor for the initial state
  factory MatchState.initial() {
    return const MatchState(
      matches: [],
      selectedIndex: null,
      selectedMatch: null,
      failureMessage: null,
      isLoading: false,
    );
  }

  // copyWith method using the sentinel pattern for nullable fields
  MatchState copyWith({
    Object? matches = _sentinel,
    Object? selectedIndex = _sentinel,
    Object? selectedMatch = _sentinel,
    Object? failureMessage = _sentinel,
    bool? isLoading,
  }) {
    return MatchState(
      matches:
          matches == _sentinel ? this.matches : matches as List<FootballMatch>?,
      selectedIndex:
          selectedIndex == _sentinel
              ? this.selectedIndex
              : selectedIndex as int?,
      selectedMatch:
          selectedMatch == _sentinel
              ? this.selectedMatch
              : selectedMatch as FootballMatch?,
      failureMessage:
          failureMessage == _sentinel
              ? this.failureMessage
              : failureMessage as String?,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
