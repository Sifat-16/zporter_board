import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/dialog/confirmation_dialog.dart';
import 'package:zporter_board/core/common/components/z_loader.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';

class PeriodAddMatchDeleteComponent extends StatefulWidget {
  const PeriodAddMatchDeleteComponent({
    super.key,
    this.showAdd = true,
    this.showDelete = true,
  });
  final bool showAdd;
  final bool showDelete;

  @override
  State<PeriodAddMatchDeleteComponent> createState() =>
      _PeriodAddMatchDeleteComponentState();
}

class _PeriodAddMatchDeleteComponentState
    extends State<PeriodAddMatchDeleteComponent>
    with AutomaticKeepAliveClientMixin {
  // List<FootballMatch> footBallMatch = [];
  // int selectedIndex = 0;

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
          return Center(
            child: ZLoader(logoAssetPath: "assets/image/logo.png"),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Container(
            child: Row(
              spacing: 10,
              children: [
                if (widget.showAdd &&
                    (state.match?.matchPeriod.length ?? 0) < 9)
                  IconButton(
                    onPressed: () {
                      context.read<MatchBloc>().add(CreateNewPeriodEvent());
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: ColorManager.white,
                    ),
                  ),
                if (widget.showDelete)
                  IconButton(
                    onPressed: () async {
                      bool? confirmed = await showConfirmationDialog(
                        context: context,
                        title: "End Match?",
                        content:
                            "Are you sure you want to delete and end this match? Time, result and subs will be deleted!",
                      );
                      if (confirmed == true) {
                        context.read<MatchBloc>().add(DeleteMatchEvent());
                      }
                    },
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      color: ColorManager.white,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
