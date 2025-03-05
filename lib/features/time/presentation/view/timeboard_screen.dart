import 'package:flutter/src/widgets/framework.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/time/presentation/view/responsive/timeboard_screen_tablet.dart';

class TimeboardScreen extends ResponsiveScreen{
  @override
  Widget buildDesktop(BuildContext context) {
    return TimeboardScreenTablet();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return TimeboardScreenTablet();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return TimeboardScreenTablet();
  }

  @override
  _TimeboardScreenState createState()=> _TimeboardScreenState();

}

class _TimeboardScreenState extends ResponsiveScreenState<TimeboardScreen>{

}