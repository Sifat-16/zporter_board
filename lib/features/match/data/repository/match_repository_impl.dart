import 'package:bot_toast/bot_toast.dart'; // For user feedback
import 'package:zporter_board/core/services/user_id_service.dart'; // Import UserIdService
import 'package:zporter_board/core/utils/log/debugger.dart'; // For logging
// Assuming MatchDataSource is the interface both implement (adjust if not)
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
// Keep other necessary imports
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchDataSource _remoteDataSource; // For Firebase operations
  final MatchDataSource
  _localDataSource; // For Sembast operations (use concrete type if it has extra methods like sync helpers)
  final UserIdService _userIdService; // To check login status and get ID

  MatchRepositoryImpl({
    // Use specific types or instance names from GetIt
    required MatchDataSource remoteDataSource,
    required MatchDataSource localDataSource,
    required UserIdService userIdService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _userIdService = userIdService;

  // Helper to get current status
  bool _isLoggedIn() => _userIdService.isFirebaseLoggedIn();
  String _getCurrentUserId() => _userIdService.getCurrentUserId();

  // @override
  // Future<List<FootballMatch>> getAllMatches() async {
  //   final userId = _getCurrentUserId(); // Needed for remote query
  //
  //   if (_isLoggedIn()) {
  //     try {
  //       // Prioritize fetching from remote when online
  //       debug(data: "Repo: Getting matches from Remote for user $userId");
  //       final remoteMatches =
  //           await _remoteDataSource.getAllMatches(); // Pass userId
  //
  //       // Optional: Background sync to ensure local is up-to-date with remote
  //       // This is more complex, involves comparing lists, adding/updating/deleting locally.
  //       // For now, just return remote data when online.
  //
  //       return remoteMatches;
  //     } catch (e) {
  //       debug(
  //         data: "Repo: Remote getAllMatches failed: $e. Falling back to local.",
  //       );
  //       BotToast.showText(
  //         text: "Couldn't fetch latest data, showing offline matches.",
  //       );
  //       // Fallback to local storage on error
  //       return await _localDataSource
  //           .getAllMatches(); // Doesn't need userId param based on your impl
  //     }
  //   } else {
  //     // Offline: Fetch directly from local
  //     debug(data: "Repo: Getting matches from Local (offline)");
  //     return await _localDataSource
  //         .getAllMatches(); // Doesn't need userId param based on your impl
  //   }
  // }

  @override
  Future<FootballMatch> createMatch() async {
    final userId = _getCurrentUserId(); // Get ID for potential remote operation

    debug(data: "Repo: Creating match locally first...");
    // 1. Always create locally first
    final localMatch =
        await _localDataSource
            .createMatch(); // Doesn't need userId param based on your impl

    if (_isLoggedIn()) {
      // 2. If online, attempt to create remotely
      debug(
        data:
            "Repo: User is online, attempting to create match remotely for user $userId",
      );
      try {
        // We pass the data from the locally created match.
        // The remote source might assign its own ID.
        final remoteMatch =
            await _remoteDataSource.createMatch(); // Pass userId and data
        debug(
          data:
              "Repo: Remote match creation successful (ID: ${remoteMatch.id})",
        );
        // Return the remote match data (contains Firestore ID if different)
        return remoteMatch;
      } catch (e) {
        debug(
          data: "Repo: Remote match creation failed: $e. Match saved locally.",
        );
        BotToast.showText(text: "Match saved locally, sync failed.");
        // Return the local match if remote fails
        return localMatch;
      }
    } else {
      // 3. If offline, return the locally created match
      debug(data: "Repo: User is offline. Match only saved locally.");
      return localMatch;
    }
  }

  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    final userId = _getCurrentUserId(); // For potential remote operation

    // 1. Always update locally
    final updatedLocalMatch = await _localDataSource.updateMatchScore(
      updateMatchScoreRequest,
    );

    debug(
      data:
          "Repo: Updating match score locally first (Match ID: ${updateMatchScoreRequest.matchId})...",
    );

    if (_isLoggedIn()) {
      // 2. If online, attempt to update remotely
      debug(
        data:
            "Repo: User is online, attempting to update score remotely for user $userId",
      );
      try {
        final updatedRemoteMatch = await _remoteDataSource.updateMatchScore(
          updateMatchScoreRequest,
        ); // Pass userId
        debug(data: "Repo: Remote score update successful.");
        return updatedRemoteMatch; // Return remote version
      } catch (e) {
        debug(
          data: "Repo: Remote score update failed: $e. Score updated locally.",
        );
        BotToast.showText(text: "Score updated locally, sync failed.");
        return updatedLocalMatch; // Return local version on failure
      }
    } else {
      // 3. If offline, return the locally updated match
      debug(data: "Repo: User is offline. Score only updated locally.");
      return updatedLocalMatch;
    }
  }

  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    final userId = _getCurrentUserId(); // For potential remote operation

    debug(
      data:
          "Repo: Updating match time locally first (Match ID: ${updateMatchTimeRequest.matchId})...",
    );
    // 1. Always update locally
    final updatedLocalMatch = await _localDataSource.updateMatchTime(
      updateMatchTimeRequest,
    );

    if (_isLoggedIn()) {
      // 2. If online, attempt to update remotely
      debug(
        data:
            "Repo: User is online, attempting to update time remotely for user $userId",
      );
      try {
        final updatedRemoteMatch = await _remoteDataSource.updateMatchTime(
          updateMatchTimeRequest,
        ); // Pass userId
        debug(data: "Repo: Remote time update successful.");
        return updatedRemoteMatch; // Return remote version
      } catch (e) {
        debug(
          data: "Repo: Remote time update failed: $e. Time updated locally.",
        );
        BotToast.showText(text: "Time updated locally, sync failed.");
        return updatedLocalMatch; // Return local version on failure
      }
    } else {
      // 3. If offline, return the locally updated match
      debug(data: "Repo: User is offline. Time only updated locally.");
      zlog(
        data:
            "Timer data updated match time length : ${updatedLocalMatch.matchPeriod.length} from repository",
      );
      return updatedLocalMatch;
    }
  }

  @override
  Future<bool> deleteMatch(String matchId) async {
    final userId = _getCurrentUserId(); // For potential remote operation
    bool remoteDeleteSuccess = false;
    bool localDeleteSuccess = false;

    if (_isLoggedIn()) {
      // 1. If online, attempt remote delete FIRST (safer)
      debug(
        data:
            "Repo: User is online, attempting remote delete first for match $matchId user $userId",
      );
      try {
        remoteDeleteSuccess = await _remoteDataSource.deleteMatch(
          matchId,
        ); // Pass userId
        debug(data: "Repo: Remote delete result: $remoteDeleteSuccess");
      } catch (e) {
        debug(data: "Repo: Remote delete failed: $e");
        remoteDeleteSuccess = false;
        // Don't proceed to local delete if remote failed? Or allow local delete anyway?
        // Let's allow local delete even if remote fails for now, user might want it gone locally.
        BotToast.showText(text: "Couldn't delete from cloud, trying local.");
      }
    } else {
      debug(
        data:
            "Repo: User is offline, skipping remote delete for match $matchId",
      );
      // If offline, we only care about local deletion success later
      remoteDeleteSuccess =
          true; // Treat as "success" in terms of allowing local delete attempt
    }

    // 2. Proceed with local delete if remote succeeded OR if offline OR if remote failed but we still want to try local
    // Simplified: Always try local delete. Success depends on context.
    if (remoteDeleteSuccess || !_isLoggedIn()) {
      // If remote worked OR we are offline
      debug(data: "Repo: Attempting local delete for match $matchId");
      try {
        localDeleteSuccess = await _localDataSource.deleteMatch(
          matchId,
        ); // Doesn't need userId param
        debug(data: "Repo: Local delete result: $localDeleteSuccess");
      } catch (e) {
        debug(data: "Repo: Local delete failed: $e");
        localDeleteSuccess = false;
        if (_isLoggedIn()) {
          BotToast.showText(
            text: "Failed to delete locally after cloud delete.",
          );
        } else {
          BotToast.showText(text: "Failed to delete locally.");
        }
      }
    }
    if (_isLoggedIn()) {
      return remoteDeleteSuccess &&
          localDeleteSuccess; // Stricter: Both must succeed if online
    } else {
      return localDeleteSuccess;
    }
  }

  @override
  Future<int> clearMatchDb() async {
    return _localDataSource.clearMatchDb();
  }

  @override
  Future<FootballMatch> updateSub(UpdateSubRequest updateSubRequest) async {
    final userId =
        _getCurrentUserId(); // For logging and potentially remote context

    debug(
      data:
          "Repo: Updating substitutions locally first (Match ID: ${updateSubRequest.matchId})...",
    );

    // 1. Always update locally first
    // Assume localDataSource throws errors if it fails critically
    final FootballMatch updatedLocalMatch = await _localDataSource.updateSub(
      updateSubRequest,
    );
    debug(data: "Repo: Local substitution update completed.");

    // 2. Check if online and attempt remote update
    if (_isLoggedIn()) {
      debug(
        data:
            "Repo: User is online, attempting to update substitutions remotely for user $userId",
      );
      try {
        // Attempt remote update
        final FootballMatch updatedRemoteMatch = await _remoteDataSource
            .updateSub(
              updateSubRequest, // Pass the request containing new substitutions
            );
        debug(data: "Repo: Remote substitution update successful.");
        // Return the result from the remote source
        return updatedRemoteMatch;
      } catch (e) {
        debug(
          data:
              "Repo: Remote substitution update failed: $e. Substitutions updated locally.",
        );
        // Show user feedback about sync failure
        BotToast.showText(text: "Substitutions updated locally, sync failed.");
        // Return the locally updated match as fallback
        return updatedLocalMatch;
      }
    } else {
      // 3. If offline, return the locally updated match
      debug(data: "Repo: User is offline. Substitutions only updated locally.");
      return updatedLocalMatch;
    }
  }

  @override
  Future<FootballMatch> getDefaultMatch() async {
    if (_isLoggedIn()) {
      try {
        debug(data: "Repo: Getting single match from Remote");
        final remoteMatch = await _remoteDataSource.getDefaultMatch();
        // Sync remote data to local storage upon successful fetch
        try {
          await _localDataSource.createMatch(footballMatch: remoteMatch);
          debug(data: "Repo: Synced remote match to local storage.");
        } catch (syncError) {
          debug(data: "Repo: Failed to sync remote match to local: $syncError");
          // Decide if this is critical - maybe show a non-blocking warning
        }
        return remoteMatch;
      } catch (e) {
        debug(data: "Repo: Remote getMatch failed: $e. Falling back to local.");
        BotToast.showText(
          text: "Couldn't fetch latest data, showing offline version.",
        );
        // Fallback to local storage on error
        return await _localDataSource.getDefaultMatch();
      }
    } else {
      // Offline: Fetch directly from local
      debug(data: "Repo: Getting single match from Local (offline)");
      return await _localDataSource.getDefaultMatch();
    }
  }

  @override
  Future<MatchPeriod> createNewPeriod({
    required MatchPeriod matchPeriod,
  }) async {
    if (_isLoggedIn()) {
      try {
        debug(data: "Repo: Getting single Period from Remote");
        final remotePeriod = await _remoteDataSource.createNewPeriod(
          matchPeriod: matchPeriod,
        );

        return remotePeriod;
      } catch (e) {
        debug(data: "Repo: Remote period failed: $e. Falling back to local.");
        BotToast.showText(
          text: "Couldn't fetch latest data, showing offline version.",
        );
        // Fallback to local storage on error
        return await _localDataSource.createNewPeriod(matchPeriod: matchPeriod);
      }
    } else {
      // Offline: Fetch directly from local
      debug(data: "Repo: Getting single period from Local (offline)");
      return await _localDataSource.createNewPeriod(matchPeriod: matchPeriod);
    }
  }
}
