import 'package:mongo_dart/mongo_dart.dart' hide State;

class MatchTime {
   String id;         // Unique ID for this match time
   DateTime startTime;  // Start time of this period
   DateTime? endTime;   // End time (nullable if ongoing)
   String? nextId;    // Points to the next match time segment


  MatchTime({
    String? id,
    required this.startTime,
    this.endTime,
    this.nextId,
  }) : id = id ?? ""; // Generate a unique ID if not provided

  /// Convert JSON to MatchTime object
  factory MatchTime.fromJson(Map<String, dynamic> json) {
    return MatchTime(
      id: json['_id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      nextId: json['nextId']
    );
  }

  /// Convert MatchTime object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'nextId': nextId
    };
  }

  /// Copy with new values (for updating an instance)
  MatchTime copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    String? nextId,

  }) {
    return MatchTime(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      nextId: nextId ?? this.nextId
    );
  }
}
