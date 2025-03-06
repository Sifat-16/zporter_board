import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/button/custom_button.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_config.dart';

import 'field_painter.dart';

class FieldComponent extends StatefulWidget {
  const FieldComponent({super.key});

  @override
  State<FieldComponent> createState() => _FieldComponentState();
}

class _FieldComponentState extends State<FieldComponent> {

  double rotationAngle = pi/2; // Stores rotation in radians (0, pi/2, pi, 3*pi/2)

  List<PlayerDataModel> playerPositions = []; // To store positions of players on the field

  final GlobalKey _containerKey = GlobalKey();


  // Function to rotate coordinates (x, y) based on the rotation angle
  Offset rotateOffset(Offset originalOffset, double angle, Size fieldSize) {
    // Translate coordinates to center
    double centerX = fieldSize.width / 2;
    double centerY = fieldSize.height / 2;

    double x = originalOffset.dx - centerX;
    double y = originalOffset.dy - centerY;

    // Apply the rotation transformation
    double rotatedX = x * cos(angle) - y * sin(angle);
    double rotatedY = x * sin(angle) + y * cos(angle);

    // Translate back to the original coordinates
    rotatedX += centerX;
    rotatedY += centerY;

    return Offset(rotatedX, rotatedY);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DragTarget<PlayerDataModel>(
              onAcceptWithDetails: (player) {
                setState(() {
                  final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
                  if(renderBox!=null){
                    // Get the global offset of the drop
                    final globalOffset = player.offset;

                    // Convert the global offset to the container's local offset
                    final localOffset = renderBox.globalToLocal(globalOffset);
                    debug(data: "The data dragged and drop into ${player.data.type} - ${localOffset}");
                    // final rotatedOffset = rotateOffset(player.offset, rotationAngle, Size(context.screenHeight * .8, context.screenHeight * .9));
                    // player.data.offset = rotatedOffset;
                    // You can add the drop position dynamically (example below)
                    player.data.offset = localOffset;
                    playerPositions.add(player.data); // Example position on drop

                  }



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
                        border: Border.all(color: isDraggingOver?ColorManager.red:ColorManager.transparent)
                      ),
                      child: CustomPaint(
                        size: Size(context.screenHeight * .8, context.screenHeight * .9),
                        painter: FieldPainter(config: defaultFieldConfig, players: playerPositions, isDraggingOver: isDraggingOver), // Existing FieldPainter
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
                  child: Text("Delete", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold
                  ),),
                  borderColor: ColorManager.red,
                  fillColor: ColorManager.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,
                ),

                CustomButton(
                  child: Text("Save to animation", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold
                  ),),
                  fillColor: ColorManager.grey,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,

                ),

                CustomButton(
                  child: Text("Save", style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold
                  ),),
                  fillColor: ColorManager.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,

                ),



              ],
            ),
          ),

        ],
      ),
    );
  }
}

