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
      param.footballMatch = startTime(footBallMatch: param.footballMatch);
    } else {
      param.footballMatch = stopTime(footBallMatch: param.footballMatch);
    }

    return await matchRepository.updateMatchTime(param);
  }

  FootballMatch startTime({required FootballMatch footBallMatch}) {
    // create new match time object with start time - Date now , end time - null, nextId - null
    // Iterate through match times and connect the id to null next id
    // if already time is running and again the users taps start through exception
    List<MatchTime> times = footBallMatch.matchTime;
    int alreadyRunningTimeIndex = times.indexWhere((t) => t.endTime == null);
    if (alreadyRunningTimeIndex != -1) {
      throw Exception("Timer already running");
    }
    MatchTime matchTime = MatchTime(
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
    footBallMatch.matchTime = times;
    return footBallMatch;
  }

  FootballMatch stopTime({required FootballMatch footBallMatch}) {
    // Look for end time null object which is considered running and set to date - now
    // if not found throw can't be stop cause already stopped
    List<MatchTime> times = footBallMatch.matchTime;
    int alreadyRunningTimeIndex = times.indexWhere((t) => t.endTime == null);
    if (alreadyRunningTimeIndex == -1) {
      throw Exception("Timer already stopped");
    }

    times[alreadyRunningTimeIndex].endTime = DateTime.now();
    footBallMatch.matchTime = times;
    return footBallMatch;
  }
}
