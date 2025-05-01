import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/countdown_timer_widget.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';

class ScoreBoardHeader extends StatefulWidget {
  const ScoreBoardHeader({super.key, required this.matchPeriod});

  // final List<MatchTimeBloc> matchTimes;
  final MatchPeriod? matchPeriod;

  @override
  State<ScoreBoardHeader> createState() => _ScoreBoardHeaderState();
}

class _ScoreBoardHeaderState extends State<ScoreBoardHeader> {
  TimerController _timerController = TimerController();
  final CountDownTimerController _countDownController =
      CountDownTimerController();

  @override
  void didUpdateWidget(covariant ScoreBoardHeader oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<MatchTimeBloc> periods = widget.matchPeriod?.intervals ?? [];
    return Column(
      children: [
        Text(
          "Time",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: ColorManager.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "HOME",
              style: Theme.of(
                context,
              ).textTheme.displayMedium!.copyWith(color: ColorManager.grey),
            ),

            TimerComponent(
              elapsedSeconds: MatchUtils.getMatchTime(periods).elapsedSeconds,
              isRunning: MatchUtils.getMatchTime(periods).isRunning,
              controller: _timerController,
              periodDivider: 1,
              onRunOut: () {
                context.read<MatchBloc>().add(
                  MatchTimeUpdateEvent(
                    periodId: widget.matchPeriod!.periodNumber,
                    timerMode: TimerMode.UP,
                    matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                  ),
                );
              },
            ),

            // if (widget.matchPeriod?.upPeriodStatus == TimeActiveStatus.RUNNING)
            //   TimerComponent(
            //     elapsedSeconds: MatchUtils.getMatchTime(periods).elapsedSeconds,
            //     isRunning: MatchUtils.getMatchTime(periods).isRunning,
            //     controller: _timerController,
            //     periodDivider: 1,
            //   )
            // else if (widget.matchPeriod?.extraPeriodStatus ==
            //     TimeActiveStatus.RUNNING)
            //   CountDownTimerWidget(
            //     key: ValueKey(
            //       'extra_timer_${widget.matchPeriod?.periodNumber}_',
            //     ),
            //     initialDuration: MatchUtils.findInitialExtraTime(
            //       matchPeriod: widget.matchPeriod!,
            //     ),
            //     isRunning:
            //         MatchUtils.getMatchTime(
            //           periods,
            //         ).isRunning, // Reflect current running state
            //     controller:
            //         _countDownController, // Pass the countdown controller
            //     textColor: ColorManager.white,
            //     // --- Optional: Define callbacks ---
            //     onFinished: () {
            //       zlog(data: "On finished called on timer ");
            //     },
            //     onStart: () {}, // Example
            //     onPause: () {}, // Example
            //     // onStop callback could be added if needed
            //   )
            // else
            //   TimerComponent(
            //     elapsedSeconds:
            //         MatchUtils.getMatchTime(
            //           widget.matchPeriod?.intervals ?? [],
            //         ).elapsedSeconds,
            //     isRunning:
            //         MatchUtils.getMatchTime(
            //           widget.matchPeriod?.intervals ?? [],
            //         ).isRunning,
            //     controller: _timerController,
            //     periodDivider: 1,
            //   ),
            Text(
              "AWAY",
              style: Theme.of(
                context,
              ).textTheme.displayMedium!.copyWith(color: ColorManager.grey),
            ),
          ],
        ),
      ],
    );
  }
}
