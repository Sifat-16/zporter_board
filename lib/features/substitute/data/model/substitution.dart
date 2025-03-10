import 'package:mongo_dart/mongo_dart.dart' hide State;

class Substitution {
  final ObjectId teamId;
  final ObjectId playerOutId;
  final ObjectId playerInId;
  final int minute;

  Substitution({
    required this.teamId,
    required this.playerOutId,
    required this.playerInId,
    required this.minute,
  });

  factory Substitution.fromJson(Map<String, dynamic> json) {
    return Substitution(
      teamId: json['teamId'],
      playerOutId: json['playerOutId'],
      playerInId: json['playerInId'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'playerOutId': playerOutId,
      'playerInId': playerInId,
      'minute': minute,
    };
  }
}

class MatchSubstitutions {
  final List<Substitution> substitutions;

  MatchSubstitutions({List<Substitution>? substitutions}) : substitutions = substitutions ?? [];

  factory MatchSubstitutions.fromJson(Map<String, dynamic> json) {
    return MatchSubstitutions(
      substitutions: (json['substitutions'] as List)
          .map((sub) => Substitution.fromJson(sub))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'substitutions': substitutions.map((sub) => sub.toJson()).toList(),
    };
  }
}
