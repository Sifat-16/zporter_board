import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_config.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_item_component.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_painter.dart';

class AnimationPlayComponent extends StatefulWidget {
  const AnimationPlayComponent({super.key, required this.animations});
  final List<AnimationModel> animations;

  @override
  State<AnimationPlayComponent> createState() => _AnimationPlayComponentState();
}

class _AnimationPlayComponentState extends State<AnimationPlayComponent>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  List<List<FieldDraggableItem>> itemsToAnimate = [];
  int index = 0;
  int _countdown = 3;
  bool _showCountdown = true;
  int _activeAnimations = 0; // Track active animations

  @override
  void initState() {
    super.initState();
    itemsToAnimate = widget.animations.map((e) => e.items).toList();


    // Start countdown
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _showCountdown = false;
        });
        _startAnimation();
      }
    });
  }

  void _startAnimation() {
    if (index >= itemsToAnimate.length) return; // Stop if no more animations

    List<FieldDraggableItem> itemPosition = itemsToAnimate[index];
    _activeAnimations = itemPosition.length; // Set active animations count

    for (final item in itemPosition) {
      if (item is ArrowHead) {
        _animateItemToArrowHead(item.parent, item.offset!);
      }
    }
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
        List<FieldDraggableItem> itemPosition = itemsToAnimate[index];
        int parentIndex = itemPosition.indexWhere((e)=>e.id==parent.id);
        itemPosition[parentIndex].offset = animation.value;
        parent.offset = animation.value;
      });
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the controller after animation completion
        animationController.dispose();
        debug(data: "Animation complete");
        _handleAnimationComplete();
      }
    });

    // Start the animation
    animationController.forward();
  }

  void _handleAnimationComplete() {
    if (index < itemsToAnimate.length - 1) {
      setState(() {
        index++; // Move to the next animation set
      });
      _startAnimation(); // Start the next animation
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (context) {
        List<FieldDraggableItem> itemPosition = itemsToAnimate[index];
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                        angle: pi / 2,
                        child: Container(
                          key: _containerKey,
                          padding: EdgeInsets.all(1),
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
                                  child: FieldItemComponent(fieldDraggableItem: item, activateFocus: true),
                                );
                              }),
                            ],
                          ),
                        )

                  ),





                  // Countdown Timer in the Center
                  if (_showCountdown)
                    Container(
                      child: Center(
                        child: Text(
                          '$_countdown',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            ],
          ),
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}
