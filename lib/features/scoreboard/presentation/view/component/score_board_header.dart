import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class ScoreBoardHeader extends StatefulWidget {
  const ScoreBoardHeader({super.key, required this.matchTimes});

  final List<MatchTime> matchTimes;

  @override
  State<ScoreBoardHeader> createState() => _ScoreBoardHeaderState();
}

class _ScoreBoardHeaderState extends State<ScoreBoardHeader> {
  TimerController _timerController = TimerController();

  @override
  void didUpdateWidget(covariant ScoreBoardHeader oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("HOME", style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: ColorManager.grey
        ),),

        TimerComponent(elapsedSeconds: MatchUtils.getMatchTime(widget.matchTimes).elapsedSeconds,isRunning: MatchUtils.getMatchTime(widget.matchTimes).isRunning, controller: _timerController,),
        Text("AWAY", style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: ColorManager.grey
        ),),
      ],
    );
  }




}
