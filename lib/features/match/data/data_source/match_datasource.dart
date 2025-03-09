import 'package:zporter_board/features/match/data/model/football_match.dart';

abstract class MatchDataSource{
  Future<List<FootballMatch>> getAllMatches();
}