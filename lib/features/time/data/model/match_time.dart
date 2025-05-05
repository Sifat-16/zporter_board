import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';

class MatchPeriod {
  int periodNumber;
  TimerMode timerMode;
  // NOTE: presetDuration field for DOWN mode is removed as per your code snippet
  List<MatchTimeBloc> intervals; // For UP/DOWN mode time tracking
  ExtraTime extraTime; // Holds extra time details (nullable)

  TimeActiveStatus upPeriodStatus; // Status of the main UP/DOWN timer
  TimeActiveStatus extraPeriodStatus; // Status of the EXTRA timer

  MatchPeriod({
    required this.periodNumber,
    required this.timerMode,
    this.intervals = const [], // Default to empty list
    required this.extraTime, // Make nullable
    this.upPeriodStatus = TimeActiveStatus.STOPPED,
    this.extraPeriodStatus = TimeActiveStatus.STOPPED,
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
          return TimerMode.UP; // Default to UP
      }
    }

    TimeActiveStatus timeActiveStatusFromString(String? statusString) {
      switch (statusString?.toUpperCase()) {
        case 'RUNNING':
          return TimeActiveStatus.RUNNING;
        case 'PAUSED':
          return TimeActiveStatus.PAUSED;
        case 'STOPPED': // Treat STOPPED and null/default the same
        default:
          return TimeActiveStatus.STOPPED;
      }
    }

    // --- timerMode conversion ---
    final String timerModeStringFromJson = json['timerMode'] as String? ?? "UP";
    final TimerMode timerModeEnum = timerModeFromString(
      timerModeStringFromJson,
    );
    // --------------------------

    // --- Deserialize nested extraTime object if present ---
    final Map<String, dynamic> extraTimeJson =
        json['extraTime'] as Map<String, dynamic>;
    final ExtraTime extraTimeObject = ExtraTime.fromJson(extraTimeJson);

    final String mainStatusString =
        json['upPeriodStatus'] as String? ?? 'STOPPED';
    final TimeActiveStatus mainStatusEnum = timeActiveStatusFromString(
      mainStatusString,
    );

    final String extraStatusString =
        json['extraPeriodStatus'] as String? ?? 'STOPPED';
    final TimeActiveStatus extraStatusEnum = timeActiveStatusFromString(
      extraStatusString,
    );

    // ----------------------------------------------------

    return MatchPeriod(
      periodNumber: json['periodNumber'] as int? ?? 1,
      timerMode: timerModeEnum,
      // presetDuration field removed
      intervals:
          (json['intervals'] as List<dynamic>? ?? [])
              .map((e) => MatchTimeBloc.fromJson(e as Map<String, dynamic>))
              .toList(),
      extraTime: extraTimeObject, // Assign deserialized object (or null)
      upPeriodStatus: mainStatusEnum, // Assign main status enum
      extraPeriodStatus: extraStatusEnum,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodNumber': periodNumber,
      'timerMode': timerMode.name, // Store enum as string
      // presetDuration field removed
      'intervals': intervals.map((e) => e.toJson()).toList(),
      // --- Serialize nested extraTime object if present ---
      'extraTime': extraTime.toJson(), // Use null-aware call
      'mainPeriodStatus': upPeriodStatus.name, // Store enum as string
      'extraPeriodStatus': extraPeriodStatus.name,
      // -------------------------------------------------
    };
  }

  MatchPeriod copyWith({
    int? periodNumber,
    TimerMode? timerMode,
    // presetDuration parameter removed
    List<MatchTimeBloc>? intervals,
    ExtraTime? extraTime,
    TimeActiveStatus? upPeriodStatus,
    TimeActiveStatus? extraPeriodStatus,
    bool clearExtraTime = false, // Flag to explicitly set extraTime to null
  }) {
    return MatchPeriod(
      periodNumber: periodNumber ?? this.periodNumber,
      timerMode: timerMode ?? this.timerMode,
      // presetDuration field removed
      intervals: intervals ?? this.intervals.map((e) => e.copyWith()).toList(),
      // Handle copying/clearing extraTime
      extraTime:
          extraTime ?? this.extraTime, // Use copyWith for deep copy if not null
      upPeriodStatus: upPeriodStatus ?? this.upPeriodStatus,
      extraPeriodStatus: extraPeriodStatus ?? this.extraPeriodStatus,
    );
  }

  // Calculates elapsed time based on the MAIN 'intervals' list
  // Used primarily for UP mode display or DOWN mode calculation (if presetDuration existed)
  Duration calculateElapsedRunningTime() {
    Duration elapsed = Duration.zero;
    DateTime now = DateTime.now();
    for (final interval in intervals) {
      if (interval.endTime != null) {
        Duration diff = interval.endTime!.difference(interval.startTime);
        elapsed += (diff.isNegative ? Duration.zero : diff);
      } else {
        // Currently running interval
        Duration diff = now.difference(interval.startTime);
        elapsed += (diff.isNegative ? Duration.zero : diff);
      }
    }
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

class ExtraTime {
  Duration presetDuration;
  List<MatchTimeBloc> intervals;

  ExtraTime({
    required this.presetDuration,
    this.intervals = const [], // Default to empty list
  });

  factory ExtraTime.fromJson(Map<String, dynamic> json) {
    int? presetMillis = json['presetDurationMillis'] as int?;
    // Default extra time duration if missing? e.g., 3 minutes or 0? Let's use 0.
    Duration presetDuration =
        presetMillis != null
            ? Duration(milliseconds: presetMillis)
            : Duration.zero;

    return ExtraTime(
      presetDuration: presetDuration,
      intervals:
          (json['intervals'] as List<dynamic>? ?? [])
              .map((e) => MatchTimeBloc.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presetDurationMillis': presetDuration.inMilliseconds,
      'intervals': intervals.map((e) => e.toJson()).toList(),
    };
  }

  ExtraTime copyWith({
    Duration? presetDuration,
    List<MatchTimeBloc>? intervals,
  }) {
    return ExtraTime(
      presetDuration: presetDuration ?? this.presetDuration,
      intervals: intervals ?? this.intervals.map((e) => e.copyWith()).toList(),
    );
  }

  // Helper to calculate elapsed running time *within* this extra time period
  Duration calculateElapsedRunningTime() {
    Duration elapsed = Duration.zero;
    DateTime now = DateTime.now();
    for (final interval in intervals) {
      if (interval.endTime != null) {
        Duration diff = interval.endTime!.difference(interval.startTime);
        elapsed += (diff.isNegative ? Duration.zero : diff);
      } else {
        // Currently running interval within extra time
        Duration diff = now.difference(interval.startTime);
        elapsed += (diff.isNegative ? Duration.zero : diff);
      }
    }
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  // Helper to calculate remaining extra time
  Duration calculateRemainingTime() {
    final elapsed = calculateElapsedRunningTime();
    final remaining = presetDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
