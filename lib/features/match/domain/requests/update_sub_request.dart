import 'package:zporter_board/features/substitute/data/model/substitution.dart';

class UpdateSubRequest {
  String matchId;
  MatchSubstitutions matchSubstitutions;
  UpdateSubRequest({required this.matchId, required this.matchSubstitutions});
}
