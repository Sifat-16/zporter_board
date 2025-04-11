// Removed mongo_dart import

class Substitution {
  // These IDs likely refer to Team/Player IDs within the match structure.
  // Keep them as String, assuming those referenced objects also have String IDs.
  final String teamId;
  final String playerOutId;
  final String playerInId;
  final int minute;

  Substitution({
    required this.teamId,
    required this.playerOutId,
    required this.playerInId,
    required this.minute,
  });

  factory Substitution.fromJson(Map<String, dynamic> json) {
    return Substitution(
      teamId: json['teamId'] as String, // Changed from ObjectId to String
      playerOutId:
          json['playerOutId'] as String, // Changed from ObjectId to String
      playerInId:
          json['playerInId'] as String, // Changed from ObjectId to String
      minute: (json['minute'] as num).toInt(), // Ensure correct parsing
    );
  }

  Map<String, dynamic> toJson() {
    // No change needed here if fields were already correctly named
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

  MatchSubstitutions({List<Substitution>? substitutions})
    : substitutions = substitutions ?? [];

  factory MatchSubstitutions.fromJson(Map<String, dynamic> json) {
    return MatchSubstitutions(
      substitutions:
          (json['substitutions'] as List<dynamic>? ?? []) // Handle null
              .map((sub) => Substitution.fromJson(sub as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'substitutions': substitutions.map((sub) => sub.toJson()).toList()};
  }
}
