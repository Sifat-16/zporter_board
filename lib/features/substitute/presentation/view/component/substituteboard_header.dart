import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class SubstituteboardHeader extends StatefulWidget {
  const SubstituteboardHeader({super.key, required this.matchTimes});

  final List<MatchTime> matchTimes;

  @override
  State<SubstituteboardHeader> createState() => _SubstituteboardHeaderState();
}

class _SubstituteboardHeaderState extends State<SubstituteboardHeader> {

  TimerController _timerController = TimerController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("OUT", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: ColorManager.grey
            ),),

            Container(

            ),

            Text("IN", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: ColorManager.grey
            ),),
          ],
        ),
        Align(
          alignment: Alignment.center,
          // child: TimerComponent(
          //   elapsedSeconds: 1025,
          //   controller: _timerController,
          //   textColor: ColorManager.grey,
          // ),
          child: TimerComponent(
            elapsedSeconds: MatchUtils.getMatchTime(widget.matchTimes).elapsedSeconds,
            isRunning: MatchUtils.getMatchTime(widget.matchTimes).isRunning,
            controller: _timerController,
            textColor: ColorManager.grey,
          ),
        )
      ],
    );
  }
}
