import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/common/components/button/button_with_divider.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/helper/board_container_space_helper.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_add_delete_component.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/time/presentation/view/component/score_component.dart';
import 'package:zporter_board/features/time/presentation/view/component/time_manager_component.dart';

class TimeboardScreenTablet extends StatefulWidget {
  const TimeboardScreenTablet({super.key});

  @override
  State<TimeboardScreenTablet> createState() => _TimeboardScreenTabletState();
}

class _TimeboardScreenTabletState extends State<TimeboardScreenTablet>
    with AutomaticKeepAliveClientMixin {
  TimerController _timerController = TimerController();
  // FootballMatch? footballMatch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // context.read<MatchBloc>().add(MatchUpdateEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MatchBloc, MatchState>(
      builder: (context, state) {
        return BoardContainer(
          zeroPadding: true,
          child: Builder(
            builder: (context) {
              double height = getBoardHeightLeft(context);
              return state.selectedMatch == null
                  ? Container(child: Center(child: Text("No match to show")))
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * .2,
                        child: ScoreComponent(
                          matchScore: state.selectedMatch!.matchScore,
                        ),
                      ),
                      Container(
                        // color: Colors.green,
                        height: height * .6,
                        width: context.widthPercent(100),

                        child: Builder(
                          builder: (context) {
                            return TimerComponent(
                              elapsedSeconds:
                                  MatchUtils.getMatchTime(
                                    state.selectedMatch?.matchTime ?? [],
                                  ).elapsedSeconds,
                              letterSpacing: 20,
                              isRunning:
                                  MatchUtils.getMatchTime(
                                    state.selectedMatch?.matchTime ?? [],
                                  ).isRunning,
                              textSize: AppSize.s180,
                              textColor: ColorManager.white,
                              controller: _timerController,
                            );
                          },
                        ),
                      ),
                      Container(
                        height: height * .1,

                        child: TimeManagerComponent(
                          footballMatch: state.selectedMatch,
                          onStart: () {
                            context.read<MatchBloc>().add(
                              MatchTimeUpdateEvent(
                                matchId: state.selectedMatch?.id,
                                matchTimeUpdateStatus:
                                    MatchTimeUpdateStatus.START,
                              ),
                            );
                          },
                          onPause: () {
                            context.read<MatchBloc>().add(
                              MatchTimeUpdateEvent(
                                matchId: state.selectedMatch?.id,
                                matchTimeUpdateStatus:
                                    MatchTimeUpdateStatus.PAUSE,
                              ),
                            );
                          },
                          onStop: () {
                            context.read<MatchBloc>().add(
                              MatchTimeUpdateEvent(
                                matchId: state.selectedMatch?.id,
                                matchTimeUpdateStatus:
                                    MatchTimeUpdateStatus.STOP,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: height * .1,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            UpDownButtonWidget(),
                            MatchPaginationComponent(),
                            MatchAddDeleteComponent(),
                          ],
                        ),
                      ),
                    ],
                  );
            },
          ),
        );
      },
      listener: (BuildContext context, MatchState state) {},
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class UpDownButtonWidget extends StatefulWidget {
  const UpDownButtonWidget({super.key});

  @override
  _UpDownButtonWidgetState createState() => _UpDownButtonWidgetState();
}

class _UpDownButtonWidgetState extends State<UpDownButtonWidget> {
  String selected = "up"; // Track the selected button

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Button
        ButtonWithDivider(
          label: "Up".toUpperCase(),
          isSelected: selected == "up",
          onPressed: () {
            setState(() {
              selected = "up";
            });
          },
        ),
        // Down Button
        ButtonWithDivider(
          label: "Down".toUpperCase(),
          isSelected: selected == "down",
          onPressed: () {
            setState(() {
              selected = "down";
            });
          },
        ),
        ButtonWithDivider(
          label: "Extra".toUpperCase(),
          isSelected: selected == "extra",
          onPressed: () {
            setState(() {
              selected = "extra";
            });
          },
        ),
      ],
    );
  }
}
