import 'package:flutter/src/widgets/framework.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/substitute/presentation/view/responsive/substituteboard_screen_tablet.dart';
import 'package:zporter_board/features/time/presentation/view/responsive/timeboard_screen_tablet.dart';

class SubstituteboardScreen extends ResponsiveScreen{
  @override
  Widget buildDesktop(BuildContext context) {
    return SubstituteboardScreenTablet();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return SubstituteboardScreenTablet();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return SubstituteboardScreenTablet();
  }

  @override
  _SubstituteboardScreenState createState()=> _SubstituteboardScreenState();

}

class _SubstituteboardScreenState extends ResponsiveScreenState<SubstituteboardScreen>{

}