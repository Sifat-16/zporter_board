import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class CreatePeriodUseCase extends UseCase<MatchPeriod, MatchPeriod> {
  MatchRepository matchRepository;

  CreatePeriodUseCase({required this.matchRepository});

  @override
  Future<MatchPeriod> call(param) async {
    MatchPeriod matchPeriod = await matchRepository.createNewPeriod(
      matchPeriod: param,
    );
    return matchPeriod;
  }
}
