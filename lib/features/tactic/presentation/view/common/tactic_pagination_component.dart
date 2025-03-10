import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_state.dart';

class TacticPaginationComponent extends StatefulWidget {
  const TacticPaginationComponent({super.key});

  @override
  State<TacticPaginationComponent> createState() => _TacticPaginationComponentState();
}

class _TacticPaginationComponentState extends State<TacticPaginationComponent> with AutomaticKeepAliveClientMixin {
  List<AnimationDataModel> animationDataModel = [];
  int selectedIndex = 0;
  bool isVisibilityTriggered = false; // Track visibility state

  @override
  void initState() {
    super.initState();
    context.read<MatchBloc>().add(MatchUpdateEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<AnimationBloc, AnimationState>(
      listener: (BuildContext context, AnimationState state) {
        if (state is AnimationUpdateState) {
          AnimationBloc animationBloc = context.read<AnimationBloc>();
          setState(() {
            animationDataModel = animationBloc.animationDataModel;
            selectedIndex = animationBloc.selectedIndex;
          });
        }
      },
      builder: (context, state) {
        if (state is! AnimationUpdateState) {
          return Center(child: CircularProgressIndicator());
        }

        return VisibilityDetector(
          key: UniqueKey(),
          onVisibilityChanged: (visibilityInfo) {
            // Only trigger if visibility has changed significantly
            if (!isVisibilityTriggered && visibilityInfo.visibleFraction > 0.1) {
              setState(() {
                isVisibilityTriggered = true;
              });
              context.read<AnimationBloc>().add(AnimationUpdateEvent());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: animationDataModel.isEmpty
                ? SizedBox.shrink()
                : NumberPaginator(
              numberPages: animationDataModel.length,
              initialPage: selectedIndex,
              onPageChange: (int index) {
                context.read<AnimationBloc>().add(AnimationSelectEvent(index: index));
              },
              prevButtonContent: Icon(
                Icons.chevron_left,
                color: ColorManager.grey,
                size: AppSize.s32,
              ),
              nextButtonContent: Icon(
                Icons.chevron_right,
                color: ColorManager.grey,
                size: AppSize.s32,
              ),
              config: NumberPaginatorUIConfig(
                buttonShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                buttonSelectedForegroundColor: ColorManager.yellow,
                buttonSelectedBackgroundColor: Colors.black,
                buttonUnselectedForegroundColor: ColorManager.grey,
                buttonUnselectedBackgroundColor: Colors.transparent,
                buttonTextStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.s28,
                ),
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
