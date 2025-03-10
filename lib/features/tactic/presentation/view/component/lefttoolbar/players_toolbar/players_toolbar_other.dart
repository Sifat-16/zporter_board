import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

class PlayersToolbarOther extends StatefulWidget {
  const PlayersToolbarOther({super.key});

  @override
  State<PlayersToolbarOther> createState() => _PlayersToolbarOtherState();
}

class _PlayersToolbarOtherState extends State<PlayersToolbarOther> with AutomaticKeepAliveClientMixin {
   List<PlayerModel> players=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PlayerBloc>().add(PlayerTypeLoadEvent(playerType: PlayerType.OTHER));
  }

  initiatePlayers(List<PlayerModel> other){
    setState(() {
      players = other;
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
      listener: (BuildContext context, PlayerState state) {
        if(state is PlayerLoadedState){
          initiatePlayers(state.other);
        }
        if(state is OtherPlayerLoadedState){
          initiatePlayers(state.other);
        }

        if(state is PlayerAddToPlayingSuccessState){
          if(state.playerModel.playerType==PlayerType.OTHER){
            removePlayer(state.playerModel);
          }
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
