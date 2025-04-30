import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_tactical_board/app/generator/random_generator.dart';

class UpdateMatchTimeUsecase
    extends UseCase<FootballMatch, UpdateMatchTimeRequest> {
  MatchRepository matchRepository;

  UpdateMatchTimeUsecase({required this.matchRepository});

  @override
  Future<FootballMatch> call(param) async {
    if (param.matchTimeUpdateStatus == MatchTimeUpdateStatus.START) {
      param.footballMatch = startTime(
        footBallMatch: param.footballMatch,
        matchPeriodId: param.matchPeriodId,
      );
    } else {
      param.footballMatch = stopTime(
        footBallMatch: param.footballMatch,
        matchPeriodId: param.matchPeriodId,
      );
    }

    return await matchRepository.updateMatchTime(param);
  }

  FootballMatch startTime({
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
    return footBallMatch;
  }

  FootballMatch stopTime({
    required FootballMatch footBallMatch,
    required int matchPeriodId,
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
    return footBallMatch;
  }
}
