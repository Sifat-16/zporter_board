import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/patch/ota_service.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart'; // For AssetsManager
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';
import 'package:zporter_board/features/board/presentation/view/components/board_menu_component.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_bloc.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_event.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_state.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/scoreboard_screen.dart';
import 'package:zporter_board/features/substitute/presentation/view/substituteboard_screen.dart';
import 'package:zporter_board/features/time/presentation/view/timeboard_screen.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';
import 'package:zporter_tactical_board/presentation/tactic/view/tacticboard_screen.dart';

class BoardScreenTablet extends StatefulWidget {
  const BoardScreenTablet({super.key});

  @override
  State<BoardScreenTablet> createState() => _BoardScreenTabletState();
}

class _BoardScreenTabletState extends State<BoardScreenTablet>
    with SingleTickerProviderStateMixin {
  Screens selectedScreen = Screens.TACTICS; // Initial default screen
  final UserIdService _userIdService = sl.get();
  bool isFullScreenTactics = false;

  late TabController _tabController;

  // Moved _menuItems here from BoardMenuComponent
  final List<MenuItemData> _menuItems = [
    MenuItemData(
      screen: Screens.TACTICS,
      image: AssetsManager.soccer_field,
      label: 'Tactics',
    ),
    MenuItemData(
      screen: Screens.TIME,
      image: AssetsManager.digital_clock,
      label: 'Time',
    ),
    MenuItemData(
      screen: Screens.SCOREBOARD,
      icon: Icons.scoreboard_outlined, // Using outlined version for consistency
      label: 'Score',
    ),
    MenuItemData(
      screen: Screens.SUBSTITUTION,
      image: AssetsManager.substitute_player,
      label: 'Subs',
    ),
    // MenuItemData(
    //   screen: Screens.ANALYTICS,
    //   icon: Icons.analytics_outlined, // Using outlined version
    //   label: 'Analytics',
    // ),
  ];

  @override
  void initState() {
    super.initState();

    int initialIndex = _menuItems.indexWhere(
      (item) => item.screen == selectedScreen,
    );
    if (initialIndex == -1) {
      initialIndex =
          0; // Default to the first tab if current selectedScreen isn't found
      selectedScreen =
          _menuItems[0].screen; // Sync selectedScreen with the default tab
    }

    _tabController = TabController(
      length: _menuItems.length,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      // Check if the controller's index is driven by a tap (i.e., index is finalized)
      // and not still animating, and if the selected screen actually changed.
      if (!_tabController.indexIsChanging &&
          _menuItems[_tabController.index].screen != selectedScreen) {
        final newScreen = _menuItems[_tabController.index].screen;
        context.read<BoardBloc>().add(
              ScreenChangeEvent(selectedScreen: newScreen),
            );
      }
    });

    // If BoardBloc might initialize with a different screen, ensure UI consistency
    // This is often handled by BlocListener reacting to initial state too.
    final initialBoardState = context.read<BoardBloc>().state;
    if (initialBoardState.selectedScreen != selectedScreen) {
      _updateScreenAndTab(initialBoardState.selectedScreen);
    }

    WidgetsBinding.instance.addPostFrameCallback((t) {
      try {
        OTAService.checkForUpdates();
      } catch (e) {
        zlog(data: "Trued to show snakcbad $e");
      }
    });
  }

  void _updateScreenAndTab(Screens newScreen) {
    setState(() {
      selectedScreen = newScreen;
    });
    final newIndex = _menuItems.indexWhere((item) => item.screen == newScreen);
    if (newIndex != -1 && _tabController.index != newIndex) {
      _tabController.animateTo(newIndex);
    }
  }

  _resetApp() {
    // This will trigger the BoardBloc listener which should update the TabController
    // Or directly update the tab controller as well for immediate UI consistency.
    _updateScreenAndTab(Screens.TACTICS);
    // Optionally, if BoardBloc event is preferred to drive the change fully:
    // context.read<BoardBloc>().add(const ScreenChangeEvent(selectedScreen: Screens.TACTICS));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildScreens(Screens currentScreen) {
    if (currentScreen == Screens.TACTICS) {
      return TacticboardScreen(
        userId: _userIdService.getCurrentUserId(),
        onFullScreenChanged: (isFull) {
          if (mounted) {
            setState(() {
              isFullScreenTactics = isFull;
            });
          }
        },
      );
    } else if (currentScreen == Screens.TIME) {
      return TimeboardScreen();
    } else if (currentScreen == Screens.SCOREBOARD) {
      return ScoreBoardScreen();
    } else if (currentScreen == Screens.SUBSTITUTION) {
      return SubstituteboardScreen();
    } else if (currentScreen == Screens.ANALYTICS) {
      // Assuming SettingsScreen is the placeholder for Analytics for now
      return const SettingsScreen(); // Or your actual AnalyticsScreen
    }
    // Default case, though Screens.ANALYTICS should cover the last item
    return const SettingsScreen();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = context.screenHeight;
    final double topPadding = context.padding.top;
    final double tabBarHeight = screenHeight * 0.08;
    final double actualTabBarContentHeight = tabBarHeight - topPadding;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStatusSuccess || state is LogoutState) {
              _resetApp();
            }
          },
        ),
        BlocListener<BoardBloc, BoardState>(
          listener: (context, state) {
            // Update local state and TabController when BoardBloc's selectedScreen changes
            if (selectedScreen != state.selectedScreen) {
              _updateScreenAndTab(state.selectedScreen);
            }
          },
        ),
      ],
      child: _buildPageContent(
        context,
        tabBarHeight,
        topPadding,
        actualTabBarContentHeight,
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    double tabBarHeight,
    double topPadding,
    double actualTabBarContentHeight,
  ) {
    Widget screenDisplayWidget = _buildScreens(selectedScreen);

    // Full screen mode for tactics
    // if (isFullScreenTactics && selectedScreen == Screens.TACTICS) {
    //   return Material(
    //     color: ColorManager.black,
    //     child:
    //         screenDisplayWidget, // TacticboardScreen handles its own layout fully
    //   );
    // }

    // Standard layout with TabBar
    return Material(
      color: ColorManager.black,
      child: Stack(
        children: [
          // TabBar Container
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: tabBarHeight,
              padding: EdgeInsets.only(top: topPadding),
              // width: double.infinity,
              color: ColorManager
                  .transparent, // Or another distinct tab bar background
              child: Center(
                child: TabBar(
                  controller: _tabController,
                  isScrollable:
                      false, // Fit all tabs if possible, adjust if too many
                  tabAlignment: TabAlignment.center, // Requires Flutter 3.13+
                  indicatorColor: ColorManager.yellow,
                  indicatorWeight: 3.0,
                  dividerColor: ColorManager.transparent,

                  labelColor: ColorManager.yellow,
                  unselectedLabelColor: ColorManager.grey,
                  labelStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
                  tabs: _menuItems.map((item) {
                    final bool isActive = selectedScreen == item.screen;
                    final Color iconColor =
                        isActive ? ColorManager.yellow : ColorManager.grey;

                    return Tab(
                      height: actualTabBarContentHeight > 0
                          ? actualTabBarContentHeight
                          : null, // Ensure tab fits within allocated space
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Content Area
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: screenDisplayWidget is! TacticboardScreen
                  ? context.screenHeight * .92
                  : null,
              child: screenDisplayWidget,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for SettingsScreen (used for Analytics in this example)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.black,
      alignment: Alignment.center,
      child: const Text(
        'Analytics / Settings Screen',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
