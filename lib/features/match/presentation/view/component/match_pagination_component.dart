import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zporter_board/core/common/components/pagination/compact_paginator.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_tactical_board/app/manager/values_manager.dart';

class MatchPaginationComponent extends StatefulWidget {
  const MatchPaginationComponent({super.key});

  @override
  State<MatchPaginationComponent> createState() =>
      _MatchPaginationComponentState();
}

class _MatchPaginationComponentState extends State<MatchPaginationComponent>
    with AutomaticKeepAliveClientMixin {
  // List<FootballMatch> footBallMatch = [];
  // int selectedIndex = 0;
  bool isVisibilityTriggered = false; // Track visibility state

  @override
  void initState() {
    super.initState();
    context.read<MatchBloc>().add(MatchUpdateEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MatchBloc, MatchState>(
      listener: (BuildContext context, MatchState state) {
        // if (state is MatchUpdateState) {
        //   WidgetsBinding.instance.addPostFrameCallback((t) {
        //     MatchBloc matchBloc = context.read<MatchBloc>();
        //     setState(() {
        //       footBallMatch = matchBloc.matches ?? [];
        //       selectedIndex = matchBloc.selectedIndex;
        //     });
        //   });
        // }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return VisibilityDetector(
          key: UniqueKey(),
          onVisibilityChanged: (visibilityInfo) {
            // Only trigger if visibility has changed significantly
            if (!isVisibilityTriggered &&
                visibilityInfo.visibleFraction > 0.1) {
              setState(() {
                isVisibilityTriggered = true;
              });
              context.read<MatchBloc>().add(MatchUpdateEvent());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child:
                (state.matches ?? []).isEmpty
                    ? SizedBox.shrink()
                    : Container(
                      child: Column(
                        children: [
                          Text(
                            "Period",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(color: ColorManager.grey),
                          ),
                          CompactPaginator(
                            initialPage: state.selectedIndex ?? 0,
                            maxPagesToShow: 6,
                            config: CompactPaginatorUiConfig(
                              navButtonPadding: EdgeInsets.zero,
                              pageNumberPadding: EdgeInsets.zero,
                              navIconSize: AppSize.s32,
                              pageNumberFontSize: AppSize.s18,
                            ),
                            totalPages: (state.matches ?? []).length,
                            onPageChanged: (int index) {
                              context.read<MatchBloc>().add(
                                MatchSelectEvent(index: index),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
