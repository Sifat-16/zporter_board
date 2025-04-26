import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';
import 'package:zporter_board/features/board/presentation/view/components/board_menu_component.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_bloc.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_state.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/scoreboard_screen.dart';
import 'package:zporter_board/features/substitute/presentation/view/substituteboard_screen.dart';
import 'package:zporter_board/features/time/presentation/view/timeboard_screen.dart';
import 'package:zporter_tactical_board/presentation/tactic/view/tacticboard_screen.dart';

class BoardScreenTablet extends StatefulWidget {
  const BoardScreenTablet({super.key});

  @override
  State<BoardScreenTablet> createState() => _BoardScreenTabletState();
}

class _BoardScreenTabletState extends State<BoardScreenTablet>
    with SingleTickerProviderStateMixin {
  Screens selectedScreen = Screens.TACTICS;
  String? userId;

  _resetApp() {
    setState(() {
      selectedScreen = Screens.TACTICS;
      userId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            // Optional: Only listen if the state changes significantly
            return previous != current;
          },
          listener: (context, state) {
            if (state is AuthStatusSuccess) {
              _resetApp();
              setState(() {
                userId = state.userEntity.uid;
              });
            } else if (state is LogoutState) {
              _resetApp();
            }
          },
        ),
        BlocListener<BoardBloc, BoardState>(
          listener: (context, state) {
            setState(() {
              selectedScreen = state.selectedScreen;
            });
          },
        ),
        // Add more BlocListeners here for other Blocs if needed
      ],
      child: SafeArea(
        top: selectedScreen != Screens.TACTICS,
        left: selectedScreen != Screens.TACTICS,
        bottom: selectedScreen != Screens.TACTICS,
        right: selectedScreen != Screens.TACTICS,
        child: Material(
          color: ColorManager.black,
          child: Stack(
            children: [
              Positioned.fill(child: _buildScreens(selectedScreen)),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Image.asset(
                      AssetsManager.logo,
                      height: AppSize.s56,
                      width: AppSize.s56,
                    ),
                    BoardMenuComponent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreens(Screens selectedScreen) {
    if (selectedScreen == Screens.TACTICS) {
      return TacticboardScreen(userId: userId ?? "TEST-MY_EDIT");
    } else if (selectedScreen == Screens.TIME) {
      return TimeboardScreen();
    } else if (selectedScreen == Screens.SCOREBOARD) {
      return ScoreBoardScreen();
    } else if (selectedScreen == Screens.SUBSTITUTION) {
      return SubstituteboardScreen();
    } else {
      return SettingsScreen();
    }
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return BlocConsumer<AuthBloc, AuthState>(
    //   builder: (context, state) {
    //     // return Center(
    //     //   child: TextButton(
    //     //     onPressed: () {
    //     //       context.read<AuthBloc>().add(LogoutEvent());
    //     //     },
    //     //     child: Text(
    //     //       "Logout",
    //     //       style: Theme.of(
    //     //         context,
    //     //       ).textTheme.labelLarge!.copyWith(color: ColorManager.white),
    //     //     ),
    //     //   ),
    //     // );
    //     if (state is AuthStatusSuccess || state is LogoutState) {
    //       String? email;
    //       if (state is AuthStatusSuccess) {
    //         email = state.userEntity.email;
    //       }
    //       if (email == null) {
    //         return Center(
    //           child: TextButton(
    //             onPressed: () {
    //               context.read<AuthBloc>().add(GoogleSignInEvent());
    //             },
    //             child: Text(
    //               "Login",
    //               style: Theme.of(
    //                 context,
    //               ).textTheme.labelLarge!.copyWith(color: ColorManager.white),
    //             ),
    //           ),
    //         );
    //       } else {
    //         return Center(
    //           child: TextButton(
    //             onPressed: () {
    //               context.read<AuthBloc>().add(LogoutEvent());
    //             },
    //             child: Text(
    //               "Logout",
    //               style: Theme.of(
    //                 context,
    //               ).textTheme.labelLarge!.copyWith(color: ColorManager.white),
    //             ),
    //           ),
    //         );
    //       }
    //     } else {
    //       return Center(
    //         child: TextButton(
    //           onPressed: () {
    //             context.read<AuthBloc>().add(LogoutEvent());
    //           },
    //           child: Text(
    //             "Logout",
    //             style: Theme.of(
    //               context,
    //             ).textTheme.labelLarge!.copyWith(color: ColorManager.white),
    //           ),
    //         ),
    //       );
    //     }
    //   },
    //   listener: (BuildContext context, AuthState state) {},
    // );
  }
}
