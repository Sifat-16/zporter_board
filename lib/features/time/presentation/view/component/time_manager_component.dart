import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/counter_timer_component.dart';
import 'package:zporter_board/core/common/components/timer/live_clock_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';

class TimeManagerComponent extends StatelessWidget {
  const TimeManagerComponent({
    super.key,
    required this.matchPeriod,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    this.status,
  });
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  final MatchPeriod? matchPeriod;
  final TimeActiveStatus? status;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LiveClockComponent(),
          TimerControlButtons(
            onStart: onStart,
            onPause: onPause,
            onStop: onStop,
            initialStatus:
                MatchUtils.getMatchTime(
                          matchPeriod?.intervals ?? [],
                        ).isRunning ==
                        true
                    ? TimeActiveStatus.RUNNING
                    : status == null
                    ? TimeActiveStatus.PAUSED
                    : status!,
          ),
          CounterTimerComponent(
            startTime: MatchUtils.findInitialTime(matchPeriod: matchPeriod),
          ),
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
