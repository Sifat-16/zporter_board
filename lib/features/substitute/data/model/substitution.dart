import 'package:flutter/foundation.dart'; // For listEquals, required

// --- Substitution Class (Optional: Added copyWith and equality) ---
class Substitution {
  final String id; // ID of the team making the sub
  final String playerOutId;
  final String playerInId;
  final int minute; // Minute of the match

  Substitution({
    required this.id,
    required this.playerOutId,
    required this.playerInId,
    required this.minute,
  });

  // Factory constructor remains mostly the same, added null checks
  factory Substitution.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final playerOutId = json['playerOutId'] as String?;
    final playerInId = json['playerInId'] as String?;
    final minuteNum = json['minute'] as num?; // Allow num then convert

    if (id == null ||
        playerOutId == null ||
        playerInId == null ||
        minuteNum == null) {
      throw FormatException(
        'Missing required fields in Substitution JSON: $json',
      );
    }

    return Substitution(
      id: id,
      playerOutId: playerOutId,
      playerInId: playerInId,
      minute: minuteNum.toInt(), // Convert num to int
    );
  }

  // toJson remains the same
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerOutId': playerOutId,
      'playerInId': playerInId,
      'minute': minute,
    };
  }

  // Optional: copyWith method
  Substitution copyWith({
    String? id,
    String? playerOutId,
    String? playerInId,
    int? minute,
  }) {
    return Substitution(
      id: id ?? this.id,
      playerOutId: playerOutId ?? this.playerOutId,
      playerInId: playerInId ?? this.playerInId,
      minute: minute ?? this.minute,
    );
  }

  // Optional: Equality operators
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Substitution &&
        other.id == id &&
        other.playerOutId == playerOutId &&
        other.playerInId == playerInId &&
        other.minute == minute;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      playerOutId.hashCode ^
      playerInId.hashCode ^
      minute.hashCode;

  @override
  String toString() {
    return 'Substitution(teamId: $id, out: $playerOutId, in: $playerInId, min: $minute)';
  }
}

// --- Updated MatchSubstitutions Class ---
class MatchSubstitutions {
  // --- CHANGED Properties ---
  /// List of substitutions made by the home team.
  final List<Substitution> homeSubs;

  /// List of substitutions made by the away team.
  final List<Substitution> awaySubs;

  // --- UPDATED Constructor ---
  MatchSubstitutions({
    List<Substitution>? homeSubs, // Optional list for home
    List<Substitution>? awaySubs, // Optional list for away
  }) : homeSubs = homeSubs ?? [], // Default to empty list if null
       awaySubs = awaySubs ?? []; // Default to empty list if null

  // --- UPDATED fromJson Factory ---
  factory MatchSubstitutions.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse a list of substitutions from JSON
    List<Substitution> _parseSubsList(dynamic listJson) {
      if (listJson is List) {
        return listJson
            .map((subJson) {
              try {
                // Ensure the item in the list is a map
                if (subJson is Map<String, dynamic>) {
                  return Substitution.fromJson(subJson);
                }
                print(
                  "Warning: Skipping non-map item in substitutions list: $subJson",
                );
                return null;
              } catch (e) {
                print(
                  "Warning: Skipping invalid Substitution JSON item: $subJson | Error: $e",
                );
                return null; // Return null for invalid items
              }
            })
            .whereType<
              Substitution
            >() // Filter out any nulls from parsing errors
            .toList();
      }
      return []; // Return empty list if input is not a list or is null
    }

    return MatchSubstitutions(
      // Parse 'homeSubs' and 'awaySubs' keys from JSON
      homeSubs: _parseSubsList(json['homeSubs']),
      awaySubs: _parseSubsList(json['awaySubs']),
    );
  }

  // --- UPDATED toJson Method ---
  Map<String, dynamic> toJson() {
    return {
      // Serialize both lists under separate keys
      'homeSubs': homeSubs.map((sub) => sub.toJson()).toList(),
      'awaySubs': awaySubs.map((sub) => sub.toJson()).toList(),
    };
  }

  // --- ADDED copyWith Method ---
  MatchSubstitutions copyWith({
    List<Substitution>? homeSubs,
    List<Substitution>? awaySubs,
  }) {
    return MatchSubstitutions(
      // If a new list is provided, use it. Otherwise, create a deep copy
      // of the existing list by copying each Substitution object.
      homeSubs: homeSubs ?? this.homeSubs.map((s) => s.copyWith()).toList(),
      awaySubs: awaySubs ?? this.awaySubs.map((s) => s.copyWith()).toList(),
    );
  }

  // Optional: Equality operators
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // Requires import 'package:flutter/foundation.dart'; for listEquals
    return other is MatchSubstitutions &&
        runtimeType == other.runtimeType &&
        listEquals(homeSubs, other.homeSubs) &&
        listEquals(awaySubs, other.awaySubs);
  }

  @override
  String toString() {
    return 'MatchSubstitutions(homeSubs: ${homeSubs.length}, awaySubs: ${awaySubs.length})';
  }
}
