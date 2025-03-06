import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';

class PlayerComponent extends StatefulWidget {
  const PlayerComponent({super.key, required this.playerDataModel});

  final PlayerModel playerDataModel;

  @override
  State<PlayerComponent> createState() => _PlayerComponentState();
}




class _PlayerComponentState extends State<PlayerComponent> {
  @override
  Widget build(BuildContext context) {

    return Draggable<PlayerModel>(
        data: widget.playerDataModel,
        childWhenDragging: Opacity(
            opacity: 0.5,
            child: _buildPlayerComponent(playerDataModel: widget.playerDataModel)
        ),

        feedback: Material(
            color: Colors.transparent,
            child: _buildPlayerComponent(playerDataModel: widget.playerDataModel)
        ),
        child: _buildPlayerComponent(playerDataModel: widget.playerDataModel)
    );

  }

  _buildPlayerComponent({required PlayerModel playerDataModel}){

    return RepaintBoundary(
      key: UniqueKey(),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppSize.s8),
          decoration: BoxDecoration(
            color: widget.playerDataModel.playerType==PlayerType.HOME? ColorManager.blueAccent:ColorManager.red,
            borderRadius: BorderRadius.circular(AppSize.s4),
          ),
          child: SizedBox(
            height: AppSize.s32,
            width: AppSize.s32,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.playerDataModel.role,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "${widget.playerDataModel.index}",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: ColorManager.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );


  }
}
