import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/core/utils/player/player_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_state.dart';

class PlayersToolbarHome extends StatefulWidget {
  const PlayersToolbarHome({super.key});

  @override
  State<PlayersToolbarHome> createState() => _PlayersToolbarHomeState();
}

class _PlayersToolbarHomeState extends State<PlayersToolbarHome> {
  List<PlayerModel> players=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TacticalBloc>().add(TacticalBoardLoadPlayerTypeEvent(playerType: PlayerType.HOME));
  }

  initiatePlayers(List<PlayerModel> home){
    setState(() {
      players = home;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TacticalBloc, TacticalState>(
      buildWhen: (previous, current) => current is TacticalBoardPlayerAddToPlayingSuccessState ,
      listener: (BuildContext context, state) {
        if(state is TacticalBoardLoadedState){
          initiatePlayers(state.home);
        }

        if(state is TacticalBoardLoadedHomePlayerState){
          initiatePlayers(state.home);
        }

        if(state is TacticalBoardPlayerAddToPlayingSuccessState){
          debug(data: "Check home data ${state.home.length}");
          initiatePlayers(state.home);
        }
      },
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 3,
          children: [
            ...List.generate(players.length, (index) {
              PlayerModel player = players[index];
              return PlayerComponent(playerDataModel: player);
            })
          ],
        );
      },
    );
  }




}
