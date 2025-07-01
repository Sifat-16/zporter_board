// import 'package:sembast/sembast.dart';
// import 'package:zporter_board/core/services/user_id_service.dart';
// import 'package:zporter_board/core/utils/log/debugger.dart';
// import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
// import 'package:zporter_board/features/match/data/model/football_match.dart';
// // Import models needed for default match creation
// import 'package:zporter_board/features/match/data/model/team.dart';
// // Import request objects
// import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
// import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
// import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
// import 'package:zporter_board/features/scoreboard/data/model/score.dart';
// import 'package:zporter_board/features/substitute/data/model/substitution.dart';
// import 'package:zporter_board/features/time/data/model/match_time.dart';
// import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
// import 'package:zporter_tactical_board/app/generator/random_generator.dart';
// import 'package:zporter_tactical_board/app/helper/logger.dart';
//
// class MatchDatasourceLocalImpl implements MatchDataSource {
//   final Database _db;
//   final StoreRef<String, Map<String, dynamic>> _store;
//   final UserIdService _userIdService;
//
//   // Define a store name (like a table name)
//   static const String storeName = 'matches_v2';
//   static const String _singleMatchKey = "current_user_match";
//
//   MatchDatasourceLocalImpl({
//     required Database database,
//     required UserIdService userIdService,
//   }) : _db = database,
//        _store = stringMapStoreFactory.store(storeName),
//        _userIdService = userIdService;
//
//   String _getCurrentUserId() {
//     final currentUser = _userIdService.getCurrentUserId();
//     return currentUser;
//   }
//
//   RecordRef<String, Map<String, dynamic>> _getMatchRecordRef() {
//     return _store.record(_singleMatchKey);
//   }
//
//   /// --- Helper Function to Create a Default Match ---
//   FootballMatch _buildDefaultMatch() {
//     // Define default values (customize as needed)
//     final defaultHomeTeam = Team(
//       id: RandomGenerator.generateId(), // Firestore will generate ID if stored separately, null if embedded
//       name: "Home Team",
//       players: [], // Start with empty players list
//     );
//     final defaultAwayTeam = Team(
//       id: RandomGenerator.generateId(),
//       name: "Away Team",
//       players: [],
//     );
//     final defaultScore = MatchScore(homeScore: 0, awayScore: 0);
//     final defaultSubstitutions = MatchSubstitutions(
//       homeSubs: List.generate(99, (index) {
//         return Substitution(
//           id: RandomGenerator.generateId(),
//           playerOutId: "11",
//           playerInId: "12",
//           minute: 10,
//         );
//       }),
//       awaySubs: List.generate(99, (index) {
//         return Substitution(
//           id: RandomGenerator.generateId(),
//           playerOutId: "11",
//           playerInId: "12",
//           minute: 10,
//         );
//       }),
//     );
//     final defaultMatchTime = <MatchPeriod>[
//       MatchPeriod(
//         periodNumber: 0,
//         timerMode: TimerMode.UP,
//         intervals: [],
//         extraTime: ExtraTime(
//           presetDuration: Duration(minutes: 3),
//           intervals: [],
//         ),
//       ),
//     ]; // Start with empty time list
//
//     return FootballMatch(
//       id: RandomGenerator.generateId(), // ID will be assigned by Firestore on creation
//       userId: _getCurrentUserId(), // Assign the current user's ID
//       name: "My First Match", // Default name
//       matchPeriod: defaultMatchTime,
//       homeTeam: defaultHomeTeam,
//       awayTeam: defaultAwayTeam,
//       matchScore: defaultScore,
//       substitutions: defaultSubstitutions,
//       venue: "Default Venue", // Default venue
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }
//
//   @override
//   Future<FootballMatch> updateMatchScore(
//     UpdateMatchScoreRequest updateMatchScoreRequest,
//   ) async {
//     final matchId = updateMatchScoreRequest.matchId;
//     final record = _store.record(matchId);
//
//     // 1. Get the current match data
//     final currentSnapshot = await record.getSnapshot(_db);
//     if (currentSnapshot == null) {
//       zlog(
//         data:
//             "Coming here to update the match - ${matchId} - ${updateMatchScoreRequest}",
//       );
//       throw Exception("Sembast: Match $matchId not found for score update.");
//     }
//     final currentMatch = FootballMatch.fromJson(
//       currentSnapshot.value,
//       currentSnapshot.key,
//     );
//
//     // 2. Create the updated match object
//     final updatedMatch = currentMatch.copyWith(
//       matchScore: updateMatchScoreRequest.newScore,
//       updatedAt: DateTime.now(), // Update the timestamp
//     );
//
//     // 3. Convert the *entire* updated match object to JSON
//     final updatedJson = updatedMatch.toJson();
//
//     // 4. Use 'put' to overwrite the entire record
//     // 'put' returns the key of the record that was written.
//     await record.put(_db, updatedJson);
//
//     debug(
//       data:
//           "Sembast: Overwrote match $matchId with updated score for user ${_getCurrentUserId()}",
//     );
//     return updatedMatch; // Return the object we used for putting
//   }
//
//   @override
//   Future<FootballMatch> updateMatchTime(
//     UpdateMatchTimeRequest updateMatchTimeRequest,
//   ) async {
//     // ALWAYS use the fixed key for the single match record in local storage
//     final recordRef =
//         _getMatchRecordRef(); // Get RecordRef using _singleMatchKey
//
//     // 1. Get the potentially updated match object from the request
//     // This object contains the updated list of periods and intervals, session start time, etc.
//     final FootballMatch matchFromRequest = updateMatchTimeRequest.footballMatch;
//
//     // --- Optional: Log a warning if the request ID doesn't match the fixed key ---
//     final String requestIdFromRequest = updateMatchTimeRequest.matchId;
//     if (requestIdFromRequest != _singleMatchKey &&
//         requestIdFromRequest.isNotEmpty) {
//       debug(
//         data:
//             "Sembast Warning: updateMatchTime called with ID $requestIdFromRequest but operating on fixed key $_singleMatchKey",
//       );
//     }
//
//     //-----------------------------------------------------------------------------
//
//     // 2. Create the final match object to be saved
//     final updatedMatch = matchFromRequest.copyWith(
//       // Ensure the object being saved uses the correct fixed ID for Sembast record key consistency
//       id: _singleMatchKey,
//       updatedAt: DateTime.now(), // Set a fresh timestamp for the update
//     );
//
//     // 3. Convert the *entire* updated match object (with correct ID) to JSON
//     final updatedJson = updatedMatch.toJson();
//
//     // 4. Use 'put' to overwrite the record associated with the fixed key (_singleMatchKey)
//     await recordRef.put(_db, updatedJson); // Use the correct record reference
//
//     debug(
//       data:
//           "Sembast: Overwrote match record $_singleMatchKey with updated time/status",
//     );
//     // Ensure you are using the correct field name ('matchPeriod') from your FootballMatch model
//     zlog(
//       data:
//           "Timer data updated match (overwritten) periods length : ${updatedMatch.matchPeriod.length}",
//     );
//
//     // 5. Return the updated match object we just saved
//     return updatedMatch;
//   }
//
//   @override
//   Future<FootballMatch> createMatch({FootballMatch? footballMatch}) async {
//     if (footballMatch?.id == null) {
//       footballMatch = footballMatch?.copyWith(id: RandomGenerator.generateId());
//     }
//     final defaultMatch = footballMatch ?? _buildDefaultMatch();
//     final matchJson = defaultMatch.toJson();
//
//     await _store.record(defaultMatch.id ?? "").put(_db, matchJson);
//     debug(data: "Sembast: Created match ${defaultMatch.id} for user userId");
//     // Return the match with the generated ID
//     return defaultMatch;
//   }
//
//   // --- NEW: deleteMatch Implementation ---
//   @override
//   Future<bool> deleteMatch(String matchId) async {
//     // In Sembast, deletion is simpler, just by key.
//     // We might add a finder check first if needed, but direct delete is common.
//     final count = await _store.record(matchId).delete(_db);
//     debug(
//       data: "Sembast: Deleted match $matchId for user userId. Count: $count",
//     );
//     return count != null; // Returns true if one record was deleted
//   }
//
//   @override
//   Future<int> clearMatchDb() async {
//     return await _store.delete(_db);
//   }
//
//   // --- In MatchDatasourceLocalImpl class ---
//
//   @override
//   Future<FootballMatch> updateSub(UpdateSubRequest updateSubRequest) async {
//     final matchId = updateSubRequest.matchId;
//     final newSubstitutions = updateSubRequest.matchSubstitutions;
//
//     if (matchId.isEmpty) {
//       throw ArgumentError(
//         "Match ID cannot be empty for updating substitutions.",
//       );
//     }
//
//     // Get the reference to the specific record using its key (matchId)
//     final record = _store.record(matchId);
//
//     try {
//       // --- Read-Modify-Write Pattern ---
//       // 1. Read the current record snapshot
//       final currentSnapshot = await record.getSnapshot(_db);
//       if (currentSnapshot == null) {
//         throw Exception(
//           "Sembast: Match $matchId not found for substitution update.",
//         );
//       }
//
//       // 2. Parse the current data into a model object
//       final currentMatch = FootballMatch.fromJson(
//         currentSnapshot.value, // The data Map
//         currentSnapshot.key, // The record key (matchId)
//       );
//
//       // 3. Create the updated match object using copyWith
//       final updatedMatch = currentMatch.copyWith(
//         substitutions:
//             newSubstitutions, // Replace with the new substitutions object
//         updatedAt:
//             DateTime.now(), // Update the timestamp with current local time
//       );
//
//       // 4. Convert the *entire* updated match object back to JSON Map
//       final updatedJson = updatedMatch.toJson();
//
//       // 5. Use 'put' to overwrite the record with the updated data
//       // 'put' returns the key if successful.
//       await record.put(
//         _db,
//         updatedJson,
//         merge: false,
//       ); // merge:false ensures overwrite
//
//       debug(data: "Sembast: Updated substitutions for match $matchId");
//
//       // 6. Return the updated match object we constructed
//       // (Sembast put doesn't return the updated value directly)
//       return updatedMatch;
//       // --- End Read-Modify-Write ---
//     } catch (e) {
//       debug(data: "Sembast Exception during updateSub: $e");
//       // Handle specific Sembast errors if necessary
//       throw Exception(
//         "An unexpected error occurred while updating match substitutions locally: $e",
//       );
//     }
//   }
//
//   @override
//   Future<FootballMatch> getDefaultMatch() async {
//     final recordRef = _getMatchRecordRef();
//     final snapshot = await recordRef.getSnapshot(_db);
//
//     if (snapshot != null) {
//       debug(
//         data:
//             "Sembast: Found existing match with key ${_singleMatchKey} - ${snapshot.value}",
//       );
//       return FootballMatch.fromJson(snapshot.value, snapshot.key);
//     } else {
//       debug(data: "Sembast: No match found. Creating default.");
//       final defaultMatch = _buildDefaultMatch();
//       await recordRef.put(_db, defaultMatch.toJson());
//       // Fetch again to be consistent (though Sembast is synchronous after put)
//       final newSnapshot = await recordRef.getSnapshot(_db);
//       return FootballMatch.fromJson(newSnapshot!.value, newSnapshot.key);
//       // return defaultMatch;
//     }
//   }
//
//   @override
//   Future<MatchPeriod> createNewPeriod({
//     required MatchPeriod matchPeriod,
//   }) async {
//     // This function now ASSUMES newPeriod is fully configured (correct number, mode, etc.)
//     // and that the match record exists. Checks are done before calling this.
//     final recordRef = _getMatchRecordRef();
//
//     try {
//       // Use transaction for safe read-modify-write
//       await _db.transaction((txn) async {
//         final snapshot = await recordRef.getSnapshot(txn);
//         if (snapshot == null) {
//           // If called when match doesn't exist, this is an error based on preconditions
//           throw Exception(
//             "Sembast: Cannot add period, match record not found with key $_singleMatchKey.",
//           );
//         }
//
//         final currentMatch = FootballMatch.fromJson(
//           snapshot.value,
//           snapshot.key,
//         );
//
//         // --- Add the PREPARED new period to the list ---
//         List<MatchPeriod> updatedPeriods = List.from(
//           currentMatch.matchPeriod,
//         ); // Use correct field name
//         updatedPeriods.add(matchPeriod); // Add the provided period object
//         //-----------------------------------------------
//
//         // --- Prepare updated match object ---
//         final matchWithNewPeriod = currentMatch.copyWith(
//           matchPeriod: updatedPeriods, // Use correct field name
//           updatedAt: DateTime.now(), // Update timestamp
//           // Optionally update status if needed
//         );
//         //---------------------------------
//
//         // --- Save back to Sembast ---
//         await recordRef.put(txn, matchWithNewPeriod.toJson());
//         debug(
//           data:
//               "Sembast: Added provided period (${matchPeriod.periodNumber}) for match key $_singleMatchKey",
//         );
//         //---------------------------
//       }); // End transaction
//
//       // If transaction succeeds, return the period object that was passed in and added
//       return matchPeriod;
//     } catch (e) {
//       // Catch potential transaction errors or the exception thrown if match not found
//       debug(data: "Sembast: Error during createNewPeriod transaction: $e");
//       // Re-throw the error to be handled by the repository/usecase layer
//       throw Exception("Failed to add period locally: $e");
//     }
//   }
//
//   @override
//   Future<MatchPeriod> updatePeriod(MatchPeriod matchPeriodToUpdate) async {
//     final recordRef = _getMatchRecordRef();
//
//     // Use transaction for safe read-modify-write
//     try {
//       await _db.transaction((txn) async {
//         final snapshot = await recordRef.getSnapshot(txn);
//         if (snapshot == null) {
//           throw Exception(
//             "Sembast: Cannot update period, match record not found with key $_singleMatchKey.",
//           );
//         }
//
//         final currentMatch = FootballMatch.fromJson(
//           snapshot.value,
//           snapshot.key,
//         );
//
//         // Find the index of the period to update based on periodNumber
//         final int periodIndex = currentMatch.matchPeriod.indexWhere(
//           (p) => p.periodNumber == matchPeriodToUpdate.periodNumber,
//         );
//
//         if (periodIndex == -1) {
//           // Period with the given number not found in the current match
//           throw Exception(
//             "Sembast: Cannot update period, period number ${matchPeriodToUpdate.periodNumber} not found in match.",
//           );
//         }
//
//         // Create the updated list of periods by replacing the element at the index
//         List<MatchPeriod> updatedPeriods = List.from(currentMatch.matchPeriod);
//         // Replace the old period object with the new one provided
//         updatedPeriods[periodIndex] = matchPeriodToUpdate;
//
//         // Prepare the updated FootballMatch object
//         final updatedMatch = currentMatch.copyWith(
//           matchPeriod: updatedPeriods, // Use the list with the replaced period
//           updatedAt: DateTime.now(), // Update timestamp
//           // Optionally update match status if needed
//         );
//
//         // Save the entire updated match back to Sembast
//         await recordRef.put(txn, updatedMatch.toJson());
//         debug(
//           data:
//               "Sembast: Updated period (${matchPeriodToUpdate.periodNumber}) for match key $_singleMatchKey",
//         );
//       }); // End transaction
//
//       // If transaction succeeds, return the updated period object that was passed in
//       return matchPeriodToUpdate;
//     } catch (e) {
//       debug(data: "Sembast: Error during updatePeriod transaction: $e");
//       // Re-throw the error to be handled by the repository/usecase layer
//       throw Exception("Failed to update period locally: $e");
//     }
//   }
// }

