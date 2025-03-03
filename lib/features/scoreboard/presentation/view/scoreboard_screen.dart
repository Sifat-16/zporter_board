import 'package:flutter/src/widgets/framework.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/responsive/scoreboard_screen_tablet.dart';

class ScoreBoardScreen extends ResponsiveScreen{
  @override
  Widget buildDesktop(BuildContext context) {
    return ScoreboardScreenTablet();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return ScoreboardScreenTablet();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return ScoreboardScreenTablet();
  }

  @override
  _ScoreBoardScreenState createState()=> _ScoreBoardScreenState();

}

class _ScoreBoardScreenState extends ResponsiveScreenState<ScoreBoardScreen>{

}