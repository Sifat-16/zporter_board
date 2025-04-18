import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/helper/board_container_space_helper.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_add_delete_component.dart';
import 'package:zporter_board/features/match/presentation/view/component/match_pagination_component.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/home_away_component.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/substitute_component.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/substituteboard_header.dart';

class SubstituteboardScreenTablet extends StatefulWidget {
  const SubstituteboardScreenTablet({super.key});

  @override
  State<SubstituteboardScreenTablet> createState() =>
      _SubstituteboardScreenTabletState();
}

class _SubstituteboardScreenTabletState
    extends State<SubstituteboardScreenTablet>
    with AutomaticKeepAliveClientMixin {
  // FootballMatch? footballMatch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MatchBloc>().add(MatchUpdateEvent());
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
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: height * .15,
                        child: SubstituteboardHeader(
                          matchTimes: state.selectedMatch?.matchTime ?? [],
                        ),
                      ),

                      Container(
                        height: height * .75,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: height * .75,
                                    color: ColorManager.red,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: height * .75,
                                    color: ColorManager.green,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: AppSize.s20),
                              child: SubstituteComponent(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height * .1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeAwayComponent(),
                            MatchPaginationComponent(),
                            MatchAddDeleteComponent(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
