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
}
