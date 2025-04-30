import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';

class MatchPeriod {
  int periodNumber;
  TimerMode timerMode;
  // ---------------------------------------------------
  Duration? presetDuration;
  List<MatchTimeBloc> intervals;

  MatchPeriod({
    required this.periodNumber,
    required this.timerMode,
    this.presetDuration,
    required this.intervals,
  });

  factory MatchPeriod.fromJson(Map<String, dynamic> json) {
    TimerMode timerModeFromString(String? modeString) {
      switch (modeString?.toUpperCase()) {
        case "DOWN":
          return TimerMode.DOWN;
        case "EXTRA":
          return TimerMode.EXTRA;
        case "UP":
        default:
          return TimerMode.UP; // Default to UP for null or unrecognized strings
      }
    }

    // Handle Duration deserialization carefully
    int? presetMillis = json['presetDurationMillis'] as int?;
    Duration? presetDuration =
        presetMillis != null ? Duration(milliseconds: presetMillis) : null;

    // --- CHANGE: Convert string from JSON to enum ---
    // Read the string value, default to "UP" if missing/null
    final String timerModeStringFromJson = json['timerMode'] as String? ?? "UP";
    // Convert the string to the TimerMode enum using the helper function
    final TimerMode timerModeEnum = timerModeFromString(
      timerModeStringFromJson,
    );
    // ------------------------------------------------

    return MatchPeriod(
      periodNumber:
          json['periodNumber'] as int? ?? 1, // Default to 1 if missing
      // Assign the converted enum value
      timerMode: timerModeEnum, // <--- Use enum value
      presetDuration: presetDuration,
      intervals:
          (json['intervals'] as List<dynamic>? ?? [])
              .map((e) => MatchTimeBloc.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  // Method to convert a MatchPeriod instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'periodNumber': periodNumber,
      // --- CHANGE: Convert enum back to string for JSON storage ---
      // Using '.name' gives the standard enum string representation ("UP", "DOWN", "EXTRA")
      'timerMode': timerMode.name,
      // ---------------------------------------------------------
      // Store Duration as milliseconds for reliable serialization
      'presetDurationMillis': presetDuration?.inMilliseconds,
      'intervals': intervals.map((e) => e.toJson()).toList(),
    };
  }

  // CopyWith method for creating modified instances (useful for state management)
  MatchPeriod copyWith({
    int? periodNumber,
    // --- CHANGE: Parameter type is now TimerMode? ---
    TimerMode? timerMode,
    // ------------------------------------------------
    Duration? presetDuration,
    bool clearPresetDuration =
        false, // Flag to explicitly set presetDuration to null
    List<MatchTimeBloc>? intervals,
  }) {
    return MatchPeriod(
      periodNumber: periodNumber ?? this.periodNumber,
      // --- CHANGE: Assign enum value ---
      timerMode: timerMode ?? this.timerMode,
      // ---------------------------------
      presetDuration:
          clearPresetDuration ? null : (presetDuration ?? this.presetDuration),
      intervals:
          intervals ??
          this.intervals
              .map((e) => e.copyWith())
              .toList(), // Deep copy intervals
    );
  }

  // Optional: Add helper methods if needed, e.g., calculate elapsed time for this period
  Duration calculateElapsedRunningTime() {
    Duration elapsed = Duration.zero;
    DateTime now = DateTime.now(); // Capture current time once
    for (final interval in intervals) {
      if (interval.endTime != null) {
        // Completed interval
        // Ensure difference is not negative
        Duration diff = interval.endTime!.difference(interval.startTime);
        elapsed += (diff.isNegative ? Duration.zero : diff);
      } else {
        // Currently running interval
        Duration diff = now.difference(interval.startTime);
        elapsed += (diff.isNegative ? Duration.zero : diff);
      }
    }
    // Final check
    return elapsed.isNegative ? Duration.zero : elapsed;
  }
}

class MatchTimeBloc {
  // ID was already String, let's make it nullable for consistency
  String? id;
  DateTime startTime;
  DateTime? endTime;
  String? nextId; // Keep as String?

  MatchTimeBloc({
    this.id, // Made nullable
    required this.startTime,
    this.endTime,
    this.nextId,
  });

  factory MatchTimeBloc.fromJson(Map<String, dynamic> json) {
    return MatchTimeBloc(
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

  MatchTimeBloc copyWith({
    String? id,
    DateTime? startTime,
    // Allow explicitly setting endTime to null
    bool clearEndTime = false,
    DateTime? endTime,
    // Allow explicitly setting nextId to null
    bool clearNextId = false,
    String? nextId,
  }) {
    return MatchTimeBloc(
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
