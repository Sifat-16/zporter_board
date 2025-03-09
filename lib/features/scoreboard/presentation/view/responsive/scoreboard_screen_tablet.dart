
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/score_board_header.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/score_card.dart';

class ScoreboardScreenTablet extends StatefulWidget {
  const ScoreboardScreenTablet({super.key});

  @override
  State<ScoreboardScreenTablet> createState() => _ScoreboardScreenTabletState();
}

class _ScoreboardScreenTabletState extends State<ScoreboardScreenTablet> with AutomaticKeepAliveClientMixin {

  FootballMatch? footballMatch;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScoreBoardHeader(),

            ScoreCard(),

            SizedBox(
              child: MatchPaginationComponent()
            )


          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
