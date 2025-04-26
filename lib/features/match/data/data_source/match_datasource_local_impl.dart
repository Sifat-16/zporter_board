import 'package:sembast/sembast.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
// Import models needed for default match creation
import 'package:zporter_board/features/match/data/model/team.dart';
// Import request objects
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_tactical_board/app/generator/random_generator.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class MatchDatasourceLocalImpl implements MatchDataSource {
  final Database _db;
  final StoreRef<String, Map<String, dynamic>> _store;
  final UserIdService _userIdService;

  // Define a store name (like a table name)
  static const String storeName = 'matches';

  MatchDatasourceLocalImpl({
    required Database database,
    required UserIdService userIdService,
  }) : _db = database,
       _store = stringMapStoreFactory.store(storeName),
       _userIdService = userIdService;

  String _getCurrentUserId() {
    final currentUser = _userIdService.getCurrentUserId();
    return currentUser;
  }

  /// --- Helper Function to Create a Default Match ---
  FootballMatch _buildDefaultMatch() {
    // Define default values (customize as needed)
    final defaultHomeTeam = Team(
      id: RandomGenerator.generateId(), // Firestore will generate ID if stored separately, null if embedded
      name: "Home Team",
      players: [], // Start with empty players list
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
          playerOutId: "43",
          playerInId: "43",
          minute: 10,
        );
      }),
      awaySubs: List.generate(99, (index) {
        return Substitution(
          id: RandomGenerator.generateId(),
          playerOutId: "43",
          playerInId: "43",
          minute: 10,
        );
      }),
    );
    final defaultMatchTime = <MatchTime>[]; // Start with empty time list

    return FootballMatch(
      id: RandomGenerator.generateId(), // ID will be assigned by Firestore on creation
      userId: _getCurrentUserId(), // Assign the current user's ID
      name: "My First Match", // Default name
      matchTime: defaultMatchTime,
      status: "SCHEDULED", // Default status
      homeTeam: defaultHomeTeam,
      awayTeam: defaultAwayTeam,
      matchScore: defaultScore,
      substitutions: defaultSubstitutions,
      venue: "Default Venue", // Default venue
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<FootballMatch>> getAllMatches() async {
    zlog(data: "Coming to get all matches");
    final finder = Finder(filter: Filter.equals('userId', _getCurrentUserId()));
    final snapshots = await _store.find(_db, finder: finder);

    List<FootballMatch> matches =
        snapshots.map((snapshot) {
          // IMPORTANT: Use the Sembast key as the match ID
          return FootballMatch.fromJson(snapshot.value, snapshot.key);
        }).toList();

    // Handle default match creation if no matches found locally
    if (matches.isEmpty) {
      debug(
        data: "Sembast: No matches found for user userId. Creating default.",
      );
      final defaultMatch = await createMatch();
      matches = [defaultMatch]; // Return list with the new default match
    } else {
      debug(data: "Sembast: Found ${matches.length} matches for user userId");
    }

    // Sort locally (same logic as Firestore version)
    matches.sort(
      (a, b) =>
          (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)),
    );
    return matches;
  }

  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    final matchId = updateMatchScoreRequest.matchId;
    final record = _store.record(matchId);

    // 1. Get the current match data
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

    // 2. Create the updated match object
    final updatedMatch = currentMatch.copyWith(
      matchScore: updateMatchScoreRequest.newScore,
      updatedAt: DateTime.now(), // Update the timestamp
    );

    // 3. Convert the *entire* updated match object to JSON
    final updatedJson = updatedMatch.toJson();

    // 4. Use 'put' to overwrite the entire record
    // 'put' returns the key of the record that was written.
    await record.put(_db, updatedJson);

    debug(
      data:
          "Sembast: Overwrote match $matchId with updated score for user ${_getCurrentUserId()}",
    );

    // 5. Return the updated match object
    // Since 'put' doesn't return the value, we return the object we just constructed.
    // Ensure the ID is correctly set from the key
    return updatedMatch; // Return the object we used for putting
  }

  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    final matchId = updateMatchTimeRequest.matchId;
    final record = _store.record(matchId);

    // 1. Get the potentially updated match object from the request
    // Assuming updateMatchTimeRequest.footballMatch ALREADY contains the desired matchTime
    final FootballMatch matchFromRequest = updateMatchTimeRequest.footballMatch;

    // 2. Create the final match object to be saved, ensuring updatedAt and status are current
    final updatedMatch = matchFromRequest.copyWith(
      status:
          updateMatchTimeRequest
              .matchTimeUpdateStatus
              .name, // Update status from request
      updatedAt: DateTime.now(), // Set a fresh timestamp
      // Ensure the ID from the request is used (or overwrite if needed)
      id: matchId,
    );

    // 3. Convert the *entire* updated match object to JSON
    final updatedJson = updatedMatch.toJson();

    // 4. Use 'put' to overwrite the entire record
    await record.put(_db, updatedJson);

    debug(
      data:
          "Sembast: Overwrote match $matchId with updated time/status for user ${_getCurrentUserId()}",
    );
    zlog(
      data:
          "Timer data updated match (overwritten) time length : ${updatedMatch.matchTime.length}",
    );

    // 5. Return the updated match object
    // Return the object we used for putting, ensuring ID is correct
    return updatedMatch; // The object already has the correct ID and data
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
    // Return the match with the generated ID
    return defaultMatch;
  }

  // --- NEW: deleteMatch Implementation ---
  @override
  Future<bool> deleteMatch(String matchId) async {
    // In Sembast, deletion is simpler, just by key.
    // We might add a finder check first if needed, but direct delete is common.
    final count = await _store.record(matchId).delete(_db);
    debug(
      data: "Sembast: Deleted match $matchId for user userId. Count: $count",
    );
    return count != null; // Returns true if one record was deleted
  }

  @override
  Future<int> clearMatchDb() async {
    return await _store.delete(_db);
  }

  // --- In MatchDatasourceLocalImpl class ---

  @override
  Future<FootballMatch> updateSub(UpdateSubRequest updateSubRequest) async {
    final matchId = updateSubRequest.matchId;
    final newSubstitutions = updateSubRequest.matchSubstitutions;

    if (matchId.isEmpty) {
      throw ArgumentError(
        "Match ID cannot be empty for updating substitutions.",
      );
    }

    // Get the reference to the specific record using its key (matchId)
    final record = _store.record(matchId);

    try {
      // --- Read-Modify-Write Pattern ---
      // 1. Read the current record snapshot
      final currentSnapshot = await record.getSnapshot(_db);
      if (currentSnapshot == null) {
        throw Exception(
          "Sembast: Match $matchId not found for substitution update.",
        );
      }

      // 2. Parse the current data into a model object
      final currentMatch = FootballMatch.fromJson(
        currentSnapshot.value, // The data Map
        currentSnapshot.key, // The record key (matchId)
      );

      // 3. Create the updated match object using copyWith
      final updatedMatch = currentMatch.copyWith(
        substitutions:
            newSubstitutions, // Replace with the new substitutions object
        updatedAt:
            DateTime.now(), // Update the timestamp with current local time
      );

      // 4. Convert the *entire* updated match object back to JSON Map
      final updatedJson = updatedMatch.toJson();

      // 5. Use 'put' to overwrite the record with the updated data
      // 'put' returns the key if successful.
      await record.put(
        _db,
        updatedJson,
        merge: false,
      ); // merge:false ensures overwrite

      debug(data: "Sembast: Updated substitutions for match $matchId");

      // 6. Return the updated match object we constructed
      // (Sembast put doesn't return the updated value directly)
      return updatedMatch;
      // --- End Read-Modify-Write ---
    } catch (e) {
      debug(data: "Sembast Exception during updateSub: $e");
      // Handle specific Sembast errors if necessary
      throw Exception(
        "An unexpected error occurred while updating match substitutions locally: $e",
      );
    }
  }
}
