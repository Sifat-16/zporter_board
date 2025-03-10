import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/auth/presentation/view/responsive/auth_screen_tablet.dart';
import 'package:zporter_board/features/board/presentation/view/responsive/board_screen_desktop.dart';
import 'package:zporter_board/features/board/presentation/view/responsive/board_screen_mobile.dart';
import 'package:zporter_board/features/board/presentation/view/responsive/board_screen_tablet.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';

class BoardScreen extends ResponsiveScreen{
  const BoardScreen({super.key});

  @override
  Widget buildDesktop(BuildContext context) {
    return BoardScreenTablet();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return BoardScreenTablet();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return BoardScreenTablet();
  }

  @override
  _BoardScreenState createState() => _BoardScreenState();

}

class _BoardScreenState extends ResponsiveScreenState<BoardScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MatchBloc>().add(MatchLoadEvent());
  }

}