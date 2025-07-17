import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/dialog/confirmation_dialog.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/features/notification/presentation/view/notification_list_view.dart';
import 'package:zporter_board/features/notification/presentation/view/notification_settings_view.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_state.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_event.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

/// An enumeration to manage the two views within the drawer.
enum NotificationDrawerView { notifications, settings }

/// A widget that builds the entire end drawer for notifications.
///
/// It manages switching between the notification list and the settings page
/// and provides the necessary BLoCs to its children.
class NotificationDrawer extends StatefulWidget {
  const NotificationDrawer({super.key});

  @override
  State<NotificationDrawer> createState() => _NotificationDrawerState();
}

class _NotificationDrawerState extends State<NotificationDrawer> {
  // State to track the currently visible view.
  NotificationDrawerView _currentView = NotificationDrawerView.notifications;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    // When the drawer is opened, reset the unread count.
    context.read<UnreadCountBloc>().add(ResetUnreadCount());

    return Drawer(
      backgroundColor: ColorManager.black.withValues(alpha: 0.8),
      width: 360, // A fixed width suitable for a side panel on tablets.
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _currentView == NotificationDrawerView.notifications
                    ? const NotificationListView()
                    : const NotificationSettingsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // /// Builds the header of the drawer.
  // Widget _buildHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         // Back button (only visible in settings view)
  //         if (_currentView == NotificationDrawerView.settings)
  //           IconButton(
  //             icon: const Icon(Icons.arrow_back, color: ColorManager.white),
  //             onPressed: () => setState(() {
  //               _currentView = NotificationDrawerView.notifications;
  //             }),
  //           )
  //         else
  //           const SizedBox(width: 48), // Placeholder to keep title centered
  //
  //         Text(
  //           _currentView == NotificationDrawerView.notifications
  //               ? 'Notifications'
  //               : 'Settings',
  //           style: const TextStyle(
  //               color: ColorManager.white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold),
  //         ),
  //
  //         // Action buttons (Delete All / Settings)
  //         if (_currentView == NotificationDrawerView.notifications)
  //           Row(
  //             children: [
  //               // Delete All Button
  //               BlocBuilder<NotificationBloc, NotificationState>(
  //                 builder: (context, state) {
  //                   if (state is NotificationLoaded &&
  //                       state.notifications.isNotEmpty) {
  //                     return IconButton(
  //                       icon: const Icon(Icons.delete_sweep_outlined,
  //                           color: ColorManager.white),
  //                       onPressed: () async {
  //                         bool? delete = await showConfirmationDialog(
  //                             context: context,
  //                             title: "Delete Notification",
  //                             content:
  //                                 "Are you sure you want to delete all the notifications?");
  //                         if (delete == true) {
  //                           context
  //                               .read<NotificationBloc>()
  //                               .add(DeleteAllNotifications());
  //                         }
  //                       },
  //                     );
  //                   }
  //                   return const SizedBox.shrink();
  //                 },
  //               ),
  //               // Settings Button
  //               IconButton(
  //                 icon: const Icon(Icons.settings_outlined,
  //                     color: ColorManager.white),
  //                 onPressed: () => setState(() {
  //                   _currentView = NotificationDrawerView.settings;
  //                 }),
  //               ),
  //             ],
  //           )
  //         else
  //           const SizedBox(width: 48), // Placeholder
  //       ],
  //     ),
  //   );
  // }

  /// Builds the header of the drawer.
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (only visible in settings view)
          if (_currentView == NotificationDrawerView.settings)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorManager.white),
              onPressed: () => setState(() {
                _currentView = NotificationDrawerView.notifications;
              }),
            )
          else
            const SizedBox(width: 48), // Placeholder to keep title centered

          Text(
            _currentView == NotificationDrawerView.notifications
                ? 'Notifications'
                : 'Settings',
            style: const TextStyle(
                color: ColorManager.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),

          // Action buttons (Delete All / Settings / Close)
          if (_currentView == NotificationDrawerView.notifications)
            Row(
              children: [
                // Delete All Button
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoaded &&
                        state.notifications.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.delete_sweep_outlined,
                            color: ColorManager.white),
                        onPressed: () async {
                          bool? delete = await showConfirmationDialog(
                              context: context,
                              title: "Delete Notification",
                              content:
                                  "Are you sure you want to delete all the notifications?");
                          if (delete == true) {
                            context
                                .read<NotificationBloc>()
                                .add(DeleteAllNotifications());
                          }
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Settings Button
                IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: ColorManager.white),
                  onPressed: () => setState(() {
                    _currentView = NotificationDrawerView.settings;
                  }),
                ),
                // NEW: Close Drawer Button
                IconButton(
                  icon: const Icon(Icons.close, color: ColorManager.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Closes the drawer
                  },
                ),
              ],
            )
          else
            // NEW: Close Drawer Button (for settings view)
            IconButton(
              icon: const Icon(Icons.close, color: ColorManager.white),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the drawer
              },
            ),
        ],
      ),
    );
  }
}
