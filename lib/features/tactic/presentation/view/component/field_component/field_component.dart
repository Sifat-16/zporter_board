import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/button/custom_button.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_config.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/tactical_state.dart';

import 'field_painter.dart';

class FieldComponent extends StatefulWidget {
  const FieldComponent({super.key});

  @override
  State<FieldComponent> createState() => _FieldComponentState();
}

class _FieldComponentState extends State<FieldComponent> {

  double rotationAngle = pi/2; // Stores rotation in radians (0, pi/2, pi, 3*pi/2)

  List<PlayerModel> playerPositions = []; // To store positions of players on the field
  final GlobalKey _containerKey = GlobalKey();
  // Track hover position for shadow
  Offset? hoverOffset;
  PlayerModel? hoveringPlayer;

  _updatePlayer(List<PlayerModel> player){

    setState(() {
      playerPositions = player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TacticalBloc, TacticalState>(
      listener: (BuildContext context, TacticalState state) {
        if(state is TacticalBoardPlayerAddToPlayingSuccessState){

          _updatePlayer(state.playing);
        }
      },
      builder: (context, state) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DragTarget<PlayerModel>(
                  onAcceptWithDetails: (player) {
                    setState(() {
                      final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
                      if (renderBox != null) {
                        player.data.offset = hoverOffset;
                        // playerPositions.add(player.data);
                        hoverOffset = null; // Remove shadow after drop
                        context.read<TacticalBloc>().add(TacticalBoardPlayerAddToPlayingEvent(playerModel: player.data));
                      }
                    });
                  },
                  onMove: (details) {
                    setState(() {
                      final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
                      if (renderBox != null) {
                        hoverOffset = renderBox.globalToLocal(details.offset);
                        if(rotationAngle!=0){
                          Offset updatedOffset = Offset(hoverOffset!.dx, hoverOffset!.dy-50);
                          hoverOffset = updatedOffset;
                        }
                        hoveringPlayer = details.data;
                      }
                    });
                  },
                  onLeave: (data) {
                    setState(() {
                      hoverOffset = null; // Remove shadow when dragging leaves
                      hoveringPlayer = null;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    bool isDraggingOver = candidateData.isNotEmpty;

                    return Container(
                      child: Transform.rotate(
                        angle: rotationAngle,
                        child: Container(
                          key: _containerKey,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDraggingOver ? ColorManager.red : ColorManager.transparent,
                            ),
                          ),
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: Size(context.screenHeight * .8, context.screenHeight * .9),
                                painter: FieldPainter(config: defaultFieldConfig),
                              ),

                              // Render existing players
                              ...playerPositions.map((player) {
                                return Positioned(
                                  left: player.offset?.dx,
                                  top: player.offset?.dy,
                                  child: PlayerComponent(playerDataModel: player),
                                );
                              }),

                              // Render hover shadow if dragging
                              if (hoverOffset != null)
                                if(hoveringPlayer!=null)
                                  Positioned(
                                    left: hoverOffset!.dx,
                                    top: hoverOffset!.dy,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: PlayerComponent(playerDataModel: hoveringPlayer!), // Dummy player for shadow
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                _buildFieldToolbar(),
                PaginationComponent(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldToolbar(){
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Flexible(
            flex:1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.fullscreen_rounded, color: ColorManager.white,)),
                IconButton(onPressed: (){
                  setState(() {
                    if(rotationAngle==pi/2){
                      rotationAngle=0;
                    }else{
                      rotationAngle=pi/2;
                    }

                  });
                }, icon: Icon(Icons.rotate_left, color: ColorManager.white,)),
                IconButton(onPressed: (){

                }, icon: Icon(Icons.threed_rotation, color: ColorManager.white,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.share, color: ColorManager.white,)),

              ],
            ),
          ),

          SizedBox(
            width: AppSize.s32,
          ),


          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  borderColor: ColorManager.red,
                  fillColor: ColorManager.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,
                  child: Text("Delete", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold
                  ),),
                ),

                CustomButton(
                  fillColor: ColorManager.grey,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,
                  child: Text("Save to animation", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold
                  ),),

                ),

                CustomButton(
                  fillColor: ColorManager.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,
                  child: Text("Save", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold
                  ),),

                ),



              ],
            ),
          ),

        ],
      ),
    );
  }
}

