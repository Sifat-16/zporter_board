// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
// import 'package:zporter_board/features/notification/data/model/notification_model.dart';
// import 'package:zporter_tactical_board/presentation/admin/view/tutorials/video_viewer_dialog.dart';
//
// // Converted to a StatefulWidget to manage the state of the page indicator.
// class NotificationDetailScreen extends StatefulWidget {
//   final NotificationModel notification;
//
//   const NotificationDetailScreen({super.key, required this.notification});
//
//   @override
//   State<NotificationDetailScreen> createState() =>
//       _NotificationDetailScreenState();
// }
//
// class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
//   final _pageController = PageController();
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final hasMedia = widget.notification.mediaUrls?.isNotEmpty ?? false;
//
//     return Scaffold(
//       backgroundColor: ColorManager.black,
//       // The body now chooses which layout to build
//       body: hasMedia ? _buildMediaLayout() : _buildTextOnlyLayout(),
//     );
//   }
//
//   // NEW: A dedicated builder for the media-rich layout
//   Widget _buildMediaLayout() {
//     final mediaHeight = MediaQuery.of(context).size.width * 9 / 16;
//
//     return Stack(
//       children: [
//         CustomScrollView(
//           slivers: [
//             SliverList(
//               delegate: SliverChildListDelegate(
//                 [
//                   Stack(
//                     children: [
//                       SizedBox(
//                         height: mediaHeight,
//                         child: PageView.builder(
//                           controller: _pageController,
//                           itemCount: widget.notification.mediaUrls!.length,
//                           itemBuilder: (context, index) {
//                             return _MediaItem(
//                               url: widget.notification.mediaUrls![index],
//                               galleryItems: widget.notification.mediaUrls!,
//                               initialIndex: index,
//                               videoThumbnailUrl:
//                                   widget.notification.coverImageUrl,
//                             );
//                           },
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(0.8)
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                           child: Text(
//                             widget.notification.title,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 8,
//                         left: 0,
//                         right: 0,
//                         child: Center(
//                           child: SmoothPageIndicator(
//                             controller: _pageController,
//                             count: widget.notification.mediaUrls!.length,
//                             effect: const WormEffect(
//                               dotHeight: 8,
//                               dotWidth: 8,
//                               activeDotColor: Colors.white,
//                               dotColor: Colors.white54,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const CircleAvatar(
//                               backgroundColor: Colors.blue,
//                               radius: 4,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               '#${widget.notification.category}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(width: 12),
//                             Text(
//                               timeago.format(widget.notification.sentTime),
//                               style: const TextStyle(color: ColorManager.grey),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           widget.notification.body,
//                           style: const TextStyle(
//                               color: Colors.white70, fontSize: 16, height: 1.5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         _buildFloatingBackButton(),
//       ],
//     );
//   }
//
//   // NEW: A dedicated builder for the text-only layout
//   Widget _buildTextOnlyLayout() {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.notification.title,
//                 style: const TextStyle(
//                     color: ColorManager.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               // Text(
//               //   timeago.format(widget.notification.sentTime),
//               //   style: const TextStyle(color: ColorManager.grey, fontSize: 14),
//               // ),
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     backgroundColor: Colors.blue,
//                     radius: 4,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     '#${widget.notification.category}',
//                     style: const TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     timeago.format(widget.notification.sentTime),
//                     style: const TextStyle(color: ColorManager.grey),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Divider(color: ColorManager.grey),
//               const SizedBox(height: 24),
//               Text(
//                 widget.notification.body,
//                 style: const TextStyle(
//                     color: Colors.white70, fontSize: 16, height: 1.5),
//               ),
//             ],
//           ),
//         ),
//         _buildFloatingBackButton(),
//       ],
//     );
//   }
//
//   // NEW: Extracted the floating back button to be reusable
//   Widget _buildFloatingBackButton() {
//     return Positioned(
//       top: 40,
//       left: 16,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.4),
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//     );
//   }
// }
//
// // NOTE: The _MediaItem and _FullScreenGalleryView widgets below do not need any changes.
// // ... (Your existing _MediaItem and _FullScreenGalleryView widgets go here)
// class _MediaItem extends StatelessWidget {
//   final String url;
//   final List<String> galleryItems;
//   final int initialIndex;
//   final String? videoThumbnailUrl;
//
//   const _MediaItem({
//     super.key,
//     required this.url,
//     required this.galleryItems,
//     required this.initialIndex,
//     this.videoThumbnailUrl,
//   });
//
//   bool get _isVideo {
//     final lowercasedUrl = url.toLowerCase();
//     const videoExtensions = ['.mp4', '.mov', '.avi', 'mkv', '.webm', '.m3u8'];
//     if (videoExtensions.any((ext) => lowercasedUrl.endsWith(ext))) return true;
//     if (lowercasedUrl.contains('youtube.com') ||
//         lowercasedUrl.contains('youtu.be')) return true;
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (_isVideo) {
//           showDialog(
//             context: context,
//             builder: (_) => VideoViewerDialog(videoUrl: url),
//           );
//         } else {
//           final imageItems = galleryItems.where((itemUrl) {
//             final lowercasedUrl = itemUrl.toLowerCase();
//             const videoExtensions = [
//               '.mp4',
//               '.mov',
//               '.avi',
//               'mkv',
//               '.webm',
//               '.m3u8'
//             ];
//             if (videoExtensions.any((ext) => lowercasedUrl.endsWith(ext)))
//               return false;
//             if (lowercasedUrl.contains('youtube.com') ||
//                 lowercasedUrl.contains('youtu.be')) return false;
//             return true;
//           }).toList();
//
//           final correctIndex = imageItems.indexOf(url);
//           if (correctIndex != -1) {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (_) => _FullScreenGalleryView(
//                 galleryItems: imageItems,
//                 initialIndex: correctIndex,
//               ),
//             ));
//           }
//         }
//       },
//       child: Stack(
//         alignment: Alignment.center,
//         fit: StackFit.expand,
//         children: [
//           // Display the video thumbnail using the main cover image
//           if (_isVideo)
//             videoThumbnailUrl != null
//                 ? CachedNetworkImage(
//                     imageUrl: videoThumbnailUrl!,
//                     fit: BoxFit.cover, // Use cover for a full-bleed look
//                     errorWidget: (context, url, error) =>
//                         Container(color: Colors.black),
//                   )
//                 : Container(color: Colors.black)
//           // Display the actual image for image items
//           else
//             CachedNetworkImage(
//               imageUrl: url,
//               fit: BoxFit.cover, // Use cover for a full-bleed look
//               placeholder: (context, url) =>
//                   Container(color: ColorManager.dark1),
//               errorWidget: (context, url, error) =>
//                   const Icon(Icons.error, color: ColorManager.red),
//             ),
//           // Show a play icon overlay for videos
//           if (_isVideo)
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.play_arrow_rounded,
//                 color: Colors.white,
//                 size: 60,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class _FullScreenGalleryView extends StatelessWidget {
//   final List<String> galleryItems;
//   final int initialIndex;
//
//   const _FullScreenGalleryView(
//       {super.key, required this.galleryItems, required this.initialIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           PhotoViewGallery.builder(
//             itemCount: galleryItems.length,
//             pageController: PageController(initialPage: initialIndex),
//             builder: (context, index) {
//               return PhotoViewGalleryPageOptions(
//                 imageProvider: CachedNetworkImageProvider(galleryItems[index]),
//                 minScale: PhotoViewComputedScale.contained,
//                 maxScale: PhotoViewComputedScale.covered * 2,
//               );
//             },
//             backgroundDecoration: const BoxDecoration(color: Colors.black),
//           ),
//           Positioned(
//             top: 40,
//             right: 20,
//             child: IconButton(
//               icon: const Icon(Icons.close, color: Colors.white, size: 30),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/notification/data/model/notification_model.dart';
import 'package:zporter_tactical_board/presentation/admin/view/tutorials/video_viewer_dialog.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMedia = widget.notification.mediaUrls?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: hasMedia ? _buildMediaLayout() : _buildTextOnlyLayout(),
    );
  }

  Widget _buildMediaLayout() {
    final mediaHeight = MediaQuery.of(context).size.height * 0.8;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: [
                      SizedBox(
                        height: mediaHeight,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.notification.mediaUrls!.length,
                          itemBuilder: (context, index) {
                            return _MediaItem(
                              url: widget.notification.mediaUrls![index],
                              galleryItems: widget.notification.mediaUrls!,
                              initialIndex: index,
                              videoThumbnailUrl:
                                  widget.notification.coverImageUrl,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                // Colors.transparent,
                                Colors.black.withValues(alpha: 0.4),
                                Colors.black.withValues(alpha: 0.8)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            // color: ColorManager.black.withValues(alpha: 0.8)
                          ),
                          child: Text(
                            widget.notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: widget.notification.mediaUrls!.length,
                            effect: const WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: Colors.white,
                              dotColor: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Center(
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.9,
                        // constraints: const BoxConstraints(maxWidth: 800),
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: ColorManager.black,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 4,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '#${widget.notification.category}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  timeago.format(widget.notification.sentTime),
                                  style:
                                      const TextStyle(color: ColorManager.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.notification.body,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        _buildFloatingBackButton(),
      ],
    );
  }

  Widget _buildTextOnlyLayout() {
    return Stack(
      children: [
        Positioned(
          top: 60,
          left: 0,
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.9,
            // constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24.0),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                // color: const Color(0xFF1C1C1E),
                // borderRadius: BorderRadius.circular(12),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.notification.title,
                  style: const TextStyle(
                      color: ColorManager.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 4,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '#${widget.notification.category}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      timeago.format(widget.notification.sentTime),
                      style: const TextStyle(color: ColorManager.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.notification.body,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        _buildFloatingBackButton(),
      ],
    );
  }

  Widget _buildFloatingBackButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

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
    return GestureDetector(
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
          if (_isVideo)
            videoThumbnailUrl != null
                ? CachedNetworkImage(
                    imageUrl: videoThumbnailUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(color: Colors.black),
                  )
                : Container(color: Colors.black)
          else
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: ColorManager.dark1),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: ColorManager.red),
            ),
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
                  size: 60,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

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
