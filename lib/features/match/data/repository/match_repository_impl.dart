import 'package:zporter_board/core/services/user_id_service.dart'; // Import UserIdService
import 'package:zporter_board/core/utils/log/debugger.dart'; // For logging
// Assuming MatchDataSource is the interface (adjust if not)
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart'; // For MatchPeriod
import 'package:zporter_tactical_board/app/helper/logger.dart'; // Assuming zlog is logger

class MatchRepositoryImpl implements MatchRepository {
  final MatchDataSource _remoteDataSource; // For Firebase operations
  final MatchDataSource _localDataSource; // For Sembast operations
  final UserIdService _userIdService; // To get user ID if needed

  MatchRepositoryImpl({
    required MatchDataSource remoteDataSource,
    required MatchDataSource localDataSource,
    required UserIdService userIdService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _userIdService = userIdService;

  // Helper to get user ID
  String _getCurrentUserId() => _userIdService.getCurrentUserId();

  @override
  Future<FootballMatch> getDefaultMatch() async {
    debug(data: "Repo: Getting single/default match from Local first...");
    try {
      // 1. Get (or create if needed) the match from the local source
      final FootballMatch localMatch = await _localDataSource.getDefaultMatch();
      debug(
        data: "Repo: Local getDefaultMatch successful (ID: ${localMatch.id})",
      );

      // 2. Attempt to sync this local state to remote (fire-and-forget)
      _trySyncLocalToRemote(); // Use the existing helper

      // 3. Return the local result immediately
      return localMatch;
    } catch (e) {
      // Catch errors from the local data source operation
      debug(data: "Repo: Error during local getDefaultMatch: $e");
      // Re-throw the exception as this indicates a problem with local storage
      throw Exception("Failed to get local match data: $e");
    }
  }

  // --- WRITE Operations: Local first, then Fetch Local, then TRY Remote Sync ---

  /// Helper function to attempt syncing the latest local match state to remote.
  /// Errors are caught and logged silently.
  Future<void> _trySyncLocalToRemote() async {
    debug(data: "Repo: Attempting to sync local match state to remote...");
    try {
      // 1. Fetch the definitive current state from local
      final FootballMatch latestLocalMatch =
          await _localDataSource.getDefaultMatch();
      // 2. Attempt to save/overwrite this state remotely
      //    Use createMatch on remote which should handle set/overwrite for the user's doc
      await _remoteDataSource.createMatch(footballMatch: latestLocalMatch);
      debug(data: "Repo: Remote sync successful.");
    } catch (e) {
      debug(
        data:
            "Repo: Remote sync failed: $e. Will retry when online (Firestore persistence).",
      );
    }
  }

  @override
  Future<FootballMatch> createMatch({FootballMatch? footballMatch}) async {
    debug(data: "Repo: Creating match locally first...");
    // 1. Create locally
    FootballMatch? matchWithUserId = footballMatch?.copyWith(
      userId: _getCurrentUserId(),
    );
    final FootballMatch localCreatedMatch = await _localDataSource.createMatch(
      footballMatch: matchWithUserId ?? footballMatch,
    );
    debug(
      data:
          "Repo: Local match creation completed (ID: ${localCreatedMatch.id})",
    );

    // 2. Attempt remote sync (fire-and-forget style)
    _trySyncLocalToRemote(); // No need to await this

    // 3. Return the result from the local operation immediately
    return localCreatedMatch;
  }

  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    debug(
      data:
          "Repo: Updating match score locally first (Match ID: ${updateMatchScoreRequest.matchId})...",
    );
    // 1. Update locally
    final FootballMatch updatedLocalMatch = await _localDataSource
        .updateMatchScore(updateMatchScoreRequest);
    debug(data: "Repo: Local score update completed.");

    // 2. Attempt remote sync
    _trySyncLocalToRemote();

    // 3. Return local result
    return updatedLocalMatch;
  }

  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    debug(
      data:
          "Repo: Updating match time locally first (Match ID: ${updateMatchTimeRequest.matchId})...",
    );
    // 1. Update locally
    final FootballMatch updatedLocalMatch = await _localDataSource
        .updateMatchTime(updateMatchTimeRequest);
    debug(data: "Repo: Local time update completed.");
    zlog(
      data:
          "Repo: Local Timer data updated match time length : ${updatedLocalMatch.matchPeriod.length}",
    );

    // 2. Attempt remote sync
    _trySyncLocalToRemote();

    // 3. Return local result
    return updatedLocalMatch;
  }

