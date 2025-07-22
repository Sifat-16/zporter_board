import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_tactical_board/presentation/admin/view/tutorials/video_viewer_dialog.dart';

/// A full-screen view to display notification details and a media gallery.
class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        title: Text(notification.title,
            style: const TextStyle(color: ColorManager.white)),
        backgroundColor: ColorManager.dark1,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Text Content ---
            Text(
              notification.title,
              style: const TextStyle(
                  color: ColorManager.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              timeago.format(notification.sentTime),
              style: const TextStyle(color: ColorManager.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              notification.body,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // --- Media Grid ---
            if (notification.mediaUrls?.isNotEmpty ?? false) ...[
              const Divider(color: ColorManager.grey),
              const SizedBox(height: 16),
              const Text(
                'Media',
                style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: notification.mediaUrls!.length,
                itemBuilder: (context, index) {
                  return _MediaItem(
                    url: notification.mediaUrls![index],
                    galleryItems: notification.mediaUrls!,
                    initialIndex: index,
                    // Pass the cover image to use as the video thumbnail
                    videoThumbnailUrl: notification.coverImageUrl,
                  );
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}

/// A widget that handles displaying either an image or a video.
class _MediaItem extends StatelessWidget {
  final String url;
  final List<String> galleryItems;
  final int initialIndex;
  final String? videoThumbnailUrl;

  const _MediaItem({
    super.key,
    required this.url,
    required this.galleryItems,
    required this.initialIndex,
    this.videoThumbnailUrl,
  });

  bool get _isVideo {
    final lowercasedUrl = url.toLowerCase();
    const videoExtensions = ['.mp4', '.mov', '.avi', 'mkv', '.webm', '.m3u8'];
    if (videoExtensions.any((ext) => lowercasedUrl.endsWith(ext))) return true;
    if (lowercasedUrl.contains('youtube.com') ||
        lowercasedUrl.contains('youtu.be')) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.dark1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: GestureDetector(
          onTap: () {
            if (_isVideo) {
              showDialog(
                context: context,
                builder: (_) => VideoViewerDialog(videoUrl: url),
              );
            } else {
              final imageItems = galleryItems.where((itemUrl) {
                final lowercasedUrl = itemUrl.toLowerCase();
                const videoExtensions = [
                  '.mp4',
                  '.mov',
                  '.avi',
                  'mkv',
                  '.webm',
                  '.m3u8'
                ];
                if (videoExtensions.any((ext) => lowercasedUrl.endsWith(ext)))
                  return false;
                if (lowercasedUrl.contains('youtube.com') ||
                    lowercasedUrl.contains('youtu.be')) return false;
                return true;
              }).toList();

              final correctIndex = imageItems.indexOf(url);
              if (correctIndex != -1) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => _FullScreenGalleryView(
                    galleryItems: imageItems,
                    initialIndex: correctIndex,
                  ),
                ));
              }
            }
          },
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              // Display the video thumbnail using the main cover image
              if (_isVideo)
                videoThumbnailUrl != null
                    ? CachedNetworkImage(
                        imageUrl: videoThumbnailUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.black54),
                      )
                    : Container(color: Colors.black54)
              // Display the actual image for image items
              else
                CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: ColorManager.red),
                ),
              // Show a play icon overlay for videos
              if (_isVideo)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A helper widget for a full-screen zoomable image gallery.
class _FullScreenGalleryView extends StatelessWidget {
  final List<String> galleryItems;
  final int initialIndex;

  const _FullScreenGalleryView(
      {super.key, required this.galleryItems, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: galleryItems.length,
            pageController: PageController(initialPage: initialIndex),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(galleryItems[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
