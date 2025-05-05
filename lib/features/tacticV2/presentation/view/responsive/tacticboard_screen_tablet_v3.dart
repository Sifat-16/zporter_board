import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';
import 'package:zporter_tactical_board/tactic_page.dart';

class TacticboardScreenTabletV3 extends StatefulWidget {
  const TacticboardScreenTabletV3({super.key});

  @override
  State<TacticboardScreenTabletV3> createState() =>
      _TacticboardScreenTabletV3State();
}

class _TacticboardScreenTabletV3State extends State<TacticboardScreenTabletV3> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {},
      builder: (context, state) {
        if (state is AuthStatusSuccess) {
          zlog(data: "User id found for the tactics ${state.userEntity.uid}");
          return TacticPage(userId: state.userEntity.uid);
        } else {
          return Center(
            child: Text(
              "No User Found!!!",
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(color: ColorManager.white),
            ),
          );
        }
      },
    );
  }
}
