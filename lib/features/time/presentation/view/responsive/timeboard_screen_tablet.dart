import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/helper/board_container_space_helper.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/time/presentation/view/component/score_component.dart';
import 'package:zporter_board/features/time/presentation/view/component/time_manager_component.dart';

class TimeboardScreenTablet extends StatefulWidget {
  const TimeboardScreenTablet({super.key});

  @override
  State<TimeboardScreenTablet> createState() => _TimeboardScreenTabletState();
}

class _TimeboardScreenTabletState extends State<TimeboardScreenTablet> {

  TimerController _timerController = TimerController();


  @override
  Widget build(BuildContext context) {
    return BoardContainer(
      child: Builder(
        builder: (context) {
          double height = getBoardHeightLeft(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height*.2,
                child: ScoreComponent(),
              ),
              Container(
                height: height*.4,
                width: context.widthPercent(90),

                child: TimerComponent(
                    startMinutes: 45,
                    startSeconds: 59,
                    letterSpacing: 20,
                    textSize: AppSize.s160,
                    textColor: ColorManager.white,
                  controller: _timerController,
                ),
              ),
              Container(
                height: height*.1,

                child: TimeManagerComponent(
                  onStart: _timerController.start,
                  onPause: _timerController.pause,
                  onStop: _timerController.stop,

                ),
              ),
              Container(
                height: height*.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex:1,
                        child: UpDownButtonWidget()
                    ),
                    Flexible(
                        flex: 1,
                        child: PaginationComponent()
                    ),
                    Flexible(
                        flex:1,
                        child: IconButton(onPressed: (){}, icon: Icon(Icons.delete))),
                  ],
                ),
              ),
            ],
          );
        }
      )
    );
  }
}



class UpDownButtonWidget extends StatefulWidget {
  const UpDownButtonWidget({super.key});

  @override
  _UpDownButtonWidgetState createState() => _UpDownButtonWidgetState();
}

class _UpDownButtonWidgetState extends State<UpDownButtonWidget> {
  bool isUpSelected = true; // Track the selected button

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Button
        _ButtonWithDivider(
          label: "Up".toUpperCase(),
          isSelected: isUpSelected,
          onPressed: () {
            setState(() {
              isUpSelected = true;
            });
          },
        ),
        // Down Button
        _ButtonWithDivider(
          label: "Down".toUpperCase(),
          isSelected: !isUpSelected,
          onPressed: () {
            setState(() {
              isUpSelected = false;
            });
          },
        ),
      ],
    );
  }
}

class _ButtonWithDivider extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ButtonWithDivider({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Button with GestureDetector
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              label,
              style:
              Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorManager.yellow : ColorManager.grey, // Text color
              ),
            ),
          ),
        ),
        // Divider as tab selection indicator
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: isSelected ? 40 : 0,  // Divider width when selected
          height: 4,                    // Divider height
          color: isSelected ? ColorManager.yellow : Colors.transparent,  // Divider color

        ),
      ],
    );
  }
}

