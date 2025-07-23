import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zporter_board/core/common/components/slidable/custom_slidable.dart';
import 'package:zporter_board/core/common/components/z_loader.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_board/features/notification/presentation/view/notification_detail_screen.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_event.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_state.dart';
import 'package:zporter_tactical_board/app/core/dialogs/confirmation_dialog.dart';

/// A widget that displays the list of notifications within the drawer.
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
            separatorBuilder: (context, index) => Divider(
              color: ColorManager.white.withOpacity(0.15),
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
      onDelete: () async {
        bool? delete = await showConfirmationDialog(
            context: context,
            title: "Delete Notification",
            content: "Are you sure you want to delete this notification?");
        if (delete == true) {
          context
              .read<NotificationBloc>()
              .add(DeleteNotification(notification.id));
        }
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        onTap: () {
          if (!notification.isRead) {
            context
                .read<NotificationBloc>()
                .add(MarkNotificationAsRead(notification.id));
          }
          // Navigate to the new detail screen instead of showing a dialog
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                NotificationDetailScreen(notification: notification),
          ));
        },
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: notification.coverImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: notification.coverImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: ColorManager.grey.withOpacity(0.3)),
                    errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        color: ColorManager.grey),
                  )
                : Container(
                    color: ColorManager.grey.withOpacity(0.3),
                    child: const Icon(Icons.notifications,
                        color: ColorManager.grey),
                  ),
          ),
        ),
        title: Text(
          notification.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: ColorManager.grey),
            ),
            const SizedBox(height: 8),
            Text(
              timeago.format(notification.sentTime),
              style: const TextStyle(color: ColorManager.grey, fontSize: 12),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? const Icon(
                Icons.circle,
                color: ColorManager.yellow,
                size: 12,
              )
            : null,
      ),
    );
  }
}
