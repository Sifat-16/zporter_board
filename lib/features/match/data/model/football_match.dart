import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class FootballMatch {
  final ObjectId id;
  final String name;
  final MatchTime matchTime;
  final String status;
  final Team homeTeam;
  final Team awayTeam;
  final MatchScore matchScore;
  final MatchSubstitutions substitutions;
  final String venue;

  FootballMatch({
    ObjectId? id,
    required this.name,
    required this.matchTime,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchScore,
    required this.substitutions,
    required this.venue,
  }) : id = id ?? ObjectId();

  factory FootballMatch.fromJson(Map<String, dynamic> json) {
    return FootballMatch(
      id: json['_id'],
      name: json['name'],
      matchTime: MatchTime.fromJson(json['matchTime']),
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
      '_id': id,
      'name': name,
      'matchTime': matchTime.toJson(),
      'status': status,
      'homeTeam': homeTeam.toJson(),
      'awayTeam': awayTeam.toJson(),
      'matchScore': matchScore.toJson(),
      'substitutions': substitutions.toJson(),
      'venue': venue,
    };
  }
}
