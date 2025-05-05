import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
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
  UserIdService _userIdService = sl.get();

  bool isFullScreenTactics = false;

  _resetApp() {
    setState(() {
      selectedScreen = Screens.TACTICS;
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
              if (!isFullScreenTactics)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:
                        selectedScreen == Screens.TACTICS
                            ? EdgeInsets.only(
                              top: MediaQuery.paddingOf(context).top,
                            )
                            : EdgeInsets.zero,
                    child: BoardMenuComponent(),
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
      return TacticboardScreen(
        userId: _userIdService.getCurrentUserId(),
        onFullScreenChanged: (s) {
          setState(() {
            isFullScreenTactics = s;
          });
        },
      );
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
