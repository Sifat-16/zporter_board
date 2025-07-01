import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zporter_board/core/common/components/slidable/custom_slidable.dart';
import 'package:zporter_board/core/common/components/z_loader.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_state.dart';

/// A widget that displays the list of notifications within the drawer.
///
/// It listens to the [NotificationBloc] and builds the UI based on the
/// current state.
class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading || state is NotificationInitial) {
          return const ZLoader(logoAssetPath: "assets/image/logo.png");
        }
        if (state is NotificationEmpty) {
          return const Center(
            child: Text(
              'You have no notifications.',
              style: TextStyle(color: ColorManager.grey),
            ),
          );
        }
        if (state is NotificationLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: state.notifications.length,
            separatorBuilder: (context, index) => const Divider(
              color: ColorManager.yellowLight,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return _NotificationTile(notification: notification);
            },
          );
        }
        if (state is NotificationError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: ColorManager.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// A widget representing a single notification item in the list.
class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return CustomSlidable(
      onDelete: () {
        context
            .read<NotificationBloc>()
            .add(DeleteNotification(notification.id));
      },
      child: ListTile(
        onTap: () {
          if (!notification.isRead) {
            context
                .read<NotificationBloc>()
                .add(MarkNotificationAsRead(notification.id));
          }
          // In a future update, this could navigate to a specific screen
          // based on the notification content.
        },
        leading: Icon(
          Icons.circle,
          color: notification.isRead ? Colors.transparent : ColorManager.yellow,
          size: 12,
        ),
        title: Text(
          notification.title,
          style: const TextStyle(
            color: ColorManager.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: const TextStyle(color: ColorManager.grey),
            ),
            const SizedBox(height: 8),
            Text(
              timeago.format(notification.sentTime),
              style: const TextStyle(color: ColorManager.grey, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.more_horiz,
          color: ColorManager.grey,
        ),
      ),
    );
  }
}