  @override
  Future<FootballMatch> updateSub(UpdateSubRequest updateSubRequest) async {
    debug(
      data:
          "Repo: Updating substitutions locally first (Match ID: ${updateSubRequest.matchId})...",
    );
    // 1. Update locally
    final FootballMatch updatedLocalMatch = await _localDataSource.updateSub(
      updateSubRequest,
    );
    debug(data: "Repo: Local substitution update completed.");

    // 2. Attempt remote sync
    _trySyncLocalToRemote();

    // 3. Return local result
    return updatedLocalMatch;
  }

  @override
  Future<bool> deleteMatch(String matchId) async {
    // For delete, the pattern is slightly different.
    // We delete locally, then attempt remote delete.
    // There's no "latest local state" to sync after deletion.
    debug(data: "Repo: Deleting match locally first (Match ID: $matchId)...");
    bool localDeleteSuccess = false;
    try {
      // 1. Always attempt local delete first
      localDeleteSuccess = await _localDataSource.deleteMatch(matchId);
      debug(data: "Repo: Local delete result: $localDeleteSuccess");
      if (!localDeleteSuccess) {}
    } catch (e) {
      debug(data: "Repo: Local delete failed: $e");
      return false; // Return false if local delete fails critically
    }

    // 2. Attempt remote delete if local succeeded or didn't throw error
    if (localDeleteSuccess) {
      debug(data: "Repo: Attempting remote delete (background sync)...");
      _remoteDataSource
          .deleteMatch(matchId)
          .then((remoteSuccess) {
            debug(data: "Repo: Remote delete sync result: $remoteSuccess");
            if (!remoteSuccess) {
              // This might happen if already deleted remotely, or permissions etc.
              // Firestore offline queue handles retries if it was a network issue.
            }
          })
          .catchError((e) {
            debug(
              data:
                  "Repo: Remote delete sync failed: $e. Will retry when online.",
            );
          });
    }

    // 3. Return the success status of the *local* operation
    return localDeleteSuccess;
  }

  @override
  Future<int> clearMatchDb() async {
    // Only clear local database
    debug(data: "Repo: Clearing local match database.");
    int count = await _localDataSource.clearMatchDb();
    // Also attempt to delete the single remote doc if applicable
    if (count > 0) {
      // Only try remote delete if local delete did something
      debug(
        data:
            "Repo: Attempting remote delete after local clear (background sync)...",
      );
      _remoteDataSource
          .deleteMatch(_getCurrentUserId())
          .then((_) {
            debug(data: "Repo: Remote delete sync after clear successful.");
          })
          .catchError((e) {
            debug(data: "Repo: Remote delete sync after clear failed: $e.");
            // No toast needed here? User initiated clear.
          });
    }
    return count;
  }

  @override
  Future<MatchPeriod> createNewPeriod({
    required MatchPeriod matchPeriod,
  }) async {
    debug(data: "Repo: Creating new period locally first...");
    // 1. Create locally
    final MatchPeriod localCreatedPeriod = await _localDataSource
        .createNewPeriod(matchPeriod: matchPeriod);
    debug(data: "Repo: Local period creation completed.");

    // 2. Attempt remote sync of the *entire match* state
    _trySyncLocalToRemote();

    // 3. Return local result
    return localCreatedPeriod;
  }

  @override
  Future<MatchPeriod> updatePeriod(MatchPeriod matchPeriod) async {
    debug(data: "Repo: Updating period locally first...");
    // 1. Update locally
    final MatchPeriod updatedLocalPeriod = await _localDataSource.updatePeriod(
      matchPeriod,
    );
    debug(data: "Repo: Local period update completed.");

    // 2. Attempt remote sync of the *entire match* state
    _trySyncLocalToRemote();

    // 3. Return local result
    return updatedLocalPeriod;
  }
}
