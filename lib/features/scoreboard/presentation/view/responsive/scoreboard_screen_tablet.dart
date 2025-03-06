
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/common/components/pagination/pagination_component.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/score_board_header.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/component/score_card.dart';

class ScoreboardScreenTablet extends StatefulWidget {
  const ScoreboardScreenTablet({super.key});

  @override
  State<ScoreboardScreenTablet> createState() => _ScoreboardScreenTabletState();
}

class _ScoreboardScreenTabletState extends State<ScoreboardScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return BoardContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScoreBoardHeader(),

          ScoreCard(),

          SizedBox(

            child: PaginationComponent()
          )


        ],
      ),
    );
  }
}
