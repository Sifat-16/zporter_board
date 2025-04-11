class Team {
  final String? id; // Changed from ObjectId to String?
  final String name;
  final List<Player> players;

  // Removed default ObjectId generation
  Team({this.id, required this.name, required this.players});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      // Assuming 'id' might be present if nested object has an ID, otherwise null
      id: json['id'] as String?, // Changed key from '_id' and type
      name: json['name'] as String,
      players:
          (json['players'] as List<dynamic>? ??
                  []) // Handle potential null list
              .map((p) => Player.fromJson(p as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Changed key from '_id'
      'name': name,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }

  // Optional: copyWith
  Team copyWith({String? id, String? name, List<Player>? players}) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
    );
  }
}

// Removed mongo_dart import

class Player {
  final String? id; // Changed from ObjectId to String?
  final String name;
  final String position;
  final int jerseyNumber;

  // Removed default ObjectId generation
  Player({
    this.id,
    required this.name,
    required this.position,
    required this.jerseyNumber,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String?, // Changed key from '_id' and type
      name: json['name'] as String,
      position: json['position'] as String,
      // Ensure jerseyNumber is parsed correctly (might be double from JSON)
      jerseyNumber: (json['jerseyNumber'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Changed key from '_id'
      'name': name,
      'position': position,
      'jerseyNumber': jerseyNumber,
    };
  }

  // Optional: copyWith
  Player copyWith({
    String? id,
    String? name,
    String? position,
    int? jerseyNumber,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
    );
  }
}
