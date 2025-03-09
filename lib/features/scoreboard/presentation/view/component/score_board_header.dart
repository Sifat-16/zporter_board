import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';

class ScoreBoardHeader extends StatefulWidget {
  const ScoreBoardHeader({super.key, required this.footballMatch});

  final FootballMatch? footballMatch;

  @override
  State<ScoreBoardHeader> createState() => _ScoreBoardHeaderState();
}

class _ScoreBoardHeaderState extends State<ScoreBoardHeader> {
  TimerController _timerController = TimerController();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("HOME", style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: ColorManager.grey
        ),),
        TimerComponent(startMinutes: 45, startSeconds: 30, controller: _timerController,),
        Text("AWAY", style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: ColorManager.grey
        ),),
      ],
    );
  }

  _extractTimeFromMatch(){

  }

}
