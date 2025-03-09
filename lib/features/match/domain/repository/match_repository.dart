import 'package:zporter_board/features/match/data/model/football_match.dart';

abstract class MatchRepository{
  Future<List<FootballMatch>> getAllMatches();
}