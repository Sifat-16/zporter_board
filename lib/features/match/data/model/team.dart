import 'package:mongo_dart/mongo_dart.dart';

class Team {
  final ObjectId id;
  final String name;
  final List<Player> players;

  Team({ObjectId? id, required this.name, required this.players}) : id = id ?? ObjectId();

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'],
      name: json['name'],
      players: (json['players'] as List).map((p) => Player.fromJson(p)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }
}

class Player {
  final ObjectId id;
  final String name;
  final String position;
  final int jerseyNumber;

  Player({ObjectId? id, required this.name, required this.position, required this.jerseyNumber})
      : id = id ?? ObjectId();

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['_id'],
      name: json['name'],
      position: json['position'],
      jerseyNumber: json['jerseyNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'position': position,
      'jerseyNumber': jerseyNumber,
    };
  }
}
