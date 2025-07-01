// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:zporter_board/core/common/components/board_container.dart';
// import 'package:zporter_board/core/common/components/timer/timer_component.dart';
// import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
// import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
// import 'package:zporter_board/core/extension/size_extension.dart';
// import 'package:zporter_board/core/helper/board_container_space_helper.dart';
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
// import 'package:zporter_board/core/resource_manager/values_manager.dart';
// import 'package:zporter_board/core/utils/match/match_utils.dart';
// import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
// import 'package:zporter_board/features/match/presentation/view/component/period_add_match_delete_component.dart';
// import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
// import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
// import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
// import 'package:zporter_board/features/time/presentation/view/component/score_component.dart';
// import 'package:zporter_board/features/time/presentation/view/component/time_manager_component.dart';
// import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
// import 'package:zporter_tactical_board/app/helper/logger.dart';
//
// class TimeboardScreenTablet extends StatefulWidget {
//   const TimeboardScreenTablet({super.key});
//
//   @override
//   State<TimeboardScreenTablet> createState() => _TimeboardScreenTabletState();
// }
//
// class _TimeboardScreenTabletState extends State<TimeboardScreenTablet>
//     with AutomaticKeepAliveClientMixin {
//   TimerController _timerController = TimerController();
//   // FootballMatch? footballMatch;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // context.read<MatchBloc>().add(MatchUpdateEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return BlocConsumer<MatchBloc, MatchState>(
//       builder: (context, state) {
//         zlog(
//           data:
//               "Depending on state the timer running outside ${MatchUtils.getMatchTime(state.selectedPeriod?.intervals ?? []).isRunning}",
//         );
//         return BoardContainer(
//           zeroPadding: true,
//           child: Builder(
//             builder: (context) {
//               double height = getBoardHeightLeft(context);
//
//               return state.match == null
//                   ? Container(child: Center(child: Text("No match to show")))
//                   : Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         child: SizedBox(
//                           height: height * .15,
//                           child: ScoreComponent(
//                             matchScore: state.match!.matchScore,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         // color: Colors.white.withValues(alpha: 0.1),
//                         height: height * .65,
//                         child: SizedBox(
//                           width: context.widthPercent(100),
//                           child: TimerComponent(
//                             elapsedSeconds:
//                                 MatchUtils.getMatchTime(
//                                   state.selectedPeriod?.intervals ?? [],
//                                 ).elapsedSeconds,
//                             letterSpacing: 20,
//                             isRunning:
//                                 MatchUtils.getMatchTime(
//                                   state.selectedPeriod?.intervals ?? [],
//                                 ).isRunning,
//                             textSize: AppSize.s180,
//                             textColor: ColorManager.white,
//                             controller: _timerController,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: height * .1,
//
//                         // color: ColorManager.red,
//                         child: TimeManagerComponent(
//                           matchPeriod: state.selectedPeriod,
//                           status:
//                               state.match?.status == "START"
//                                   ? TimeActiveStatus.RUNNING
//                                   : state.match?.status == "PAUSED"
//                                   ? TimeActiveStatus.PAUSED
//                                   : TimeActiveStatus.STOPPED,
//                           onStart: () {
//                             context.read<MatchBloc>().add(
//                               MatchTimeUpdateEvent(
//                                 matchTimeUpdateStatus:
//                                     MatchTimeUpdateStatus.START,
//                                 periodId:
//                                     state.selectedPeriod?.periodNumber ?? -1,
//                               ),
//                             );
//                           },
//                           onPause: () {
//                             context.read<MatchBloc>().add(
//                               MatchTimeUpdateEvent(
//                                 matchTimeUpdateStatus:
//                                     MatchTimeUpdateStatus.PAUSE,
//                                 periodId:
//                                     state.selectedPeriod?.periodNumber ?? -1,
//                               ),
//                             );
//                           },
//                           onStop: () {
//                             context.read<MatchBloc>().add(
//                               MatchTimeUpdateEvent(
//                                 periodId:
//                                     state.selectedPeriod?.periodNumber ?? -1,
//                                 matchTimeUpdateStatus:
//                                     MatchTimeUpdateStatus.STOP,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Container(
//                         height: height * .1,
//
//                         // color: ColorManager.blue,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             TimerModeWidget(
//                               currentTimerModeString:
//                                   state.selectedPeriod?.timerMode ?? "up",
//                               onModeSelected: (TimerMode value) {},
//                             ),
//                             PeriodPaginationComponent(),
//                             PeriodAddMatchDeleteComponent(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//             },
//           ),
//         );
//       },
//       listener: (BuildContext context, MatchState state) {},
//     );
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/common/components/links/zporter_logo_launcher.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
import 'package:zporter_board/features/match/presentation/view/component/period_add_match_delete_component.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/time/presentation/view/component/score_component.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_extra_component.dart';
// Import needed for TimerMode enum if used directly
import 'package:zporter_board/features/time/presentation/view/component/timer_mode_widget.dart';
import 'package:zporter_board/features/time/presentation/view/component/timer_up_component.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

class TimeboardScreenTablet extends StatefulWidget {
  const TimeboardScreenTablet({super.key});

  @override
  State<TimeboardScreenTablet> createState() => _TimeboardScreenTabletState();
}

