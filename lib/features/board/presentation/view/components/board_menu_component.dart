import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_bloc.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_event.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_state.dart';
import 'package:zporter_tactical_board/app/manager/values_manager.dart';

enum Screens { TACTICS, TIME, SCOREBOARD, SUBSTITUTION, ANALYTICS }

// Simple data class for menu items
class MenuItemData {
  final Screens screen;
  final IconData icon;
  final String label;
  // final bool isActive; // To determine styling

  MenuItemData({
    required this.screen,
    required this.icon,
    required this.label,
    // this.isActive = false,
  });
}

class BoardMenuComponent extends StatefulWidget {
  const BoardMenuComponent({super.key});

  @override
  State<BoardMenuComponent> createState() => _BoardMenuComponentState();
}

class _BoardMenuComponentState extends State<BoardMenuComponent> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  // --- Sample Menu Item Data ---
  final List<MenuItemData> _menuItems = [
    MenuItemData(
      screen: Screens.TACTICS,
      icon:
          Icons
              .developer_board, // Consider replacing with a more suitable icon if needed
      label: 'Tactics',
    ),
    MenuItemData(screen: Screens.TIME, icon: Icons.timer, label: 'Time'),
    MenuItemData(
      screen: Screens.SCOREBOARD,
      icon: Icons.scoreboard,
      label: 'Score',
    ),
    MenuItemData(
      screen: Screens.SUBSTITUTION,
      icon: Icons.people,
      label: 'Subs',
    ),
    MenuItemData(
      screen: Screens.ANALYTICS,
      icon: Icons.analytics,
      label: 'Analytics',
    ),
  ];
  // -----------------------------

  @override
  void dispose() {
    _closeMenu(); // Ensure overlay is removed on dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _toggleMenu() {
    // This function remains the same, toggling between open and close
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final overlay = Overlay.of(context); // Added null check for safety

    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final menuPosition = Offset(offset.dx, offset.dy + size.height + 5.0);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return BlocConsumer<BoardBloc, BoardState>(
          listener: (BuildContext context, BoardState state) {},

          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  left: menuPosition.dx,
                  top: menuPosition.dy,
                  width: 120,
                  child: Material(
                    color: ColorManager.black.withValues(alpha: 0.8),
                    elevation: 0,
                    borderRadius: BorderRadius.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                            _menuItems
                                .map((item) => _buildMenuItem(item, state))
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    overlay.insert(_overlayEntry!);
    // Update state AFTER inserting the overlay
    setState(() {
      _isMenuOpen = true;
    });
  }

  // Helper widget to build each menu item
  Widget _buildMenuItem(MenuItemData item, BoardState boardState) {
    final Color itemColor =
        boardState.selectedScreen == item.screen
            ? ColorManager.yellow
            : ColorManager.grey;
    final bool isActive = boardState.selectedScreen == item.screen;

    return InkWell(
      onTap: () {
        context.read<BoardBloc>().add(
          ScreenChangeEvent(selectedScreen: item.screen),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: isActive ? const EdgeInsets.all(4.0) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isActive ? ColorManager.yellow : Colors.transparent,
                borderRadius: BorderRadius.circular(isActive ? 4.0 : 0),
              ),
              child: Icon(
                item.icon,
                color:
                    isActive
                        ? ColorManager.white
                        : itemColor, // Adjusted active icon color
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: TextStyle(color: itemColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            if (isActive) ...[
              const SizedBox(height: 10),
              Divider(
                color: ColorManager.yellow,
                height: 1,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        _isMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Conditionally change the icon based on the menu state
    return IconButton(
      key: _buttonKey,
      icon: Icon(
        _isMenuOpen ? Icons.close : Icons.menu, // <<< CHANGE: Conditional icon
        color: ColorManager.white, // Use ColorManager for consistency
        size: AppSize.s32,
      ),
      tooltip: _isMenuOpen ? 'Close Menu' : 'Board Menu', // Dynamic tooltip
      onPressed: _toggleMenu,
    );
  }
}
