import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';

class SubstituteboardHeader extends StatefulWidget {
  const SubstituteboardHeader({super.key, required this.matchPeriod});

  final MatchPeriod matchPeriod;

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
            Text(
              "OUT",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: ColorManager.grey,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),

            Container(),

            Text(
              "IN",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: ColorManager.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "Time",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: ColorManager.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TimerComponent(
                periodDivider: 1,
                elapsedSeconds:
                    MatchUtils.getMatchTime(
                      widget.matchPeriod.intervals,
                    ).elapsedSeconds,
                isRunning:
                    MatchUtils.getMatchTime(
                      widget.matchPeriod.intervals,
                    ).isRunning,
                controller: _timerController,
                textColor: ColorManager.grey,
                onRunOut: () {
                  context.read<MatchBloc>().add(
                    MatchTimeUpdateEvent(
                      periodId: widget.matchPeriod.periodNumber,
                      timerMode: TimerMode.UP,
                      matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
