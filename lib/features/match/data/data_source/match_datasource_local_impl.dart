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
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_tactical_board/app/generator/random_generator.dart';

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
      id: null, // Firestore will generate ID if stored separately, null if embedded
      name: "Home Team",
      players: [], // Start with empty players list
    );
    final defaultAwayTeam = Team(id: null, name: "Away Team", players: []);
    final defaultScore = MatchScore(homeScore: 0, awayScore: 0);
    final defaultSubstitutions = MatchSubstitutions(substitutions: []);
    final defaultMatchTime = <MatchTime>[]; // Start with empty time list

    return FootballMatch(
      id: null, // ID will be assigned by Firestore on creation
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

  // --- updateMatchScore remains the same ---
  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    final matchId = updateMatchScoreRequest.matchId;
    final record = _store.record(matchId);
    final Map<String, dynamic> updateData = {
      'matchScore': updateMatchScoreRequest.newScore.toJson(),
      'updatedAt': DateTime.now().toIso8601String(), // Keep updatedAt fresh
    };

    // Merge the update data with existing data
    final updatedJson = await record.update(_db, updateData);

    if (updatedJson == null) {
      throw Exception("Sembast: Match $matchId not found for update.");
    }
    debug(data: "Sembast: Updated score for match $matchId for user userId");
    // Re-read the full record to return the complete object
    final snapshot = await record.getSnapshot(_db);
    if (snapshot == null)
      throw Exception(
        "Sembast: Failed to re-read match $matchId after update.",
      );
    return FootballMatch.fromJson(snapshot.value, snapshot.key);
  }

  // --- updateMatchTime remains the same ---
  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    final matchId = updateMatchTimeRequest.matchId;
    final record = _store.record(matchId);
    final List<Map<String, dynamic>> matchTimeJsonList =
        updateMatchTimeRequest.footballMatch.matchTime
            .map((mt) => mt.toJson())
            .toList();

    final Map<String, dynamic> updateData = {
      'matchTime': matchTimeJsonList,
      'status':
          updateMatchTimeRequest
              .matchTimeUpdateStatus
              .name, // Assuming status is also updated
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final updatedJson = await record.update(_db, updateData);

    if (updatedJson == null) {
      throw Exception("Sembast: Match $matchId not found for time update.");
    }
    debug(data: "Sembast: Updated time for match $matchId for user userId");
    final snapshot = await record.getSnapshot(_db);
    if (snapshot == null)
      throw Exception(
        "Sembast: Failed to re-read match $matchId after time update.",
      );
    return FootballMatch.fromJson(snapshot.value, snapshot.key);
  }

  @override
  Future<FootballMatch> createMatch({FootballMatch? footballMatch}) async {
    final localMatchId =
        RandomGenerator.generateId(); // Generate unique key for Sembast
    final defaultMatch = _buildDefaultMatch();
    final matchJson = defaultMatch.toJson();

    await _store.record(localMatchId).put(_db, matchJson);
    debug(data: "Sembast: Created match $localMatchId for user userId");
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
}
