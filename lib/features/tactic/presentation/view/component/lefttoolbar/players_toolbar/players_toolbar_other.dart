import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/core/utils/player/player_utils.dart';

class PlayersToolbarOther extends StatefulWidget {
  const PlayersToolbarOther({super.key});

  @override
  State<PlayersToolbarOther> createState() => _PlayersToolbarOtherState();
}

class _PlayersToolbarOtherState extends State<PlayersToolbarOther> {
  late List<PlayerDataModel> players;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiatePlayers();
  }

  initiatePlayers(){

    setState(() {
      players = PlayerUtils.generatePlayerModelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            ...List.generate(players.length, (index){
              PlayerDataModel player = players[index];
              return Center(
                child: Container(
                  padding: EdgeInsets.all(AppSize.s8),
                  decoration: BoxDecoration(
                      color: ColorManager.blueAccent,
                      borderRadius: BorderRadius.circular(AppSize.s4)
                  ),
                  child: Container(
                      height: AppSize.s32,
                      width: AppSize.s32,
                      child: Stack(

                        children: [
                          Center(child: Text(player.type, style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: ColorManager.white,
                              fontWeight: FontWeight.bold
                          ),)),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text("${index+1}", style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                  color: ColorManager.white
                              ),)
                          )
                        ],
                      )
                  ),
                ),
              );
            })
          ],
        )
    );
  }
}