class _TimeboardScreenTabletState extends State<TimeboardScreenTablet>
    with AutomaticKeepAliveClientMixin {
  // Keep the controller as TimerComponent might still need it in UP mode

  @override
  void initState() {
    super.initState();
  }

  // --- HELPER FUNCTION TO DECIDE WHICH WIDGET TO SHOW ---
  // This function now returns either the original TimerComponent or a simple Text widget
  Widget _buildCentralDisplay(MatchState state, double height) {
    final selectedPeriod = state.selectedPeriod;
    // Default to "UP" if period or mode is null/empty
    final TimerMode currentMode = selectedPeriod?.timerMode ?? TimerMode.UP;

    switch (currentMode) {
      case TimerMode.DOWN:
        return const Center(
          child: Text(
            'DOWN Mode Active', // Simple placeholder
            style: TextStyle(
              fontSize: AppSize.s40,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case TimerMode.EXTRA:
        return TimerExtraComponent(height: height);
      case TimerMode.UP:
        return TimerUpComponent(height: height);
      // -----------------------------------------------------------
    }
  }
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Use BlocBuilder directly if listener is not actively used
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        // Logging kept as is
        zlog(
          data:
              "Depending on state the timer running outside ${MatchUtils.getMatchTime(state.selectedPeriod?.intervals ?? []).isRunning}",
        );
        return BoardContainer(
          zeroPadding: true,
          child: LayoutBuilder(
            // Keep Builder if needed for context down the tree
            builder: (context, constraints) {
              double height = constraints.maxHeight; // Keep height calculation

              // Keep null check for the overall match data
              if (state.match == null) {
                return const Center(child: Text("No match to show"));
              }

              // Keep the main Column structure
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ScoreComponent remains unchanged
                  Container(
                    child: SizedBox(
                      height: height * .15,
                      child: ScoreComponent(
                        matchScore: state.match!.matchScore,
                      ),
                    ),
                  ),

                  Container(
                    height: height * .75,
                    child: _buildCentralDisplay(state, height * .75),
                  ),
                  // --- CENTRAL DISPLAY AREA ---
                  // Container(
                  //   // Keep styling as is
                  //   height: height * .65,
                  //   child: SizedBox(
                  //     width: context.widthPercent(100),
                  //     // Use the helper function to determine the child widget
                  //     child: _buildCentralDisplay(state),
                  //   ),
                  // ),
                  // // -----------------------------
                  //
                  // // TimeManagerComponent remains unchanged in structure
                  // Container(
                  //   height: height * .1,
                  //   child: TimeManagerComponent(
                  //     // Note: TimeManagerComponent might need adjustment later
                  //     // if its display/logic depends on the mode (e.g., showing preset time)
                  //     matchPeriod: state.selectedPeriod,
                  //     status:
                  //         state.match?.status == "START"
                  //             ? TimeActiveStatus.RUNNING
                  //             : state.match?.status == "PAUSE"
                  //             ? TimeActiveStatus.PAUSED
                  //             : TimeActiveStatus.STOPPED,
                  //     onStart: () {
                  //       context.read<MatchBloc>().add(
                  //         MatchTimeUpdateEvent(
                  //           matchTimeUpdateStatus: MatchTimeUpdateStatus.START,
                  //           periodId: state.selectedPeriod?.periodNumber ?? -1,
                  //         ),
                  //       );
                  //     },
                  //     onPause: () {
                  //       context.read<MatchBloc>().add(
                  //         MatchTimeUpdateEvent(
                  //           matchTimeUpdateStatus: MatchTimeUpdateStatus.PAUSE,
                  //           periodId: state.selectedPeriod?.periodNumber ?? -1,
                  //         ),
                  //       );
                  //     },
                  //     onStop: () {
                  //       context.read<MatchBloc>().add(
                  //         MatchTimeUpdateEvent(
                  //           periodId: state.selectedPeriod?.periodNumber ?? -1,
                  //           matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  // Bottom Row remains unchanged in structure
                  Container(
                    height: height * .1,
                    // padding: EdgeInsets.only(
                    //   left: context.widthPercent(10),
                    //   right: context.widthPercent(5),
                    // ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            // child: Image.asset(
                            //   AssetsManager.logo,
                            //   height: AppSize.s40,
                            //   width: AppSize.s40,
                            // ),
                            child: ZporterLogoLauncher(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TimerModeWidget(
                              // Pass state and callback - ensure callback dispatches event
                              currentTimerMode:
                                  state.selectedPeriod?.timerMode ??
                                      TimerMode.UP,
                              onModeSelected: (TimerMode value) {
                                zlog(data: "Timermode value changing ${value}");
                                // Ensure period exists before dispatching
                                if (state.selectedPeriod != null) {
                                  // Dispatch event to change mode in Bloc
                                  context.read<MatchBloc>().add(
                                        ChangePeriodModeEvent(
                                          periodNumber: state
                                              .selectedPeriod!.periodNumber,
                                          newMode: value,
                                          // Handle potential preset duration setting here too if needed
                                        ),
                                      );
                                }
                              },
                            ),
                            // Other components remain unchanged
                            PeriodPaginationComponent(),
                            PeriodAddMatchDeleteComponent(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
      // Listener removed if BlocBuilder is used, or kept if needed elsewhere
      // listener: (BuildContext context, MatchState state) {},
    );
  }

  @override
  // Keep AutomaticKeepAliveClientMixin logic
  bool get wantKeepAlive => true;
}
