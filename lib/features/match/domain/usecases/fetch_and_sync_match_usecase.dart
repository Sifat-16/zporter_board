// lib/features/match/domain/usecase/fetch_and_sync_local_matches_usecase_impl.dart

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart'; // For Alignment
import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
// Import Models & UseCase definition
import 'package:zporter_board/features/match/data/model/football_match.dart';

class FetchAndSyncLocalMatchesUseCaseImpl implements UseCase<void, dynamic> {
  final MatchDataSource _remoteMatchDataSource; // Firebase
  final MatchDataSource _localMatchDataSource; // Sembast
  final UserIdService _userIdService; // To get current user ID

  FetchAndSyncLocalMatchesUseCaseImpl({
    required MatchDataSource remoteMatchDataSource,
    required MatchDataSource localMatchDataSource,
    required UserIdService userIdService,
  }) : _remoteMatchDataSource = remoteMatchDataSource,
       _localMatchDataSource = localMatchDataSource,
       _userIdService = userIdService;

  @override
  Future<void> call(params) async {
    // Or Future<void> call()
    CancelFunc? cancelToast;
    final currentUserId = _userIdService.getCurrentUserId();
    final isOnline =
        _userIdService
            .isFirebaseLoggedIn(); // Check if we should even attempt remote ops

    if (!isOnline) {
      debug(data: "FetchSyncUseCase: User is offline. Skipping sync.");
      // Optionally show a message: BotToast.showText(text: "Offline: Cannot sync data now.");
      return; // Cannot sync if offline
    }

    debug(
      data:
          "FetchSyncUseCase: Checking local data for user $currentUserId to sync...",
    );

    try {
      // 1. Fetch local matches using the local DS internal logic
      final List<FootballMatch> localMatches =
          await _localMatchDataSource.getAllMatches();

      if (localMatches.isEmpty) {
        debug(data: "FetchSyncUseCase: No local matches found to sync.");
        // Optionally show message: BotToast.showText(text: "No local data to sync.");
        return; // Nothing to do
      }

      // 2. Show feedback and start upload
      cancelToast = BotToast.showLoading(
        allowClick: false,
        crossPage: true,
        backButtonBehavior: BackButtonBehavior.ignore,
      );
      BotToast.showText(
        text: "Syncing ${localMatches.length} local match(es)...",
        align: const Alignment(0, 0.85),
        duration: const Duration(seconds: 10),
        contentColor: Colors.black.withValues(alpha: 0.7),
        textStyle: const TextStyle(color: Colors.white),
      );

      debug(
        data:
            "FetchSyncUseCase: Found ${localMatches.length} matches. Uploading...",
      );

      List<String> successfullySyncedLocalKeys = [];
      bool errorsOccurred = false;

      // 3. Upload loop
      for (final localMatch in localMatches) {
        // Ensure the match is associated with the *current* user ID before uploading
        // This check is important if local data could somehow belong to a previous local ID
        if (localMatch.userId != currentUserId) {
          debug(
            data:
                "FetchSyncUseCase: Skipping local match ${localMatch.id} - userId mismatch (${localMatch.userId} != $currentUserId)",
          );
          continue; // Skip if it doesn't belong to the current user context
        }

        try {
          // Prepare data - let Firestore assign ID
          final matchToUpload = localMatch.copyWith(id: null);

          debug(
            data:
                "FetchSyncUseCase: Uploading match (local key ${localMatch.id}) for user $currentUserId",
          );
          await _remoteMatchDataSource.createMatch(
            footballMatch: matchToUpload,
          ); // Use currentUserId

          // Mark local key for deletion ONLY after successful upload
          successfullySyncedLocalKeys.add(localMatch.id!);
        } catch (e) {
          errorsOccurred = true;
          debug(
            data:
                "FetchSyncUseCase: Failed to upload match (local key ${localMatch.id}): $e",
          );
          // Decide: Stop? Continue?
          // Let's continue trying other matches.
        }
      }

      // 4. Delete successfully synced items locally
      if (successfullySyncedLocalKeys.isNotEmpty) {
        debug(
          data:
              "FetchSyncUseCase: Deleting ${successfullySyncedLocalKeys.length} synced matches locally...",
        );
        int deleteErrors = 0;
        for (final localKey in successfullySyncedLocalKeys) {
          try {
            // Use the local data source to delete by its key
            await _localMatchDataSource.deleteMatch(localKey);
          } catch (e) {
            deleteErrors++;
            debug(
              data:
                  "FetchSyncUseCase: Failed to delete local match (key $localKey): $e",
            );
          }
        }
        debug(
          data:
              "FetchSyncUseCase: Local deletion completed with $deleteErrors errors.",
        );
        if (deleteErrors > 0)
          BotToast.showText(
            text: "Warning: Could not clean up all synced local data.",
          );
      }

      // 5. Final feedback
      final successCount = successfullySyncedLocalKeys.length;
      final attemptCount =
          localMatches
              .where((m) => m.userId == currentUserId)
              .length; // Count only relevant matches
      if (errorsOccurred) {
        debug(
          data:
              "FetchSyncUseCase: Sync completed with errors. $successCount/$attemptCount matches synced.",
        );
        BotToast.showText(
          text:
              "Sync complete. $successCount/$attemptCount matches synced. Some errors occurred.",
        );
      } else if (attemptCount > 0) {
        debug(
          data:
              "FetchSyncUseCase: Sync successful. $successCount/$attemptCount matches synced.",
        );
        BotToast.showText(
          text: "Sync complete. $successCount/$attemptCount matches synced.",
        );
      } else {
        debug(
          data:
              "FetchSyncUseCase: Sync finished. No relevant matches needed syncing.",
        );
      }
    } catch (e) {
      debug(data: "FetchSyncUseCase: Unexpected error during process: $e");
      BotToast.showText(text: "Sync failed: $e");
      // Rethrow or handle as needed
      throw Exception("Fetch and Sync process failed: $e");
    } finally {
      if (cancelToast != null) {
        cancelToast(); // Hide loading toast
      }
      debug(data: "FetchSyncUseCase: Finished fetch and sync attempt.");
    }
  }
}
