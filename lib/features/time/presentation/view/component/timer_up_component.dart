import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/time/presentation/view/component/time_manager_component.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class TimerUpComponent extends StatefulWidget {
  const TimerUpComponent({super.key, required this.height});
  final double height;

  @override
  State<TimerUpComponent> createState() => _TimerUpComponentState();
}

class _TimerUpComponentState extends State<TimerUpComponent> {
  final TimerController _timerController = TimerController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchBloc, MatchState>(
      builder: (context, state) {
        double height = widget.height;
        final selectedPeriod = state.selectedPeriod;
        zlog(
          data:
              "State of the period status up screen ${selectedPeriod?.upPeriodStatus} - ${selectedPeriod?.extraPeriodStatus}",
        );

        final intervals = selectedPeriod?.intervals ?? [];
        final matchTimeStatus = MatchUtils.getMatchTime(intervals);
        return Column(
          children: [
            Container(
              // Keep styling as is
              height: height * .85,
              child: SizedBox(
                width: context.widthPercent(100),
                // Use the helper function to determine the child widget
                child: TimerComponent(
                  elapsedSeconds: matchTimeStatus.elapsedSeconds,
                  letterSpacing: 20,
                  onRunOut: () {
                    context.read<MatchBloc>().add(
                          MatchTimeUpdateEvent(
                            periodId: selectedPeriod!.periodNumber,
                            timerMode: TimerMode.UP,
                            matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                          ),
                        );
                  },
                  isRunning: matchTimeStatus.isRunning,
                  textSize: AppSize.s180,
                  textColor: ColorManager.white,
                  controller: _timerController, // Pass the existing controller
                ),
              ),
            ),
            // -----------------------------

            // TimeManagerComponent remains unchanged in structure
            Container(
              height: height * .15,
              child: TimeManagerComponent(
                // Note: TimeManagerComponent might need adjustment later
                // if its display/logic depends on the mode (e.g., showing preset time)
                matchPeriod: state.selectedPeriod,
                status: state.selectedPeriod?.upPeriodStatus,
                onStart: () {
                  context.read<MatchBloc>().add(
                        MatchTimeUpdateEvent(
                          matchTimeUpdateStatus: MatchTimeUpdateStatus.START,
                          periodId: state.selectedPeriod?.periodNumber ?? -1,
                          timerMode: TimerMode.UP,
                        ),
                      );
                },
                onPause: () {
                  context.read<MatchBloc>().add(
                        MatchTimeUpdateEvent(
                          matchTimeUpdateStatus: MatchTimeUpdateStatus.PAUSE,
                          periodId: state.selectedPeriod?.periodNumber ?? -1,
                          timerMode: TimerMode.UP,
                        ),
                      );
                },
                onStop: () {
                  context.read<MatchBloc>().add(
                        MatchTimeUpdateEvent(
                          periodId: state.selectedPeriod?.periodNumber ?? -1,
                          matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                          timerMode: TimerMode.UP,
                        ),
                      );
                },
                onReset: () {
                  context.read<MatchBloc>().add(
                        MatchTimeUpdateEvent(
                          periodId: state.selectedPeriod?.periodNumber ?? -1,
                          matchTimeUpdateStatus: MatchTimeUpdateStatus.RESET,
                          timerMode: TimerMode.UP,
                        ),
                      );
                },
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, MatchState state) {},
    );
  }
}
