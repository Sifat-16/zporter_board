import 'package:flutter/src/widgets/framework.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/substitute/presentation/view/responsive/substituteboard_screen_tablet.dart';
import 'package:zporter_board/features/tactic/presentation/view/responsive/tacticboard_screen_tablet.dart';
import 'package:zporter_board/features/time/presentation/view/responsive/timeboard_screen_tablet.dart';

class TacticboardScreen extends ResponsiveScreen{
  @override
  Widget buildDesktop(BuildContext context) {
    return TacticboardScreenTablet();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return TacticboardScreenTablet();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return TacticboardScreenTablet();
  }

  @override
  _TacticboardScreenState createState()=> _TacticboardScreenState();

}

class _TacticboardScreenState extends ResponsiveScreenState<TacticboardScreen>{

}