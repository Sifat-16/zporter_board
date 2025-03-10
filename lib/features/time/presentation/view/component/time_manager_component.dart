import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/counter_timer_component.dart';
import 'package:zporter_board/core/common/components/timer/live_clock_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/core/utils/time/time_utils.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';

class TimeManagerComponent extends StatelessWidget {
  const TimeManagerComponent({super.key,
    required this.footballMatch,
    required this.onStart,
    required this.onPause,
    required this.onStop,});
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  final FootballMatch? footballMatch;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LiveClockComponent(),
          TimerControlButtons(onStart: onStart, onPause: onPause, onStop: onStop),
          CounterTimerComponent(startTime: MatchUtils.findInitialTime(footballMatch:footballMatch),)
          // Text("TOTAL 01:45:59", style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //     color: ColorManager.grey,
          //     fontWeight: FontWeight.bold,
          //     fontSize: AppSize.s28
          // ),),
        ],
      ),
    );
  }

}
