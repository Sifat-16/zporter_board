import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zporter_board/core/constant/firestore_constant.dart'; // Ensure this path is correct
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

class MatchDataSourceImpl implements MatchDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  MatchDataSourceImpl({required this.firestore, required this.firebaseAuth});

  String _getCurrentUserId() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception("User not authenticated.");
    }
    return currentUser.uid;
  }

  /// --- Helper Function to Create a Default Match ---
  FootballMatch _buildDefaultMatch(String userId) {
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
      userId: userId, // Assign the current user's ID
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
    final userId = _getCurrentUserId(); // Get current user ID early
    final CollectionReference matchCollection = firestore.collection(
      FirestoreConstants.matches,
    ); // Get collection reference

    try {
      debug(data: "Fetching matches for user: $userId");

      // Query for documents where 'userId' field matches the current user's ID
      final QuerySnapshot querySnapshot =
          await matchCollection.where('userId', isEqualTo: userId).get();

      // --- Check if matches were found ---
      if (querySnapshot.docs.isEmpty) {
        debug(
          data: "No matches found for user $userId. Creating default match.",
        );

        // 1. Build the default match object (without ID)
        final FootballMatch defaultMatch = _buildDefaultMatch(userId);

        // 2. Add the default match to Firestore
        final DocumentReference newDocRef = await matchCollection.add(
          defaultMatch.toJson(), // Convert model to Map for Firestore
        );
        debug(data: "Default match created with ID: ${newDocRef.id}");

        // 3. Create the final match object *with* the Firestore-generated ID
        //    (Using copyWith if available, otherwise reconstruct)
        final FootballMatch createdMatchWithId = defaultMatch.copyWith(
          id: newDocRef.id,
        ); // Assumes FootballMatch has copyWith

        // 4. Return a list containing only the newly created match
        return [createdMatchWithId];
      } else {
        // --- Matches found, process them as before ---
        List<FootballMatch> footballMatches = [];
        for (var doc in querySnapshot.docs) {
          try {
            footballMatches.add(
              FootballMatch.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ),
            );
          } catch (e) {
            debug(data: "Error parsing match document ${doc.id}: $e");
            // Optionally skip corrupted documents
          }
        }

        debug(data: "Found ${footballMatches.length} matches for user $userId");

        // --- ADD CLIENT-SIDE SORTING ---
        footballMatches.sort((matchA, matchB) {
          final dateA = matchA.createdAt;
          final dateB = matchB.createdAt;

          // Handle cases where createdAt might be null
          // Treat nulls as the oldest (coming first in ascending sort)
          if (dateA == null && dateB == null) return 0; // Equal if both null
          if (dateA == null)
            return -1; // Null dateA comes before non-null dateB
          if (dateB == null) return 1; // Non-null dateA comes after null dateB

          // Compare non-null dates
          return dateA.compareTo(dateB); // Ascending order (older first)
        });
        // --- END CLIENT-SIDE SORTING ---

        return footballMatches;
      }
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during getAllMatches: ${e.message} code: ${e.code}",
      );
      // Check if the error occurred during the 'add' operation
      if (e.code == 'permission-denied') {
        throw Exception(
          "Permission denied when trying to access or create matches.",
        );
      }
      throw Exception("Error fetching or creating matches: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during getAllMatches: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }

  // --- updateMatchScore remains the same ---
  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    // ... (implementation remains unchanged)
    try {
      final userId = _getCurrentUserId();
      final String matchId = updateMatchScoreRequest.matchId;
      if (matchId.isEmpty) throw ArgumentError("Match ID cannot be empty.");
      debug(data: "Updating score for match: $matchId for user: $userId");
      final DocumentReference matchDocRef = firestore
          .collection(FirestoreConstants.matches)
          .doc(matchId);
      final Map<String, dynamic> updateData = {
        'matchScore': updateMatchScoreRequest.newScore.toJson(),
      };
      await matchDocRef.update(updateData);
      final DocumentSnapshot updatedDoc = await matchDocRef.get();
      if (!updatedDoc.exists)
        throw Exception("Match document $matchId not found after update.");
      debug(data: "Match score updated successfully for $matchId");
      return FootballMatch.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
        updatedDoc.id,
      );
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during updateMatchScore: ${e.message} code: ${e.code}",
      );
      throw Exception("Error updating match score: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during updateMatchScore: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }

  // --- updateMatchTime remains the same ---
  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    // ... (implementation remains unchanged)
    try {
      final userId = _getCurrentUserId();
      final String matchId = updateMatchTimeRequest.matchId;
      if (matchId.isEmpty) throw ArgumentError("Match ID cannot be empty.");
      debug(
        data:
            "Updating time for match: $matchId for user: $userId with status: ${updateMatchTimeRequest.matchTimeUpdateStatus}",
      );
      final DocumentReference matchDocRef = firestore
          .collection(FirestoreConstants.matches)
          .doc(matchId);
      final List<MatchTime> newMatchTimeList =
          updateMatchTimeRequest.footballMatch.matchTime;
      List<Map<String, dynamic>> matchTimeJsonList =
          newMatchTimeList.map((matchTime) => matchTime.toJson()).toList();
      final Map<String, dynamic> updateData = {'matchTime': matchTimeJsonList};
      await matchDocRef.update(updateData);
      final DocumentSnapshot updatedDoc = await matchDocRef.get();
      if (!updatedDoc.exists)
        throw Exception(
          "Match document $matchId not found after update attempt.",
        );
      debug(data: "Match time updated successfully for $matchId");
      return FootballMatch.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
        updatedDoc.id,
      );
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during updateMatchTime: ${e.message} code: ${e.code}",
      );
      throw Exception("Error updating match time: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during updateMatchTime: $e");
      throw Exception(
        "An unexpected error occurred while updating match time: $e",
      );
    }
  }

  @override
  Future<FootballMatch> createMatch() async {
    final userId = _getCurrentUserId(); // Get current user ID
    final CollectionReference matchCollection = firestore.collection(
      FirestoreConstants.matches,
    );

    try {
      // Ensure the match data is associated with the correct user ID
      // and does not contain an ID before creation.
      final matchToCreate = _buildDefaultMatch(
        userId,
      ); // Assumes copyWith exists

      debug(
        data:
            "Creating new match for user: $userId with name: ${matchToCreate.name}",
      );

      // Add the document to Firestore, which generates an ID
      final DocumentReference newDocRef = await matchCollection.add(
        matchToCreate.toJson(), // Convert to Map for Firestore
      );

      debug(data: "New match created successfully with ID: ${newDocRef.id}");

      // Return the created match object with the new ID populated
      return matchToCreate.copyWith(id: newDocRef.id);
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during createMatch: ${e.message} code: ${e.code}",
      );
      throw Exception("Error creating match: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during createMatch: $e");
      throw Exception(
        "An unexpected error occurred while creating the match: $e",
      );
    }
  }

  // --- NEW: deleteMatch Implementation ---
  @override
  Future<bool> deleteMatch(String matchId) async {
    final userId =
        _getCurrentUserId(); // Get user ID (for logging/potential checks)

    if (matchId.isEmpty) {
      throw ArgumentError("Match ID cannot be empty for deletion.");
    }

    final DocumentReference matchDocRef = firestore
        .collection(FirestoreConstants.matches)
        .doc(matchId); // Get reference to the document

    try {
      debug(data: "Attempting to delete match: $matchId for user: $userId");

      // Delete the document.
      // Security is primarily handled by Firestore Security Rules
      // ensuring request.auth.uid == resource.data.userId
      await matchDocRef.delete();

      debug(data: "Match deleted successfully: $matchId");

      return true;
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during deleteMatch: ${e.message} code: ${e.code}",
      );
      if (e.code == 'permission-denied') {
        throw Exception("Permission denied to delete match $matchId.");
      } else if (e.code == 'not-found') {
        // Consider if this should be an error or just logged
        debug(
          data: "Match $matchId not found for deletion (already deleted?).",
        );
        // Optionally re-throw: throw Exception("Match not found for deletion.");
        return false; // Or simply return successfully if not-found is acceptable
      }
      throw Exception("Error deleting match: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during deleteMatch: $e");
      throw Exception(
        "An unexpected error occurred while deleting the match: $e",
      );
    }
  }
}
