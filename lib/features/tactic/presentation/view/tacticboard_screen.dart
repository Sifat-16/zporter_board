import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_utils.dart';
import 'package:zporter_board/features/substitute/presentation/view/responsive/substituteboard_screen_tablet.dart';
import 'package:zporter_board/features/tactic/presentation/view/responsive/tacticboard_screen_tablet.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/time/presentation/view/responsive/timeboard_screen_tablet.dart';

import '../../data/model/PlayerDataModel.dart';

class TacticboardScreen extends ResponsiveScreen{
  const TacticboardScreen({super.key});

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
    context.read<PlayerBloc>().add(PlayerLoadEvent(away: away, home: home, other: other, playing: playing));
    try{
      context.read<AnimationBloc>().add(LoadAnimationEvent());

    }catch(e){
      debug(data: "Animation fetch error ${e}");

    }
  }

}