import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart'; // Required for BuildContext, Dialogs, etc.
import 'package:zporter_board/core/common/components/dialog/confirmation_dialog.dart';
import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/usecases/clear_match_db_usecase.dart';

class FetchAndSyncLocalMatchesUseCase
    implements UseCase<List<FootballMatch>, BuildContext> {
  final MatchDataSource _remoteMatchDataSource; // Firebase
  final MatchDataSource _localMatchDataSource; // Sembast
  final UserIdService _userIdService; // To get current user ID
  final ClearMatchDbUseCase _clearMatchDbUseCase;

  FetchAndSyncLocalMatchesUseCase({
    required MatchDataSource remoteMatchDataSource,
    required MatchDataSource localMatchDataSource,
    required UserIdService userIdService,
    required ClearMatchDbUseCase clearMatchDbUseCase,
  }) : _remoteMatchDataSource = remoteMatchDataSource,
       _localMatchDataSource = localMatchDataSource,
       _userIdService = userIdService,
       _clearMatchDbUseCase = clearMatchDbUseCase;

  @override
  Future<List<FootballMatch>> call(BuildContext context) async {
    final currentUserId = _userIdService.getCurrentUserId();

    debug(
      data: "FetchSyncUseCase: Checking local data for user $currentUserId...",
    );

    try {
      final List<FootballMatch> localMatches =
          await _localMatchDataSource.getAllMatches();
      // --- Show Dialog ---
      debug(
        data:
            "FetchSyncUseCase: Found ${localMatches.length} local matches. Asking user.. ${_localMatchDataSource.runtimeType}.",
      );

      bool? doMerge = await showConfirmationDialog(
        context: context,
        barrierDismissible: false,
        title: "Local Data Detected!",
        content:
            "You have ${localMatches.length} match(es) saved locally. Do you want to merge them with your online account or delete the local copies?",
        confirmButtonText: "MERGE ONLINE",
        cancelButtonText: "DELETE LOCAL",
      );

      _clearMatchDbUseCase.call(null);

      if (doMerge == true) {
        return localMatches;
      } else {
        return [];
      }
    } catch (e) {
    } finally {}
    return [];
  }

  Future<bool> syncRemote(List<FootballMatch> matches) async {
    BotToast.showText(text: "Syncing data");
    for (var match in matches) {
      await _remoteMatchDataSource.createMatch(footballMatch: match);
    }
    BotToast.showText(text: "Sync completed!!");

    return true;
  }
}
