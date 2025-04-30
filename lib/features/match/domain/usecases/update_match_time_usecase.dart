import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_tactical_board/app/generator/random_generator.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class UpdateMatchTimeUsecase
    extends UseCase<FootballMatch, UpdateMatchTimeRequest> {
  MatchRepository matchRepository;

  UpdateMatchTimeUsecase({required this.matchRepository});

  @override
  Future<FootballMatch> call(param) async {
    if (param.timerMode == TimerMode.UP) {
      zlog(data: "Came to timer mode in usecase up");
      if (param.matchTimeUpdateStatus == MatchTimeUpdateStatus.START) {
        param.footballMatch = startUpTime(
          footBallMatch: param.footballMatch,
          matchPeriodId: param.matchPeriodId,
        );
      } else {
        param.footballMatch = stopUpTime(
          footBallMatch: param.footballMatch,
          matchPeriodId: param.matchPeriodId,
          updateStatus: param.matchTimeUpdateStatus,
        );
      }
    } else if (param.timerMode == TimerMode.EXTRA) {
      zlog(data: "Came to timer mode in usecase extra");
      if (param.matchTimeUpdateStatus == MatchTimeUpdateStatus.START) {
        param.footballMatch = startExtraTime(
          footBallMatch: param.footballMatch,
          matchPeriodId: param.matchPeriodId,
        );
      } else {
        param.footballMatch = stopExtraTime(
          footBallMatch: param.footballMatch,
          matchPeriodId: param.matchPeriodId,
          updateStatus: param.matchTimeUpdateStatus,
        );
      }
    }

    return await matchRepository.updateMatchTime(param);
  }

  FootballMatch startUpTime({
    required FootballMatch footBallMatch,
    required int matchPeriodId,
  }) {
    // create new match time object with start time - Date now , end time - null, nextId - null
    // Iterate through match times and connect the id to null next id
    // if already time is running and again the users taps start through exception
    int index = footBallMatch.matchPeriod.indexWhere(
      (t) => t.periodNumber == matchPeriodId,
    );
    List<MatchTimeBloc> times = footBallMatch.matchPeriod[index].intervals;

    int alreadyRunningTimeIndex = times.indexWhere((t) => t.endTime == null);
    if (alreadyRunningTimeIndex != -1) {
      throw Exception("Timer already running");
    }
    MatchTimeBloc matchTime = MatchTimeBloc(
      id: RandomGenerator.generateId(),
      startTime: DateTime.now(),
      endTime: null,
      nextId: null,
    );

    int lastStoppedTime = times.indexWhere((t) => t.nextId == null);

    if (lastStoppedTime != -1) {
      times[lastStoppedTime].nextId = matchTime.id;
    }
    times.add(matchTime);

    footBallMatch.matchPeriod[index].intervals = times;
    footBallMatch.matchPeriod[index].timerMode = TimerMode.UP;
    footBallMatch.matchPeriod[index].upPeriodStatus = TimeActiveStatus.RUNNING;
    return footBallMatch;
  }

  FootballMatch stopUpTime({
    required FootballMatch footBallMatch,
    required int matchPeriodId,
    required MatchTimeUpdateStatus updateStatus,
  }) {
    // Look for end time null object which is considered running and set to date - now
    // if not found throw can't be stop cause already stopped
    int index = footBallMatch.matchPeriod.indexWhere(
      (t) => t.periodNumber == matchPeriodId,
    );
    List<MatchTimeBloc> times = footBallMatch.matchPeriod[index].intervals;

    int alreadyRunningTimeIndex = times.indexWhere((t) => t.endTime == null);
    if (alreadyRunningTimeIndex == -1) {
      throw Exception("Timer already stopped");
    }

    times[alreadyRunningTimeIndex].endTime = DateTime.now();
    footBallMatch.matchPeriod[index].intervals = times;
    footBallMatch.matchPeriod[index].timerMode = TimerMode.UP;
    TimeActiveStatus status =
        updateStatus == MatchTimeUpdateStatus.PAUSE
            ? TimeActiveStatus.PAUSED
            : TimeActiveStatus.STOPPED;
    footBallMatch.matchPeriod[index].upPeriodStatus = status;

    return footBallMatch;
  }

  FootballMatch startExtraTime({
    required FootballMatch footBallMatch,
    required int matchPeriodId,
  }) {
    // create new match time object with start time - Date now , end time - null, nextId - null
    // Iterate through match times and connect the id to null next id
    // if already time is running and again the users taps start through exception
    int index = footBallMatch.matchPeriod.indexWhere(
      (t) => t.periodNumber == matchPeriodId,
    );
    MatchPeriod matchPeriod = footBallMatch.matchPeriod[index];
    ExtraTime extraTime = matchPeriod.extraTime;
    List<MatchTimeBloc> times = extraTime.intervals;

    int alreadyRunningTimeIndex = times.indexWhere((t) => t.endTime == null);
    if (alreadyRunningTimeIndex != -1) {
      throw Exception("Timer already running");
    }
    MatchTimeBloc matchTime = MatchTimeBloc(
      id: RandomGenerator.generateId(),
      startTime: DateTime.now(),
      endTime: null,
      nextId: null,
    );

    int lastStoppedTime = times.indexWhere((t) => t.nextId == null);

    if (lastStoppedTime != -1) {
      times[lastStoppedTime].nextId = matchTime.id;
    }
    times.add(matchTime);

    footBallMatch.matchPeriod[index].extraTime.intervals = times;
    footBallMatch.matchPeriod[index].timerMode = TimerMode.EXTRA;
    footBallMatch.matchPeriod[index].extraPeriodStatus =
        TimeActiveStatus.RUNNING;
    return footBallMatch;
  }

  FootballMatch stopExtraTime({
    required FootballMatch footBallMatch,
    required int matchPeriodId,
    required MatchTimeUpdateStatus updateStatus,
  }) {
    // Look for end time null object which is considered running and set to date - now
    // if not found throw can't be stop cause already stopped
    int index = footBallMatch.matchPeriod.indexWhere(
      (t) => t.periodNumber == matchPeriodId,
    );
    MatchPeriod matchPeriod = footBallMatch.matchPeriod[index];
    ExtraTime extraTime = matchPeriod.extraTime;
    List<MatchTimeBloc> times = extraTime.intervals;

    int alreadyRunningTimeIndex = times.indexWhere((t) => t.endTime == null);
    if (alreadyRunningTimeIndex == -1) {
      throw Exception("Timer already stopped");
    }

    times[alreadyRunningTimeIndex].endTime = DateTime.now();
    footBallMatch.matchPeriod[index].extraTime.intervals = times;
    footBallMatch.matchPeriod[index].timerMode = TimerMode.EXTRA;
    TimeActiveStatus status =
        updateStatus == MatchTimeUpdateStatus.PAUSE
            ? TimeActiveStatus.PAUSED
            : TimeActiveStatus.STOPPED;
    footBallMatch.matchPeriod[index].extraPeriodStatus = status;
    return footBallMatch;
  }
}
