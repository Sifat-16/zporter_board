import 'package:flutter/src/widgets/framework.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/tacticV2/presentation/view/responsive/tacticboard_screen_tablet_v3.dart';

class TacticboardScreenV2 extends ResponsiveScreen {
  const TacticboardScreenV2({super.key});

  @override
  Widget buildDesktop(BuildContext context) {
    return TacticboardScreenTabletV3();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return TacticboardScreenTabletV3();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return TacticboardScreenTabletV3();
  }

  @override
  _TacticboardScreenV2State createState() => _TacticboardScreenV2State();
}

class _TacticboardScreenV2State
    extends ResponsiveScreenState<TacticboardScreenV2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTacticalBoard();
  }

  _loadTacticalBoard() {
    // List<PlayerModel> home = PlayerUtils.generatePlayerModelList(playerType: PlayerType.HOME);
    // List<PlayerModel> other = [];
    // List<PlayerModel> away = PlayerUtils.generatePlayerModelList(playerType: PlayerType.AWAY);
    // List<PlayerModel> playing = [];
    // context.read<PlayerBloc>().add(PlayerLoadEvent(away: away, home: home, other: other, playing: playing));
    // try{
    //   context.read<AnimationBloc>().add(LoadAnimationEvent());
    //
    // }catch(e){
    //   debug(data: "Animation fetch error ${e}");
    //
    // }
  }
}
