class MatchTime {
  final DateTime startTime;
  final DateTime? lastStoppedTime;
  final bool isRunning;
  final int elapsedMinutes;

  MatchTime({
    required this.startTime,
    this.lastStoppedTime,
    required this.isRunning,
    required this.elapsedMinutes,
  });

  factory MatchTime.fromJson(Map<String, dynamic> json) {
    return MatchTime(
      startTime: DateTime.parse(json['startTime']),
      lastStoppedTime: json['lastStoppedTime'] != null ? DateTime.parse(json['lastStoppedTime']) : null,
      isRunning: json['isRunning'],
      elapsedMinutes: json['elapsedMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'lastStoppedTime': lastStoppedTime?.toIso8601String(),
      'isRunning': isRunning,
      'elapsedMinutes': elapsedMinutes,
    };
  }
}
