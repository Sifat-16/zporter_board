import 'package:mongo_dart/mongo_dart.dart' as md;
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class FootballMatch {
  final md.ObjectId id;
  final String name;
   List<MatchTime> matchTime; // List of match time periods
  final String status;
  final Team homeTeam;
  final Team awayTeam;
  final MatchScore matchScore;
  final MatchSubstitutions substitutions;
  final String venue;

  FootballMatch({
    required this.id,
    required this.name,
    required this.matchTime,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchScore,
    required this.substitutions,
    required this.venue,
  });

  factory FootballMatch.fromJson(Map<String, dynamic> json) {
    return FootballMatch(
      id: json['_id'],
      name: json['name'],
      matchTime: (json['matchTime'] as List).map((e) => MatchTime.fromJson(e)).toList(),
      status: json['status'],
      homeTeam: Team.fromJson(json['homeTeam']),
      awayTeam: Team.fromJson(json['awayTeam']),
      matchScore: MatchScore.fromJson(json['matchScore']),
      substitutions: MatchSubstitutions.fromJson(json['substitutions']),
      venue: json['venue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,  // Converts ObjectId to string
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
}

