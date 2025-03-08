import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:zporter_board/core/common/components/button/custom_button.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/random/random_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/animation/animation_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/animation/animation_play_component.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_config.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_item_component.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_state.dart' as fs;
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

import 'field_painter.dart';

List<AnimationModel> globalAnimations = [];

class FieldComponent extends StatefulWidget {
  const FieldComponent({super.key});

  @override
  State<FieldComponent> createState() => _FieldComponentState();
}

class _FieldComponentState extends State<FieldComponent> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  double rotationAngle = pi/2; // Stores rotation in radians (0, pi/2, pi, 3*pi/2)

  List<FieldDraggableItem> itemPosition = []; // To store positions of players on the field
  final GlobalKey _containerKey = GlobalKey();
  // Track hover position for shadow
  Offset? hoverOffset;
  FieldDraggableItem? hoveringItem;

  AnimationController? _animationController;
  Animation<Offset>? _animation;
  FieldDraggableItem? _animatedItem;
  Offset? _targetOffset;

  // Track hover position for Equipment


  _addItem(FieldDraggableItem item){
    setState(() {
      itemPosition.add(item);
    });
  }


  void _animateItemToArrowHead(FieldDraggableItem parent, Offset targetOffset, {Duration? duration}) {
    // Create a new AnimationController for each ArrowHead
    final AnimationController animationController = AnimationController(
      duration: duration?? Duration(seconds: 2),
      vsync: this,
    );

    // Declare and initialize the animation after the controller
    final Animation<Offset> animation = Tween<Offset>(
      begin: parent.offset ?? Offset.zero,
      end: targetOffset,
    ).animate(animationController);

    // Add listeners to update position and handle the animation lifecycle
    animation.addListener(() {
      setState(() {
        parent.offset = animation.value;
      });
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the controller after animation completion
        animationController.dispose();
      }
    });

    // Start the animation
    animationController.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<PlayerBloc, PlayerState>(
            listener: (BuildContext context, PlayerState state) {
                  if(state is PlayerAddToPlayingSuccessState){
                    _addItem(state.playerModel);
                  }
        }),

        BlocListener<EquipmentBloc, EquipmentState>(
            listener: (BuildContext context, EquipmentState state) {
              if(state is EquipmentAddedToFieldState){
                _addItem(state.equipment);
              }
            }),

        BlocListener<FormBloc, fs.FormState>(
            listener: (BuildContext context, fs.FormState state) {
              if(state is fs.FormAddedToFieldState){
                _addItem(state.formDataModel);
              }
              if(state is fs.ArrowAddedToFieldState){
                _addItem(state.arrowHead);
              }
            }),

        BlocListener<AnimationBloc, AnimationState>(
            listener: (BuildContext context, AnimationState state) {
              if(state is AnimationSavedState){
                for(var item in itemPosition){
                  if(item is ArrowHead){
                    try{
                      _animateItemToArrowHead(item.parent, item.offset!, duration: Duration(milliseconds: 100));
                    }catch(e){
                    }
                  }
                }
              }

              if(state is PlayAnimationState){
                _playAnimation(state.animations);
              }
            }),


      ],
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DragTarget<FieldDraggableItem>(
                onAcceptWithDetails: (item) {
                  FieldDraggableItem dragItem = item.data;
                  setState(() {
                    final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      dragItem.offset = hoverOffset;
                      // playerPositions.add(player.data);
                      hoverOffset = null; // Remove shadow after drop

                      if(dragItem is PlayerModel){
                        context.read<PlayerBloc>().add(PlayerAddToPlayingEvent(playerModel: dragItem));
                      }else if(dragItem is EquipmentDataModel){
                        EquipmentDataModel eq = dragItem;
                        eq.id = RandomUtils.randomString();
                        context.read<EquipmentBloc>().add(EquipmentAddToFieldEvent(equipmentDataModel: eq));
                      }else if(dragItem is FormDataModel){
                        FormDataModel fr = dragItem;
                        fr.id = RandomUtils.randomString();
                        context.read<FormBloc>().add(FormAddToFieldEvent(formDataModel: fr));
                      }else if(dragItem is ArrowHead){
                        context.read<FormBloc>().add(ArrowHeadAddEvent(arrowHead: dragItem));

                      }
                    }
                  });
                },
                onMove: (details) {
                  FieldDraggableItem dragItem = details.data;
                  setState(() {
                    final renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      hoverOffset = renderBox.globalToLocal(details.offset);
                      if(rotationAngle!=0){
                        Offset updatedOffset = Offset(hoverOffset!.dx, hoverOffset!.dy-50);
                        hoverOffset = updatedOffset;
                      }
                      hoveringItem = dragItem;
                      debug(data: "Hovering item type ${hoveringItem.runtimeType}");
                    }
                  });
                },
                onLeave: (data) {
                  setState(() {
                    hoverOffset = null; // Remove shadow when dragging leaves
                    hoveringItem = null;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  bool isDraggingOver = candidateData.isNotEmpty;

                  // return _drawingBoard();

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
                              painter: FieldPainter(config: defaultFieldConfig, items: itemPosition),
                            ),

                            // Render existing players
                            ...itemPosition.map((item) {
                              return Positioned(
                                left: item.offset?.dx,
                                top: item.offset?.dy,
                                child: FieldItemComponent(fieldDraggableItem: item, activateFocus: true,),
                              );
                            }),

                            // Render hover shadow if dragging
                            if (hoverOffset != null)
                              if(hoveringItem!=null)
                                if(hoveringItem is FormDataModel)
                                  SizedBox.shrink()
                                else
                                  Positioned(
                                    left: hoverOffset!.dx,
                                    top: hoverOffset!.dy,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child:  FieldItemComponent(fieldDraggableItem: hoveringItem!), // Dummy player for shadow
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // CustomButton(
              //   fillColor: ColorManager.blue,
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   borderRadius: 3,
              //   child: Text("Animate", style: Theme.of(context).textTheme.labelLarge!.copyWith(
              //       color: ColorManager.white,
              //       fontWeight: FontWeight.bold
              //   ),),
              //   onTap: () {
              //     // Find an ArrowHead and its parent
              //     for (final item in itemPosition) {
              //       if (item is ArrowHead) {
              //         _animateItemToArrowHead(item.parent, item.offset!);
              //       }
              //     }
              //   },
              // ),



              _buildFieldToolbar(),
              PaginationComponent(),
            ],
          ),
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
                  onTap: (){
                    List<FieldDraggableItem> copiedItems = itemPosition.map(
                            (e){
                              if(e is ArrowHead){
                                return e.copyWith(parent: e.parent.copyWith());
                              }
                              return e.copyWith();
                            }
                    ).toList();
                    AnimationModel animationModel = AnimationModel(id: RandomUtils.randomString(), items: copiedItems, index: -1);
                    globalAnimations.add(animationModel);
                    context.read<AnimationBloc>().add(AnimationSaveEvent(animationModel: animationModel));
                  },
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

                CustomButton(
                  onTap: (){
                    context.read<AnimationBloc>().add(PlayAnimationEvent());
                  },
                  fillColor: ColorManager.green,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  borderRadius: 3,
                  child: Text("Play", style: Theme.of(context).textTheme.labelLarge!.copyWith(
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  /// Flutter drawing board

  void _playAnimation(List<AnimationModel> animations){
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, __, ___) {
        return Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: AnimationPlayComponent(animations: globalAnimations),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Dismiss'),
            ),
          ],
        );
      },
    );
  }
}