import 'package:sembast/sembast.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_tactical_board/app/generator/random_generator.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class MatchDatasourceLocalImpl implements MatchDataSource {
  final Database _db;
  final StoreRef<String, Map<String, dynamic>> _store;
  final AuthBloc _authBloc; // MODIFIED: Replaced UserIdService

  // Define a store name (like a table name)
  static const String storeName = 'matches_v2';
  static const String _singleMatchKey = "current_user_match";

  MatchDatasourceLocalImpl({
    required Database database,
    required AuthBloc authBloc, // MODIFIED: Replaced UserIdService
  })  : _db = database,
        _store = stringMapStoreFactory.store(storeName),
        _authBloc = authBloc;

  String _getCurrentUserId() {
    // MODIFIED: Gets the user ID from the central AuthBloc state.
    final user = _authBloc.state.user;
    if (user.uid.isEmpty) {
      // This case should ideally not happen if AuthBloc is initialized correctly
      throw Exception(
          'User not authenticated or UID is empty in local data source');
    }
    return user.uid;
  }

  RecordRef<String, Map<String, dynamic>> _getMatchRecordRef() {
    return _store.record(_singleMatchKey);
  }

  /// --- Helper Function to Create a Default Match ---
  FootballMatch _buildDefaultMatch() {
    // Define default values (customize as needed)
    final defaultHomeTeam = Team(
      id: RandomGenerator.generateId(),
      name: "Home Team",
      players: [],
    );
    final defaultAwayTeam = Team(
      id: RandomGenerator.generateId(),
      name: "Away Team",
      players: [],
    );
    final defaultScore = MatchScore(homeScore: 0, awayScore: 0);
    final defaultSubstitutions = MatchSubstitutions(
      homeSubs: List.generate(99, (index) {
        return Substitution(
          id: RandomGenerator.generateId(),
          playerOutId: "11",
          playerInId: "12",
          minute: 10,
        );
      }),
      awaySubs: List.generate(99, (index) {
        return Substitution(
          id: RandomGenerator.generateId(),
          playerOutId: "11",
          playerInId: "12",
          minute: 10,
        );
      }),
    );
    final defaultMatchTime = <MatchPeriod>[
      MatchPeriod(
        periodNumber: 0,
        timerMode: TimerMode.UP,
        intervals: [],
        extraTime: ExtraTime(
          presetDuration: Duration(minutes: 3),
          intervals: [],
        ),
      ),
    ];

    return FootballMatch(
      id: RandomGenerator.generateId(),
      userId: _getCurrentUserId(),
      name: "My First Match",
      matchPeriod: defaultMatchTime,
      homeTeam: defaultHomeTeam,
      awayTeam: defaultAwayTeam,
      matchScore: defaultScore,
      substitutions: defaultSubstitutions,
      venue: "Default Venue",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    final matchId = updateMatchScoreRequest.matchId;
    final record = _store.record(matchId);

    final currentSnapshot = await record.getSnapshot(_db);
    if (currentSnapshot == null) {
      zlog(
        data:
            "Coming here to update the match - ${matchId} - ${updateMatchScoreRequest}",
      );
      throw Exception("Sembast: Match $matchId not found for score update.");
    }
    final currentMatch = FootballMatch.fromJson(
      currentSnapshot.value,
      currentSnapshot.key,
    );

    final updatedMatch = currentMatch.copyWith(
      matchScore: updateMatchScoreRequest.newScore,
      updatedAt: DateTime.now(),
    );

    final updatedJson = updatedMatch.toJson();

    await record.put(_db, updatedJson);

    debug(
      data:
          "Sembast: Overwrote match $matchId with updated score for user ${_getCurrentUserId()}",
    );
    return updatedMatch;
  }

  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    final recordRef = _getMatchRecordRef();

    final FootballMatch matchFromRequest = updateMatchTimeRequest.footballMatch;

    final String requestIdFromRequest = updateMatchTimeRequest.matchId;
    if (requestIdFromRequest != _singleMatchKey &&
        requestIdFromRequest.isNotEmpty) {
      debug(
        data:
            "Sembast Warning: updateMatchTime called with ID $requestIdFromRequest but operating on fixed key $_singleMatchKey",
      );
    }

    final updatedMatch = matchFromRequest.copyWith(
      id: _singleMatchKey,
      updatedAt: DateTime.now(),
    );

    final updatedJson = updatedMatch.toJson();

    await recordRef.put(_db, updatedJson);

    debug(
      data:
          "Sembast: Overwrote match record $_singleMatchKey with updated time/status",
    );
    zlog(
      data:
          "Timer data updated match (overwritten) periods length : ${updatedMatch.matchPeriod.length}",
    );

    return updatedMatch;
  }

  @override
  Future<FootballMatch> createMatch({FootballMatch? footballMatch}) async {
    if (footballMatch?.id == null) {
      footballMatch = footballMatch?.copyWith(id: RandomGenerator.generateId());
    }
    final defaultMatch = footballMatch ?? _buildDefaultMatch();
    final matchJson = defaultMatch.toJson();

    await _store.record(defaultMatch.id ?? "").put(_db, matchJson);
    debug(data: "Sembast: Created match ${defaultMatch.id} for user userId");
    return defaultMatch;
  }

  @override
  Future<bool> deleteMatch(String matchId) async {
    final count = await _store.record(matchId).delete(_db);
    debug(
      data: "Sembast: Deleted match $matchId for user userId. Count: $count",
    );
    return count != null;
  }

  @override
  Future<int> clearMatchDb() async {
    return await _store.delete(_db);
  }

  @override
  Future<FootballMatch> updateSub(UpdateSubRequest updateSubRequest) async {
    final matchId = updateSubRequest.matchId;
    final newSubstitutions = updateSubRequest.matchSubstitutions;

    if (matchId.isEmpty) {
      throw ArgumentError(
        "Match ID cannot be empty for updating substitutions.",
      );
    }

    final record = _store.record(matchId);

    try {
      final currentSnapshot = await record.getSnapshot(_db);
      if (currentSnapshot == null) {
        throw Exception(
          "Sembast: Match $matchId not found for substitution update.",
        );
      }

      final currentMatch = FootballMatch.fromJson(
        currentSnapshot.value,
        currentSnapshot.key,
      );

      final updatedMatch = currentMatch.copyWith(
        substitutions: newSubstitutions,
        updatedAt: DateTime.now(),
      );

      final updatedJson = updatedMatch.toJson();

      await record.put(
        _db,
        updatedJson,
        merge: false,
      );

      debug(data: "Sembast: Updated substitutions for match $matchId");

      return updatedMatch;
    } catch (e) {
      debug(data: "Sembast Exception during updateSub: $e");
      throw Exception(
        "An unexpected error occurred while updating match substitutions locally: $e",
      );
    }
  }

  @override
  Future<FootballMatch> getDefaultMatch() async {
    final recordRef = _getMatchRecordRef();
    final snapshot = await recordRef.getSnapshot(_db);

    if (snapshot != null) {
      debug(
        data:
            "Sembast: Found existing match with key ${_singleMatchKey} - ${snapshot.value}",
      );
      return FootballMatch.fromJson(snapshot.value, snapshot.key);
    } else {
      debug(data: "Sembast: No match found. Creating default.");
      final defaultMatch = _buildDefaultMatch();
      await recordRef.put(_db, defaultMatch.toJson());
      final newSnapshot = await recordRef.getSnapshot(_db);
      return FootballMatch.fromJson(newSnapshot!.value, newSnapshot.key);
    }
  }

  @override
  Future<MatchPeriod> createNewPeriod({
    required MatchPeriod matchPeriod,
  }) async {
    final recordRef = _getMatchRecordRef();

    try {
      await _db.transaction((txn) async {
        final snapshot = await recordRef.getSnapshot(txn);
        if (snapshot == null) {
          throw Exception(
            "Sembast: Cannot add period, match record not found with key $_singleMatchKey.",
          );
        }

        final currentMatch = FootballMatch.fromJson(
          snapshot.value,
          snapshot.key,
        );

        List<MatchPeriod> updatedPeriods = List.from(
          currentMatch.matchPeriod,
        );
        updatedPeriods.add(matchPeriod);

        final matchWithNewPeriod = currentMatch.copyWith(
          matchPeriod: updatedPeriods,
          updatedAt: DateTime.now(),
        );

        await recordRef.put(txn, matchWithNewPeriod.toJson());
        debug(
          data:
              "Sembast: Added provided period (${matchPeriod.periodNumber}) for match key $_singleMatchKey",
        );
      });

      return matchPeriod;
    } catch (e) {
      debug(data: "Sembast: Error during createNewPeriod transaction: $e");
      throw Exception("Failed to add period locally: $e");
    }
  }

  @override
  Future<MatchPeriod> updatePeriod(MatchPeriod matchPeriodToUpdate) async {
    final recordRef = _getMatchRecordRef();

    try {
      await _db.transaction((txn) async {
        final snapshot = await recordRef.getSnapshot(txn);
        if (snapshot == null) {
          throw Exception(
            "Sembast: Cannot update period, match record not found with key $_singleMatchKey.",
          );
        }

        final currentMatch = FootballMatch.fromJson(
          snapshot.value,
          snapshot.key,
        );

        final int periodIndex = currentMatch.matchPeriod.indexWhere(
          (p) => p.periodNumber == matchPeriodToUpdate.periodNumber,
        );

        if (periodIndex == -1) {
          throw Exception(
            "Sembast: Cannot update period, period number ${matchPeriodToUpdate.periodNumber} not found in match.",
          );
        }

        List<MatchPeriod> updatedPeriods = List.from(currentMatch.matchPeriod);
        updatedPeriods[periodIndex] = matchPeriodToUpdate;

        final updatedMatch = currentMatch.copyWith(
          matchPeriod: updatedPeriods,
          updatedAt: DateTime.now(),
        );

        await recordRef.put(txn, updatedMatch.toJson());
        debug(
          data:
              "Sembast: Updated period (${matchPeriodToUpdate.periodNumber}) for match key $_singleMatchKey",
        );
      });

      return matchPeriodToUpdate;
    } catch (e) {
      debug(data: "Sembast: Error during updatePeriod transaction: $e");
      throw Exception("Failed to update period locally: $e");
    }
  }
}
