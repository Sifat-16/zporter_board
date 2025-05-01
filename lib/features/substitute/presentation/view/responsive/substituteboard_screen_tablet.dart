import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/board_container.dart';
import 'package:zporter_board/core/helper/board_container_space_helper.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view/component/period_add_match_delete_component.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/home_away_component.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/substitute_component.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/substitute_pagination_component.dart';
import 'package:zporter_board/features/substitute/presentation/view/component/substituteboard_header.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

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

  bool isHome = true;
  // Substitution? selectedSub;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MatchBloc>().add(MatchUpdateEvent());
  }

  _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MatchBloc, MatchState>(
      builder: (context, state) {
        final FootballMatch? selectedMatch = state.match;

        MatchSubstitutions? matchSubstitutions = selectedMatch?.substitutions;

        zlog(data: "Match subs are ${matchSubstitutions}");
        List<Substitution> subs =
            isHome
                ? (matchSubstitutions?.homeSubs ?? [])
                : (matchSubstitutions?.awaySubs ?? []);

        // if (selectedSub == null) {
        //   if (subs.isNotEmpty) {
        //     selectedSub = subs[_selectedIndex];
        //   }
        // } else {
        //   if (selectedSub?.id != subs[_selectedIndex].id) {
        //     selectedSub = subs[_selectedIndex];
        //   }
        // }

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
                          matchPeriod: state.selectedPeriod!,
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
                              child: SubstituteComponent(
                                substitution: subs[_selectedIndex],
                                onSubUpdate: (sub) {
                                  int index = subs.indexWhere(
                                    (s) => s.id == sub.id,
                                  );
                                  if (index != -1) {
                                    subs[index] = sub;
                                    if (isHome) {
                                      matchSubstitutions = matchSubstitutions
                                          ?.copyWith(homeSubs: subs);
                                    } else {
                                      matchSubstitutions = matchSubstitutions
                                          ?.copyWith(awaySubs: subs);
                                    }

                                    if (matchSubstitutions != null) {
                                      context.read<MatchBloc>().add(
                                        SubUpdateEvent(
                                          matchId: selectedMatch?.id ?? "",
                                          matchSubstitutions:
                                              matchSubstitutions!,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                                HomeAwayComponent(
                                  isHome: (b) {
                                    zlog(data: "isHomeChanging");
                                    setState(() {
                                      isHome = b;
                                    });
                                  },
                                ),
                                SubstitutePaginationComponent(
                                  total: subs.length,
                                  onSubChange: (s) {
                                    _updateSelectedIndex(s);
                                  },
                                ),
                                PeriodAddMatchDeleteComponent(showAdd: false),
                              ],
                            ),
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
