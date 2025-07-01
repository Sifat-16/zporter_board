import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/components/z_loader.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_state.dart';

/// A widget that displays the notification settings within the drawer.
///
/// It listens to the [NotificationSettingsBloc] to build a list of toggleable
/// settings for different notification categories.
class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  // A map to hold user-friendly names for each topic.
  static const Map<String, String> _topicDisplayNames = {
    'zporter_news': 'Zporter news and offerings',
    'app_updates': 'App news and updates',
    'pro_offers': 'Notifications in general', // As per the mockup
  };

  @override
  void initState() {
    super.initState();
    // Load the settings when the view is first created.
    context.read<NotificationSettingsBloc>().add(LoadNotificationSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
      builder: (context, state) {
        if (state is NotificationSettingsLoading ||
            state is NotificationSettingsInitial) {
          return const ZLoader(logoAssetPath: "assets/image/logo.png");
        }
        if (state is NotificationSettingsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: ColorManager.red),
            ),
          );
        }
        if (state is NotificationSettingsLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: state.settings.entries.map((entry) {
              final topic = entry.key;
              final isSubscribed = entry.value;
              final displayName = _topicDisplayNames[topic] ?? topic;

              return SwitchListTile(
                title: Text(
                  displayName,
                  style: const TextStyle(color: ColorManager.white),
                ),
                value: isSubscribed,
                onChanged: (newValue) {
                  context.read<NotificationSettingsBloc>().add(
                        ToggleSubscription(
                          topic: topic,
                          isSubscribed: newValue,
                        ),
                      );
                },
                activeColor: ColorManager.yellow,
                inactiveTrackColor: ColorManager.grey,
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
