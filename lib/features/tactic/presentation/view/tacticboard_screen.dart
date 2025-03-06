import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/core/utils/player/player_utils.dart';
import 'package:zporter_board/features/substitute/presentation/view/responsive/substituteboard_screen_tablet.dart';
import 'package:zporter_board/features/tactic/presentation/view/responsive/tacticboard_screen_tablet.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_event.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTacticalBoard();
  }

  _loadTacticalBoard(){
    List<PlayerModel> home = PlayerUtils.generatePlayerModelList(playerType: PlayerType.HOME);
    List<PlayerModel> other = [];
    List<PlayerModel> away = PlayerUtils.generatePlayerModelList(playerType: PlayerType.AWAY);
    List<PlayerModel> playing = [];
    context.read<TacticalBloc>().add(TacticalBoardLoadEvent(away: away, home: home, other: other, playing: playing));
  }

}