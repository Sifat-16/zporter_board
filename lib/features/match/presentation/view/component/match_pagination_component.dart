import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';

import '../../../../../core/utils/log/debugger.dart';

class MatchPaginationComponent extends StatefulWidget {
  const MatchPaginationComponent({super.key});

  @override
  State<MatchPaginationComponent> createState() => _MatchPaginationComponentState();
}

class _MatchPaginationComponentState extends State<MatchPaginationComponent> with AutomaticKeepAliveClientMixin {

  List<FootballMatch> footBallMatch=[];
  int selectedIndex=0;



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MatchBloc, MatchState>(
      listener: (BuildContext context, MatchState state){
        if(state is MatchUpdateState){
          debug(data: "New Match updated");
          MatchBloc matchBloc = context.read<MatchBloc>();
          setState(() {
            footBallMatch = matchBloc.matches??[];
            debug(data: "Matches data ${footBallMatch}");
          });
        }
      },
      builder: (context, state) {
        if(state is! MatchUpdateState){
          return Center(child: CircularProgressIndicator(),);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: NumberPaginator(
            numberPages: footBallMatch.length,
            initialPage: selectedIndex,

            onPageChange: (int index) {
              context.read<MatchBloc>().add(MatchSelectEvent(index: index));
              setState(() {
                selectedIndex = index;
              });
              // handle page change...
            },
            prevButtonContent: Icon(Icons.chevron_left, color: ColorManager.grey, size: AppSize.s32,),
            nextButtonContent: Icon(Icons.chevron_right, color: ColorManager.grey,size: AppSize.s32),
            config: NumberPaginatorUIConfig(
              buttonShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded edges
              ),
              buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              buttonSelectedForegroundColor: ColorManager.yellow, // Selected text color
              buttonSelectedBackgroundColor: Colors.black, // Background of selected button
              buttonUnselectedForegroundColor: ColorManager.grey, // Unselected text color
              buttonUnselectedBackgroundColor: Colors.transparent, // Unselected button background
              buttonTextStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.s28
              ),
            ),
          ),
        );
      }
    );;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
