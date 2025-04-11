import 'package:cloud_firestore/cloud_firestore.dart'; // Import needed if using Firestore Timestamps
// Assuming these imports are correct for your project structure
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class FootballMatch {
  final String? id;
  final String userId;
  final String name;
  List<MatchTime>
  matchTime; // Consider making final if not modified after creation
  final String status;
  final Team homeTeam;
  final Team awayTeam;
  final MatchScore matchScore;
  final MatchSubstitutions substitutions;
  final String venue;
  // --- NEW FIELDS ---
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FootballMatch({
    this.id,
    required this.userId,
    required this.name,
    required this.matchTime,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchScore,
    required this.substitutions,
    required this.venue,
    // --- Add timestamps to constructor (optional) ---
    this.createdAt,
    this.updatedAt,
  });

  factory FootballMatch.fromJson(
    Map<String, dynamic> json,
    String? documentId, // Firestore document ID passed separately
  ) {
    // Helper function for safe DateTime parsing from various potential types
    DateTime? _parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) {
        // Handle Firestore Timestamp directly
        return value.toDate();
      } else if (value is String) {
        return DateTime.tryParse(value); // Handle ISO 8601 String
      }
      // Add handling for other potential formats if necessary
      return null;
    }

    return FootballMatch(
      id: documentId ?? json['id'] as String?, // Prefer explicit documentId
      userId: json['userId'] as String? ?? '', // Provide default if null
      name: json['name'] as String? ?? 'Unnamed Match', // Provide default
      matchTime:
          (json['matchTime'] as List<dynamic>? ?? [])
              .map((e) => MatchTime.fromJson(e as Map<String, dynamic>))
              .toList(),
      status: json['status'] as String? ?? 'Scheduled', // Provide default
      // Add null checks for nested objects before calling fromJson
      homeTeam: Team.fromJson(json['homeTeam'] as Map<String, dynamic>? ?? {}),
      awayTeam: Team.fromJson(json['awayTeam'] as Map<String, dynamic>? ?? {}),
      matchScore: MatchScore.fromJson(
        json['matchScore'] as Map<String, dynamic>? ?? {},
      ),
      substitutions: MatchSubstitutions.fromJson(
        json['substitutions'] as Map<String, dynamic>? ?? {},
      ),
      venue: json['venue'] as String? ?? 'Unknown Venue', // Provide default
      // --- Deserialize timestamps ---
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    // Note: When SAVING to Firestore:
    // - For creation: Set 'createdAt' and 'updatedAt' to FieldValue.serverTimestamp().
    // - For updates: Set only 'updatedAt' to FieldValue.serverTimestamp().
    // You might omit them from toJson entirely if using server timestamps,
    // or only include them if they already have a value (e.g., fromJson).
    return {
      // 'id' is usually omitted in toJson as it's the document ID
      'userId': userId,
      'name': name,
      'matchTime': matchTime.map((e) => e.toJson()).toList(),
      'status': status,
      'homeTeam': homeTeam.toJson(),
      'awayTeam': awayTeam.toJson(),
      'matchScore': matchScore.toJson(),
      'substitutions': substitutions.toJson(),
      'venue': venue,
      // --- Serialize timestamps ---
      // Convert DateTime to ISO8601 String (common for JSON)
      // Firestore can store strings, but Timestamps are often preferred.
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      // Alternative: Convert to Firestore Timestamp if needed BEFORE saving
      // 'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      // 'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  // Optional: copyWith method
  FootballMatch copyWith({
    String? id, // Keep nullable to allow copying without an ID initially
    bool clearId = false, // Flag to explicitly nullify ID during copy
    String? userId,
    String? name,
    List<MatchTime>? matchTime,
    String? status,
    Team? homeTeam,
    Team? awayTeam,
    MatchScore? matchScore,
    MatchSubstitutions? substitutions,
    String? venue,
    // --- Add timestamp parameters ---
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // Assuming nested models have their own copyWith methods for deep copies
    return FootballMatch(
      id: clearId ? null : (id ?? this.id), // Handle ID clearing/copying
      userId: userId ?? this.userId,
      name: name ?? this.name,
      matchTime:
          matchTime ??
          this.matchTime.map((e) => e.copyWith()).toList(), // Deep copy example
      status: status ?? this.status,
      homeTeam: homeTeam ?? this.homeTeam, // Deep copy example
      awayTeam: awayTeam ?? this.awayTeam, // Deep copy example
      matchScore: matchScore ?? this.matchScore, // Deep copy example
      substitutions: substitutions ?? this.substitutions, // Deep copy example
      venue: venue ?? this.venue,
      // --- Copy timestamps ---
      createdAt: createdAt ?? this.createdAt, // DateTime is immutable
      updatedAt: updatedAt ?? this.updatedAt, // DateTime is immutable
    );
  }
}
