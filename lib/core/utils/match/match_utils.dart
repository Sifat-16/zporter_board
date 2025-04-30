import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/entity/match_time_status.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class MatchUtils {
  static MatchTimeStatus getMatchTime(List<MatchTimeBloc> matchTimes) {
    try {
      MatchTimeStatus matchTimeStatus;
      if (matchTimes.isEmpty) {
        matchTimeStatus = MatchTimeStatus(elapsedSeconds: 0, isRunning: false);
        return matchTimeStatus; // Default if match data is missing
      }

      MatchTimeBloc? endMatchTime;
      int endTimeIndex = matchTimes.indexWhere((e) => e.endTime == null);

      if (endTimeIndex != -1) {
        endMatchTime = matchTimes[endTimeIndex];
      }

      if (endMatchTime == null) {
        // timer is stopped
        int elapsedSeconds = 0;
        for (MatchTimeBloc m in matchTimes) {
          elapsedSeconds += (m.endTime?.difference(m.startTime).inSeconds ?? 0);
        }
        matchTimeStatus = MatchTimeStatus(
          elapsedSeconds: elapsedSeconds,
          isRunning: false,
        );
      } else {
        // timer is running
        int elapsedSeconds = 0;
        for (MatchTimeBloc m in matchTimes) {
          if (m.endTime != null) {
            elapsedSeconds +=
                (m.endTime?.difference(m.startTime).inSeconds ?? 0);
          } else {
            elapsedSeconds += DateTime.now().difference(m.startTime).inSeconds;
          }
        }
        matchTimeStatus = MatchTimeStatus(
          elapsedSeconds: elapsedSeconds,
          isRunning: true,
        );
      }

      return matchTimeStatus;
    } catch (e) {
      return MatchTimeStatus(elapsedSeconds: 0, isRunning: false);
    }
  }

  static DateTime? findInitialTime({required MatchPeriod? matchPeriod}) {
    try {
      List<MatchTimeBloc> matches = matchPeriod?.intervals ?? [];

      DateTime? earliestStartTime =
          matches.isNotEmpty
              ? matches
                  .map((m) => m.startTime)
                  .reduce((a, b) => a.isBefore(b) ? a : b)
              : null;
      return earliestStartTime;
    } catch (e) {}
    return null;
  }

  static Duration findInitialExtraTime({required MatchPeriod matchPeriod}) {
    // Assumes matchPeriod.extraTime is NOT null when this is called
    Duration initialTime = matchPeriod.extraTime.presetDuration; // Get preset
    Duration elapsedDuration = Duration.zero; // Accumulator for elapsed time
    final DateTime now = DateTime.now(); // Get current time once

    try {
      // Assumes matchPeriod.extraTime.intervals exists
      List<MatchTimeBloc> matches = matchPeriod.extraTime.intervals;

      // Loop through intervals in the extraTime object
      for (var t in matches) {
        Duration intervalDuration;
        if (t.endTime != null) {
          // Completed interval: Calculate duration
          intervalDuration = t.endTime!.difference(t.startTime);
        } else {
          // Running interval: Calculate duration from start until now
          intervalDuration = now.difference(t.startTime);
        }

        // Add the interval's duration to the total elapsed time
        // Add a basic check to avoid adding negative durations from clock issues
        if (!intervalDuration.isNegative) {
          elapsedDuration += intervalDuration;
        }
      }
    } catch (e) {
      // Catch potential errors during calculation (e.g., null access if assumptions fail)
      print("Error calculating extra time elapsed duration: $e");
      // Return the original initialTime on error? Or zero? Returning initialTime for now.
      return initialTime;
    }

    // Return the initial preset duration minus the calculated elapsed duration.
    // Note: This result *could* be negative if the timer ran past the preset duration.
    return initialTime - elapsedDuration;
  }

  static MatchPeriod? checkAnyTimerRunning({FootballMatch? match}) {
    try {
      List<MatchPeriod> periods = match!.matchPeriod;
      periods =
          periods
              .where(
                (p) =>
                    p.extraPeriodStatus == TimeActiveStatus.RUNNING ||
                    p.upPeriodStatus == TimeActiveStatus.RUNNING,
              )
              .toList();
      return periods.firstOrNull;
    } catch (e) {}
    return null;
  }
}
