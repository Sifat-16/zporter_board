import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/helper/board_container_space_helper.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
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

class _TimeboardScreenTabletState extends State<TimeboardScreenTablet> with AutomaticKeepAliveClientMixin {

  TimerController _timerController = TimerController();
  FootballMatch? footballMatch;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MatchBloc>().add(MatchUpdateEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<MatchBloc, MatchState>(
            listener: (BuildContext context, MatchState state){
              if(state is MatchUpdateState){
                MatchBloc matchBloc = context.read<MatchBloc>();
                setState(() {
                  footballMatch = matchBloc.selectedMatch;

                });
              }
            }
        )
      ],
      child: BoardContainer(
        child: Builder(
          builder: (context) {
            double height = getBoardHeightLeft(context);
            return footballMatch==null?Container(
              child: Center(
                child: Text("No match to show"),

              ),
            ):Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height*.2,
                  child: ScoreComponent(
                    matchScore: footballMatch!.matchScore,
                  ),
                ),
                Container(
                  height: height*.4,
                  width: context.widthPercent(90),

                  child: Builder(
                    builder: (context) {

                      return TimerComponent(
                          elapsedSeconds: MatchUtils.getMatchTime(footballMatch?.matchTime??[]).elapsedSeconds,
                          letterSpacing: 20,
                          isRunning: MatchUtils.getMatchTime(footballMatch?.matchTime??[]).isRunning,
                          textSize: AppSize.s160,
                          textColor: ColorManager.white,
                        controller: _timerController,
                      );
                    }
                  ),
                ),
                Container(
                  height: height*.1,

                  child: TimeManagerComponent(
                    onStart: (){
                      context.read<MatchBloc>().add(MatchTimeUpdateEvent(matchId: footballMatch?.id, matchTimeUpdateStatus: MatchTimeUpdateStatus.START));
                    },
                    onPause: (){
                      context.read<MatchBloc>().add(MatchTimeUpdateEvent(matchId: footballMatch?.id,matchTimeUpdateStatus: MatchTimeUpdateStatus.PAUSE));
                    },
                    onStop: (){
                      context.read<MatchBloc>().add(MatchTimeUpdateEvent(matchId: footballMatch?.id,matchTimeUpdateStatus: MatchTimeUpdateStatus.STOP));
                    },

                  ),
                ),
                Container(
                  height: height*.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex:1,
                          child: UpDownButtonWidget()
                      ),
                      Flexible(
                          flex: 1,
                          child: MatchPaginationComponent()
                      ),
                      Flexible(
                          flex:1,
                          child: IconButton(onPressed: (){}, icon: Icon(Icons.delete))),
                    ],
                  ),
                ),
              ],
            );
          }
        )
      ),
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
  bool isUpSelected = true; // Track the selected button

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Button
        _ButtonWithDivider(
          label: "Up".toUpperCase(),
          isSelected: isUpSelected,
          onPressed: () {
            setState(() {
              isUpSelected = true;
            });
          },
        ),
        // Down Button
        _ButtonWithDivider(
          label: "Down".toUpperCase(),
          isSelected: !isUpSelected,
          onPressed: () {
            setState(() {
              isUpSelected = false;
            });
          },
        ),
      ],
    );
  }
}

class _ButtonWithDivider extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ButtonWithDivider({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Button with GestureDetector
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              label,
              style:
              Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorManager.yellow : ColorManager.grey, // Text color
              ),
            ),
          ),
        ),
        // Divider as tab selection indicator
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: isSelected ? 40 : 0,  // Divider width when selected
          height: 4,                    // Divider height
          color: isSelected ? ColorManager.yellow : Colors.transparent,  // Divider color

        ),
      ],
    );
  }
}

