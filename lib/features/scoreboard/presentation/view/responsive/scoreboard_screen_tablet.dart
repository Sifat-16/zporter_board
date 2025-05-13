import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
import 'package:zporter_board/features/match/presentation/view/component/period_add_match_delete_component.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/lock_rotate_component.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/score_board_header.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/score_card.dart';

class ScoreboardScreenTablet extends StatefulWidget {
  const ScoreboardScreenTablet({super.key});

  @override
  State<ScoreboardScreenTablet> createState() => _ScoreboardScreenTabletState();
}

class _ScoreboardScreenTabletState extends State<ScoreboardScreenTablet>
    with AutomaticKeepAliveClientMixin {
  // FootballMatch? footballMatch;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<MatchBloc, MatchState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double height = constraints.maxHeight;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height * .15,
                  child: ScoreBoardHeader(matchPeriod: state.selectedPeriod),
                ),

                SizedBox(
                  height: height * .75,
                  child: ScoreCard(
                    matchScore: state.match?.matchScore,
                    updateMatchScore: (matchScore) {
                      if (state.match != null) {
                        context.read<MatchBloc>().add(
                          MatchScoreUpdateEvent(
                            newScore: matchScore,
                            matchId: state.match?.id ?? "",
                          ),
                        );
                      }
                    },
                  ),
                ),

                SizedBox(
                  height: height * .1,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Image.asset(
                            AssetsManager.logo,
                            height: AppSize.s40,
                            width: AppSize.s40,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LockRotateButtonWidget(),
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
        );
      },
      listener: (BuildContext context, MatchState state) {},
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
