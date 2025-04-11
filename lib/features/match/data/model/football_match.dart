// Removed mongo_dart import
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart'; // Assuming score model is correct
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class FootballMatch {
  final String? id; // Changed from ObjectId to String?
  final String userId; // Added userId
  final String name;
  List<MatchTime> matchTime;
  final String status;
  final Team homeTeam;
  final Team awayTeam;
  final MatchScore matchScore; // Assuming MatchScore model is compatible
  final MatchSubstitutions substitutions;
  final String venue;

  FootballMatch({
    this.id, // Made nullable
    required this.userId, // Added required userId
    required this.name,
    required this.matchTime,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchScore,
    required this.substitutions,
    required this.venue,
  });

  factory FootballMatch.fromJson(
    Map<String, dynamic> json,
    String? documentId,
  ) {
    // Accept documentId explicitly if needed, otherwise use 'id' from json
    return FootballMatch(
      id: documentId ?? json['id'] as String?, // Use documentId or json['id']
      userId: json['userId'] as String, // Added userId deserialization
      name: json['name'] as String,
      matchTime:
          (json['matchTime'] as List<dynamic>? ??
                  []) // Handle potential null list
              .map((e) => MatchTime.fromJson(e as Map<String, dynamic>))
              .toList(),
      status: json['status'] as String,
      homeTeam: Team.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: Team.fromJson(json['awayTeam'] as Map<String, dynamic>),
      matchScore: MatchScore.fromJson(
        json['matchScore'] as Map<String, dynamic>,
      ), // Cast map
      substitutions: MatchSubstitutions.fromJson(
        json['substitutions'] as Map<String, dynamic>,
      ), // Cast map
      venue: json['venue'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Usually Firestore Document ID isn't stored inside the document itself
      'userId': userId, // Added userId serialization
      'name': name,
      'matchTime': matchTime.map((e) => e.toJson()).toList(),
      'status': status,
      'homeTeam': homeTeam.toJson(),
      'awayTeam': awayTeam.toJson(),
      'matchScore': matchScore.toJson(),
      'substitutions': substitutions.toJson(),
      'venue': venue,
    };
  }

  // Optional: copyWith method
  FootballMatch copyWith({
    String? id,
    String? userId,
    String? name,
    List<MatchTime>? matchTime,
    String? status,
    Team? homeTeam,
    Team? awayTeam,
    MatchScore? matchScore,
    MatchSubstitutions? substitutions,
    String? venue,
  }) {
    return FootballMatch(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      matchTime: matchTime ?? this.matchTime,
      status: status ?? this.status,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      matchScore: matchScore ?? this.matchScore,
      substitutions: substitutions ?? this.substitutions,
      venue: venue ?? this.venue,
    );
  }
}
