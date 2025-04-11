// Removed mongo_dart import

class MatchTime {
  // ID was already String, let's make it nullable for consistency
  String? id;
  DateTime startTime;
  DateTime? endTime;
  String? nextId; // Keep as String?

  MatchTime({
    this.id, // Made nullable
    required this.startTime,
    this.endTime,
    this.nextId,
  });

  factory MatchTime.fromJson(Map<String, dynamic> json) {
    return MatchTime(
      id: json['id'] as String?, // Changed key from '_id'
      // Ensure robust DateTime parsing
      startTime: _parseDateTime(json['startTime'])!, // Use helper
      endTime: _parseDateTime(json['endTime']), // Use helper
      nextId: json['nextId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Changed key from '_id'
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'nextId': nextId,
    };
  }

  MatchTime copyWith({
    String? id,
    DateTime? startTime,
    // Allow explicitly setting endTime to null
    bool clearEndTime = false,
    DateTime? endTime,
    // Allow explicitly setting nextId to null
    bool clearNextId = false,
    String? nextId,
  }) {
    return MatchTime(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      nextId: clearNextId ? null : (nextId ?? this.nextId),
    );
  }

  // Helper function for robust DateTime parsing (Firestore Timestamps or ISO Strings)
  static DateTime? _parseDateTime(dynamic jsonValue) {
    if (jsonValue == null) return null;
    if (jsonValue is String) {
      return DateTime.tryParse(jsonValue);
    }
    // Add check for Firestore Timestamp if you use it directly
    // if (jsonValue is Timestamp) { // Import 'package:cloud_firestore/cloud_firestore.dart';
    //   return jsonValue.toDate();
    // }
    return null; // Or throw an error if format is unexpected
  }
}
