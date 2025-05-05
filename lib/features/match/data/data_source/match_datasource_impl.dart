import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zporter_board/core/constant/firestore_constant.dart'; // Ensure this path is correct
import 'package:zporter_board/core/services/user_id_service.dart';
import 'package:zporter_board/core/utils/log/debugger.dart'; // Your debugger
// Import your models and requests
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_sub_request.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart'; // For TimerMode enum
import 'package:zporter_tactical_board/app/generator/random_generator.dart'; // For default IDs
import 'package:zporter_tactical_board/app/helper/logger.dart'; // Assuming zlog is logger

class MatchDataSourceImpl implements MatchDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final UserIdService _userIdService;

  MatchDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
    required UserIdService userIdService,
  }) : _userIdService = userIdService;

  /// Gets the current Firebase User ID, throws if not authenticated.
  String _getCurrentUserId() {
    return _userIdService.getCurrentUserId();
  }

  /// --- Gets the DocumentReference for the user's single match document ---
  /// The document ID IS the user's ID.
  DocumentReference _getUserMatchDocRef() {
    final userId = _getCurrentUserId();
    return firestore.collection(FirestoreConstants.matches).doc(userId);
  }
  // --- End Helper ---

  /// --- Helper Function to Create a Default Match ---
  /// Note: The 'id' field in the returned object might be null or set later.
  /// The actual document ID used will be the userId.
  FootballMatch _buildDefaultMatch(String userId) {
    // Define default values (customize as needed)
    final defaultHomeTeam = Team(
      id: RandomGenerator.generateId(), // Nested object IDs are fine
      name: "Home Team",
      players: [],
    );
    final defaultAwayTeam = Team(
      id: RandomGenerator.generateId(),
      name: "Away Team",
      players: [],
    );
    final defaultScore = MatchScore(homeScore: 0, awayScore: 0);
    // Simpler default subs for example
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
          intervals: [],
          presetDuration: Duration(minutes: 3),
        ), // Example
      ),
    ];

    // Create the match object, ID will be set from document ref later
    return FootballMatch(
      id: userId, // Set the ID to the userId for consistency in the model
      userId: userId, // Store userId within the document too
      name: "My Match",
      matchPeriod: defaultMatchTime,
      homeTeam: defaultHomeTeam,
      awayTeam: defaultAwayTeam,
      matchScore: defaultScore,
      substitutions: defaultSubstitutions,
      venue: "Default Venue",
      // createdAt and updatedAt will be set by serverTimestamp on write
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// --- Updates the score for the user's single match ---
  @override
  Future<FootballMatch> updateMatchScore(
    UpdateMatchScoreRequest updateMatchScoreRequest,
  ) async {
    final userId = _getCurrentUserId();
    final docRef = _getUserMatchDocRef(); // Get reference to the single doc

    // Optional: Verify request matchId matches userId if needed
    if (updateMatchScoreRequest.matchId.isNotEmpty &&
        updateMatchScoreRequest.matchId != userId) {
      debug(
        data:
            "Firebase Warning: updateMatchScore called with ID ${updateMatchScoreRequest.matchId} but operating on user document $userId",
      );
    }

    try {
      debug(data: "Firebase: Updating score for match doc: $userId");
      final Map<String, dynamic> updateData = {
        'matchScore': updateMatchScoreRequest.newScore.toJson(),
        'updatedAt': FieldValue.serverTimestamp(), // Use server timestamp
      };
      await docRef.update(updateData);

      // Fetch and return updated document
      final updatedDoc = await docRef.get();
      if (!updatedDoc.exists)
        throw Exception("Match document $userId not found after score update.");
      debug(data: "Firebase: Match score updated successfully for $userId");
      return FootballMatch.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
        updatedDoc.id,
      );
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during updateMatchScore: ${e.message} code: ${e.code}",
      );
      if (e.code == 'not-found')
        throw Exception("Match not found for score update.");
      throw Exception("Error updating match score: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during updateMatchScore: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }

  /// --- Updates the time/status for the user's single match ---
  @override
  Future<FootballMatch> updateMatchTime(
    UpdateMatchTimeRequest updateMatchTimeRequest,
  ) async {
    final userId = _getCurrentUserId();
    final docRef = _getUserMatchDocRef(); // Get reference to the single doc

    // Optional: Verify request matchId matches userId if needed
    if (updateMatchTimeRequest.matchId.isNotEmpty &&
        updateMatchTimeRequest.matchId != userId) {
      debug(
        data:
            "Firebase Warning: updateMatchTime called with ID ${updateMatchTimeRequest.matchId} but operating on user document $userId",
      );
    }

    // The request contains the full match object with the updated time list
    final FootballMatch matchWithUpdatedTime =
        updateMatchTimeRequest.footballMatch;

    try {
      debug(data: "Firebase: Updating time/status for match doc: $userId");

      // Prepare update data - only update specific fields
      final Map<String, dynamic> updateData = {
        // Ensure correct field name 'matchPeriod' is used
        'matchPeriod':
            matchWithUpdatedTime.matchPeriod.map((p) => p.toJson()).toList(),
        'status':
            updateMatchTimeRequest.matchTimeUpdateStatus.name, // Update status
        'updatedAt': FieldValue.serverTimestamp(), // Use server timestamp
      };

      await docRef.update(updateData);

      // Fetch and return updated document
      final updatedDoc = await docRef.get();
      if (!updatedDoc.exists)
        throw Exception("Match document $userId not found after time update.");
      debug(
        data: "Firebase: Match time/status updated successfully for $userId",
      );
      zlog(
        data:
            "Firebase Timer data updated match periods length : ${FootballMatch.fromJson(updatedDoc.data() as Map<String, dynamic>, updatedDoc.id).matchPeriod.length}",
      );
      return FootballMatch.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
        updatedDoc.id,
      );
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during updateMatchTime: ${e.message} code: ${e.code}",
      );
      if (e.code == 'not-found')
        throw Exception("Match not found for time update.");
      throw Exception("Error updating match time: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during updateMatchTime: $e");
      throw Exception(
        "An unexpected error occurred while updating match time: $e",
      );
    }
  }

  /// --- Creates or Overwrites the single match document for the user ---
  @override
  Future<FootballMatch> createMatch({FootballMatch? footballMatch}) async {
    final userId = _getCurrentUserId();
    final docRef =
        _getUserMatchDocRef(); // Reference to the user's specific doc ID

    // Use provided match or build default, ensure userId is set
    final matchToSave = (footballMatch ?? _buildDefaultMatch(userId)).copyWith(
      userId: userId,
      id: userId, // Ensure ID in model matches doc ID
    );

    final matchJson = matchToSave.toJson();
    // Remove timestamps if they exist locally, let server generate them
    matchJson.remove('createdAt');
    matchJson.remove('updatedAt');

    try {
      debug(
        data:
            "Firebase: Creating/Overwriting match for user: $userId (Doc ID: $userId)",
      );

      // Use set() with merge:false (default) to create or fully overwrite
      await docRef.set({
        ...matchJson,
        'createdAt':
            FieldValue.serverTimestamp(), // Add server timestamp on create/set
        'updatedAt':
            FieldValue.serverTimestamp(), // Add server timestamp on create/set
      });

      debug(data: "Firebase: Match set successfully for doc $userId");

      // Fetch the document again to get server-generated timestamps
      final savedDoc = await docRef.get();
      if (!savedDoc.exists)
        throw Exception(
          "Match document $userId not found after set operation.",
        );

      return FootballMatch.fromJson(
        savedDoc.data() as Map<String, dynamic>,
        savedDoc.id,
      );
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during createMatch (set): ${e.message} code: ${e.code}",
      );
      throw Exception("Error setting match data: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during createMatch (set): $e");
      throw Exception(
        "An unexpected error occurred while setting match data: $e",
      );
    }
  }

  /// --- Deletes the single match document for the user ---
  @override
  Future<bool> deleteMatch(String matchId) async {
    final userId = _getCurrentUserId();

    // Verify the provided matchId matches the user's ID for safety
    if (matchId.isEmpty || matchId != userId) {
      throw ArgumentError("Invalid match ID provided for deletion.");
    }

    final docRef = _getUserMatchDocRef(); // Get reference using userId

    try {
      debug(data: "Firebase: Attempting to delete match document: $userId");
      await docRef.delete();
      debug(data: "Firebase: Match deleted successfully: $userId");
      return true; // Indicate success
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during deleteMatch: ${e.message} code: ${e.code}",
      );
      if (e.code == 'permission-denied') {
        throw Exception("Permission denied to delete match $userId.");
      } else if (e.code == 'not-found') {
        debug(
          data:
              "Firebase: Match $userId not found for deletion (already deleted?).",
        );
        return true; // Consider deletion successful if it doesn't exist
      }
      throw Exception("Error deleting match: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during deleteMatch: $e");
      throw Exception(
        "An unexpected error occurred while deleting the match: $e",
      );
    }
  }

  /// --- Clearing the DB in this context means deleting the user's single match ---
  @override
  Future<int> clearMatchDb() async {
    // This now deletes the specific user's match document
    debug(
      data:
          "Firebase: Clearing match DB means deleting the user's single match document.",
    );
    try {
      await deleteMatch(_getCurrentUserId()); // Call delete with the user's ID
      return 1; // Indicate one document was targeted for deletion
    } catch (e) {
      debug(data: "Firebase: Error during clearMatchDb (delete): $e");
      return 0; // Indicate failure or no document deleted
    }
  }

  /// --- Updates substitutions for the user's single match ---
  @override
  Future<FootballMatch> updateSub(UpdateSubRequest updateSubRequest) async {
    final userId = _getCurrentUserId();
    final docRef = _getUserMatchDocRef(); // Get reference to the single doc

    // Optional: Verify request matchId matches userId if needed
    if (updateSubRequest.matchId.isNotEmpty &&
        updateSubRequest.matchId != userId) {
      debug(
        data:
            "Firebase Warning: updateSub called with ID ${updateSubRequest.matchId} but operating on user document $userId",
      );
    }

    try {
      debug(data: "Firebase: Updating substitutions for match doc: $userId");

      // Prepare update data
      final Map<String, dynamic> updateData = {
        'substitutions': updateSubRequest.matchSubstitutions.toJson(),
        'updatedAt': FieldValue.serverTimestamp(), // Use server timestamp
      };

      await docRef.update(updateData);

      // Fetch and return updated document
      final updatedDoc = await docRef.get();
      if (!updatedDoc.exists)
        throw Exception(
          "Match document $userId not found after substitution update.",
        );
      debug(
        data: "Firebase: Match substitutions updated successfully for $userId",
      );
      return FootballMatch.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
        updatedDoc.id,
      );
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during updateSub: ${e.message} code: ${e.code}",
      );
      if (e.code == 'not-found')
        throw Exception("Match not found for substitution update.");
      throw Exception("Error updating match substitutions: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during updateSub: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }

  /// --- Gets the single match for the user, creates default if none exists ---
  @override
  Future<FootballMatch> getDefaultMatch() async {
    // This logic is now identical to getAllMatches, just returns single object
    final userId = _getCurrentUserId();
    final docRef = _getUserMatchDocRef();

    try {
      debug(data: "Firebase: Getting default/single match for user: $userId");
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        debug(data: "Firebase: Found existing match for user $userId");
        return FootballMatch.fromJson(
          docSnapshot.data() as Map<String, dynamic>,
          docSnapshot.id,
        );
      } else {
        debug(
          data: "Firebase: No match found for user $userId. Creating default.",
        );
        // Use createMatch logic to ensure saving with server timestamps
        final defaultMatch = _buildDefaultMatch(userId);
        final matchJson = defaultMatch.toJson();
        matchJson.remove('createdAt'); // Let server generate
        matchJson.remove('updatedAt');

        await docRef.set({
          ...matchJson,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        final newSnapshot = await docRef.get(); // Fetch again for timestamps
        return FootballMatch.fromJson(
          newSnapshot.data() as Map<String, dynamic>,
          newSnapshot.id,
        );
      }
    } on FirebaseException catch (e) {
      debug(data: "FirebaseException during getDefaultMatch: ${e.message}");
      throw Exception("Error fetching match data: ${e.message}");
    } catch (e) {
      debug(data: "Generic exception during getDefaultMatch: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }

  /// --- Adds a new period to the user's single match document ---
  @override
  Future<MatchPeriod> createNewPeriod({
    required MatchPeriod matchPeriod,
  }) async {
    final userId = _getCurrentUserId();
    final docRef = _getUserMatchDocRef();

    try {
      // Use Firestore transaction for atomic read-modify-write
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          // This shouldn't happen if getDefaultMatch/getAllMatches ensures creation
          throw Exception(
            "Firebase: Cannot add period, match document $userId does not exist.",
          );
        }

        // Parse current match data
        final currentMatch = FootballMatch.fromJson(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        );

        // Add the new period object to the list
        List<MatchPeriod> updatedPeriods = List.from(currentMatch.matchPeriod);
        // Ensure the period number isn't already present (optional check)
        if (updatedPeriods.any(
          (p) => p.periodNumber == matchPeriod.periodNumber,
        )) {
          // Decide whether to overwrite or throw error
          updatedPeriods.removeWhere(
            (p) => p.periodNumber == matchPeriod.periodNumber,
          );
        }
        updatedPeriods.add(matchPeriod);
        // Sort periods by number just in case
        updatedPeriods.sort((a, b) => a.periodNumber.compareTo(b.periodNumber));

        // Prepare update data
        final Map<String, dynamic> updateData = {
          'matchPeriod': updatedPeriods.map((p) => p.toJson()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
          // Optionally update status here if needed
        };

        // Update the document within the transaction
        transaction.update(docRef, updateData);
        debug(
          data:
              "Firebase: Added period ${matchPeriod.periodNumber} for match $userId in transaction.",
        );
      });

      // If transaction succeeds, return the added period
      return matchPeriod;
    } on FirebaseException catch (e) {
      debug(
        data:
            "FirebaseException during createNewPeriod transaction: ${e.message}",
      );
      throw Exception("Failed to add period remotely: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during createNewPeriod transaction: $e");
      throw Exception("An unexpected error occurred while adding period: $e");
    }
  }

  /// --- Updates an existing period in the user's single match document ---
  @override
  Future<MatchPeriod> updatePeriod(MatchPeriod matchPeriodToUpdate) async {
    final userId = _getCurrentUserId();
    final docRef = _getUserMatchDocRef();

    try {
      // Use Firestore transaction
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception(
            "Firebase: Cannot update period, match document $userId does not exist.",
          );
        }

        final currentMatch = FootballMatch.fromJson(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        );

        // Find the index of the period to update
        final int periodIndex = currentMatch.matchPeriod.indexWhere(
          (p) => p.periodNumber == matchPeriodToUpdate.periodNumber,
        );

        if (periodIndex == -1) {
          throw Exception(
            "Firebase: Cannot update period, period number ${matchPeriodToUpdate.periodNumber} not found in match.",
          );
        }

        // Create the updated list
        List<MatchPeriod> updatedPeriods = List.from(currentMatch.matchPeriod);
        updatedPeriods[periodIndex] =
            matchPeriodToUpdate; // Replace with updated object

        // Prepare update data
        final Map<String, dynamic> updateData = {
          'matchPeriod': updatedPeriods.map((p) => p.toJson()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
          // Optionally update status
        };

        // Update within transaction
        transaction.update(docRef, updateData);
        debug(
          data:
              "Firebase: Updated period ${matchPeriodToUpdate.periodNumber} for match $userId in transaction.",
        );
      });

      // If transaction succeeds, return the updated period
      return matchPeriodToUpdate;
    } on FirebaseException catch (e) {
      debug(
        data: "FirebaseException during updatePeriod transaction: ${e.message}",
      );
      throw Exception("Failed to update period remotely: ${e.message}");
    } catch (e) {
      debug(data: "Generic Exception during updatePeriod transaction: $e");
      throw Exception("An unexpected error occurred while updating period: $e");
    }
  }
}
