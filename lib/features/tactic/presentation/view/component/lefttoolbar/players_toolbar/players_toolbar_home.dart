import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class PlayersToolbarHome extends StatefulWidget {
  const PlayersToolbarHome({super.key});

  @override
  State<PlayersToolbarHome> createState() => _PlayersToolbarHomeState();
}

class _PlayersToolbarHomeState extends State<PlayersToolbarHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
          crossAxisCount: 3,
          children: [
            ...List.generate(24, (index){
              return Center(
                child: Container(
                  padding: EdgeInsets.all(AppSize.s8),
                  decoration: BoxDecoration(
                    color: ColorManager.blueAccent,
                    borderRadius: BorderRadius.circular(AppSize.s4)
                  ),
                  child: Text("GK"),
                ),
              );
            })
          ],
      )
    );
  }


}
