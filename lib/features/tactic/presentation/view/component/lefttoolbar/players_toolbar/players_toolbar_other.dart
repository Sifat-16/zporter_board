import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/core/utils/player/player_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_state.dart';

class PlayersToolbarOther extends StatefulWidget {
  const PlayersToolbarOther({super.key});

  @override
  State<PlayersToolbarOther> createState() => _PlayersToolbarOtherState();
}

class _PlayersToolbarOtherState extends State<PlayersToolbarOther> {
   List<PlayerModel> players=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TacticalBloc>().add(TacticalBoardLoadPlayerTypeEvent(playerType: PlayerType.OTHER));
  }

  initiatePlayers(List<PlayerModel> other){
    setState(() {
      players = other;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TacticalBloc, TacticalState>(
      listener: (BuildContext context, TacticalState state) {
        if(state is TacticalBoardLoadedState){
          initiatePlayers(state.other);
        }
        if(state is TacticalBoardLoadedOtherPlayerState){
          initiatePlayers(state.other);
        }

        if(state is TacticalBoardPlayerAddToPlayingSuccessState){
          initiatePlayers(state.other);
        }
      },
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 3,
          children: [
            ...List.generate(players.length, (index){
              PlayerModel player = players[index];
              return PlayerComponent(playerDataModel: player);
            })
          ],
        );
      },
    );
  }
}
