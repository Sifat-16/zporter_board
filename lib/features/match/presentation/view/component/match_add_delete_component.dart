import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_event.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_state.dart';
import 'package:zporter_tactical_board/app/core/dialogs/confirmation_dialog.dart';

class MatchAddDeleteComponent extends StatefulWidget {
  const MatchAddDeleteComponent({super.key});

  @override
  State<MatchAddDeleteComponent> createState() =>
      _MatchAddDeleteComponentState();
}

class _MatchAddDeleteComponentState extends State<MatchAddDeleteComponent>
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
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Container(
            child: Row(
              spacing: 10,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<MatchBloc>().add(CreateNewMatchEvent());
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: ColorManager.white,
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    bool? confirmed = await showConfirmationDialog(
                      context: context,
                      title: "Delete Match?",
                      content:
                          "This operation will delete the match data (score, time, substitution)",
                    );
                    if (confirmed == true) {
                      context.read<MatchBloc>().add(
                        DeleteMatchEvent(
                          matchId:
                              state.matches?[state.selectedIndex ?? 0].id ?? "",
                        ),
                      );
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
