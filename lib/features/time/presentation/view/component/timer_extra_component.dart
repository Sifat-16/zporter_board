import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TimerController is no longer needed here
// import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/domain/entity/match_time_status.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

import 'countdown_timer_widget.dart';

class TimerExtraComponent extends StatefulWidget {
  const TimerExtraComponent({super.key, required this.height});
  final double height;

  @override
  State<TimerExtraComponent> createState() => _TimerExtraComponentState();
}

class _TimerExtraComponentState extends State<TimerExtraComponent> {
  // --- Use the Controller for the CountDownTimerWidget ---
  final CountDownTimerController _countDownController =
      CountDownTimerController();
  // ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Using BlocBuilder as state needs to be read here directly
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        double height = widget.height;
        final selectedPeriod = state.selectedPeriod;

        zlog(
          data:
              "State of the period status extra screen ${selectedPeriod?.upPeriodStatus} - ${selectedPeriod?.extraPeriodStatus}",
        );

        // It's crucial that selectedPeriod is not null and is EXTRA mode here
        // Add checks or ensure this component is only rendered when appropriate
        if (selectedPeriod == null ||
            selectedPeriod.timerMode != TimerMode.EXTRA ||
            state.match == null) {
          // Show a loading or error state if data is not ready/correct
          return const Center(child: Text("Waiting for Extra Time data..."));
        }

        final intervals = selectedPeriod.extraTime.intervals;
        final MatchTimeStatus matchTimeStatus = MatchUtils.getMatchTime(
          intervals,
        );

        // --- Determine the initial duration for the countdown ---
        // Use the presetDuration stored in the period, default to 3 mins if null
        final Duration initialDuration = MatchUtils.findInitialExtraTime(
          matchPeriod: selectedPeriod,
        );

        // ------------------------------------------------------

        return Column(
          // Keep original Column structure
          children: [
            // --- Timer Display Area ---
            Container(
              height: height * 0.85, // Maintain original height ratio
              child: SizedBox(
                width: context.widthPercent(100),
                // --- REPLACE TimerComponent with CountDownTimerWidget ---
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.85 * .9,
                      width: context.widthPercent(100),
                      child: CountDownTimerWidget(
                        // Add a Key to help Flutter update correctly if duration changes
                        key: ValueKey(
                          'extra_timer_${selectedPeriod.periodNumber}_${initialDuration.inSeconds}',
                        ),
                        initialDuration: initialDuration,
                        isRunning:
                            matchTimeStatus
                                .isRunning, // Reflect current running state
                        controller:
                            _countDownController, // Pass the countdown controller
                        // --- Pass styling properties ---
                        letterSpacing: 20,
                        textSize: AppSize.s180,
                        textColor: ColorManager.white,
                        // --- Optional: Define callbacks ---
                        onFinished: () {
                          zlog(
                            data:
                                "Extra Time Period ${selectedPeriod.periodNumber} Finished!",
                          );
                          // You might want to dispatch an event here, e.g., to auto-advance period
                          // context.read<MatchBloc>().add(PeriodFinishedEvent(selectedPeriod.periodNumber));
                        },
                        onStart:
                            () => zlog(
                              data: "Countdown started via widget callback",
                            ), // Example
                        onPause:
                            () => zlog(
                              data: "Countdown paused via widget callback",
                            ), // Example
                        // onStop callback could be added if needed
                      ),
                    ),

                    Container(
                      height: height * 0.85 * .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<MatchBloc>().add(
                                      IncreaseExtraTimeEvent(),
                                    );
                                  },
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: ColorManager.white,
                                    size: height * 0.85 * .1,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<MatchBloc>().add(
                                      DecreaseExtraTimeEvent(),
                                    );
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline,
                                    color: ColorManager.white,
                                    size: height * 0.85 * .1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Flexible(child: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
                // ---------------------------------------------------------
              ),
            ),

            // --- Timer Management Area ---
            Container(
              height: height * 0.15, // Takes remaining height
              child: CountdownTimeManagerComponent(
                // Note: TimeManagerComponent might need adjustment later
                // if its display/logic depends on the mode (e.g., showing preset time)
                matchPeriod: state.selectedPeriod,
                status: state.selectedPeriod?.extraPeriodStatus,
                onStart: () {
                  context.read<MatchBloc>().add(
                    MatchTimeUpdateEvent(
                      matchTimeUpdateStatus: MatchTimeUpdateStatus.START,
                      periodId: state.selectedPeriod?.periodNumber ?? -1,
                      timerMode: TimerMode.EXTRA,
                    ),
                  );
                },
                onPause: () {
                  context.read<MatchBloc>().add(
                    MatchTimeUpdateEvent(
                      matchTimeUpdateStatus: MatchTimeUpdateStatus.PAUSE,
                      periodId: state.selectedPeriod?.periodNumber ?? -1,
                      timerMode: TimerMode.EXTRA,
                    ),
                  );
                },
                onStop: () {
                  context.read<MatchBloc>().add(
                    MatchTimeUpdateEvent(
                      periodId: state.selectedPeriod?.periodNumber ?? -1,
                      matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                      timerMode: TimerMode.EXTRA,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
