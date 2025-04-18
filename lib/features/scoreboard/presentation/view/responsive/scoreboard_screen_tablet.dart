import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/helper/board_container_space_helper.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_add_delete_component.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
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
    double height = getBoardHeightLeft(context);
    return BlocConsumer<MatchBloc, MatchState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScoreBoardHeader(matchTimes: state.selectedMatch?.matchTime ?? []),

            SizedBox(
              height: height * .7,
              child: ScoreCard(
                matchScore: state.selectedMatch?.matchScore,
                updateMatchScore: (matchScore) {
                  if (state.selectedMatch != null) {
                    context.read<MatchBloc>().add(
                      MatchScoreUpdateEvent(
                        newScore: matchScore,
                        matchId: state.selectedMatch?.id ?? "",
                      ),
                    );
                  }
                },
              ),
            ),

            SizedBox(
              height: height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LockRotateButtonWidget(),
                  MatchPaginationComponent(),
                  MatchAddDeleteComponent(),
                ],
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, MatchState state) {},
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
