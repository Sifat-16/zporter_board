import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';
import 'package:zporter_board/features/tacticV2/presentation/view/component/playerV2/player_component_v2.dart';
import 'package:zporter_board/features/tacticV2/presentation/view/component/playerV2/player_model_v2.dart';
import 'package:zporter_board/features/tacticV2/presentation/view/component/playerV2/player_utils_v2.dart';

class PlayersToolbarHomeV2 extends StatefulWidget {
  const PlayersToolbarHomeV2({super.key});

  @override
  State<PlayersToolbarHomeV2> createState() => _PlayersToolbarHomeV2State();
}

class _PlayersToolbarHomeV2State extends State<PlayersToolbarHomeV2> with AutomaticKeepAliveClientMixin {
  List<PlayerModelV2> players=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiatePlayerLocally();
    // context.read<PlayerBloc>().add(PlayerTypeLoadEvent(playerType: PlayerType.HOME));
  }

  initiatePlayerLocally(){
    WidgetsBinding.instance.addPostFrameCallback((t){
      setState(() {
        players = PlayerUtilsV2.generatePlayerModelList(playerType: PlayerType.HOME);
      });
    });

  }

  initiatePlayers(List<PlayerModelV2> home){
    setState(() {
      players = home;
    });
  }

  removePlayer(PlayerModel player){
    setState(() {
      players.removeWhere((p)=>p.id==player.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<PlayerBloc, PlayerState>(
      buildWhen: (previous, current) => current is PlayerAddToPlayingSuccessState ,
      listener: (BuildContext context, state) {
        // if(state is PlayerLoadedState){
        //   initiatePlayers(state.home);
        // }
        //
        // if(state is HomePlayerLoadedState){
        //   initiatePlayers(state.home);
        // }
        //
        // if(state is PlayerAddToPlayingSuccessState){
        //   if(state.playerModel.playerType==PlayerType.HOME){
        //     removePlayer(state.playerModel);
        //   }
        // }
      },
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 3,
          children: [
            ...List.generate(players.length, (index) {
              PlayerModelV2 player = players[index];
              return PlayerComponentV2(playerModelV2: player);
            })
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;




}
