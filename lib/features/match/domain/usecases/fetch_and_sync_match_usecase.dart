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
    implements UseCase<FootballMatch?, BuildContext> {
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
  Future<FootballMatch?> call(BuildContext context) async {
    final currentUserId = _userIdService.getCurrentUserId();

    debug(
      data: "FetchSyncUseCase: Checking local data for user $currentUserId...",
    );

    try {
      final FootballMatch localMatches =
          await _localMatchDataSource.getDefaultMatch();
      // --- Show Dialog ---
      debug(
        data:
            "FetchSyncUseCase: Found localMatches.length} local matches. Asking user.. ${_localMatchDataSource.runtimeType}.",
      );

      bool? doMerge = await showConfirmationDialog(
        context: context,
        barrierDismissible: false,
        title: "Local Data Detected!",
        content:
            "You have match data saved locally. Do you want to merge them with your online account or delete the local copies?",
        confirmButtonText: "MERGE ONLINE",
        cancelButtonText: "DELETE LOCAL",
      );

      _clearMatchDbUseCase.call(null);

      if (doMerge == true) {
        return localMatches;
      } else {
        return null;
      }
    } catch (e) {
    } finally {}
    return null;
  }

  Future<bool> syncRemote(FootballMatch matches) async {
    BotToast.showText(text: "Syncing data");
    await _remoteMatchDataSource.createMatch(footballMatch: matches);
    BotToast.showText(text: "Sync completed!!");

    return true;
  }
}
