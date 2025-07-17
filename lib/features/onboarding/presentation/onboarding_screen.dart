// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // --- ADJUST THESE IMPORTS TO MATCH YOUR PROJECT STRUCTURE ---
// import 'package:zporter_board/config/version/version_info.dart';
// import 'package:zporter_board/core/common/components/links/link_text.dart';
// import 'package:zporter_board/core/extension/size_extension.dart';
// import 'package:zporter_board/core/resource_manager/assets_manager.dart';
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
// import 'package:zporter_board/core/resource_manager/route_manager.dart';
// import 'package:zporter_board/core/resource_manager/values_manager.dart';
// import 'package:zporter_board/core/services/injection_container.dart';
//
// // --- IMPORTS FROM YOUR PROVIDED TUTORIAL SYSTEM ---
// import 'package:zporter_tactical_board/data/admin/model/tutorial_model.dart';
// import 'package:zporter_tactical_board/presentation/admin/view/tutorials/tutorial_selection_dialogue.dart';
// import 'package:zporter_tactical_board/presentation/admin/view/tutorials/tutorial_viewer_screen.dart';
// import 'package:zporter_tactical_board/presentation/admin/view/tutorials/video_viewer_dialog.dart';
// import 'package:zporter_tactical_board/presentation/admin/view_model/tutorials/tutorials_controller.dart';
// import 'package:zporter_tactical_board/presentation/admin/view_model/tutorials/tutorials_state.dart';
// // -----------------------------------------------------------
//
// class OnboardingScreen extends ConsumerStatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
//   late final ScrollController _scrollController;
//   bool _showLeftArrow = false;
//   bool _showRightArrow = false;
//
//   static const String _kOnboardingComplete = 'onboardingComplete';
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_updateArrowVisibility);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(tutorialsProvider.notifier).fetchTutorials();
//       _updateArrowVisibility();
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_updateArrowVisibility);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _updateArrowVisibility() {
//     if (!mounted ||
//         !_scrollController.hasClients ||
//         _scrollController.position.maxScrollExtent == 0) {
//       setState(() {
//         _showLeftArrow = false;
//         _showRightArrow = false;
//       });
//       return;
//     }
//
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.offset;
//
//     const scrollBuffer = 5.0;
//     final shouldShowLeft = currentScroll > scrollBuffer;
//     final shouldShowRight = currentScroll < (maxScroll - scrollBuffer);
//
//     if (shouldShowLeft != _showLeftArrow ||
//         shouldShowRight != _showRightArrow) {
//       setState(() {
//         _showLeftArrow = shouldShowLeft;
//         _showRightArrow = shouldShowRight;
//       });
//     }
//   }
//
//   void _showTutorialViewerDialog(BuildContext context, Tutorial tutorial) {
//     // showDialog(
//     //   context: context,
//     //   barrierDismissible: false,
//     //   builder: (BuildContext context) {
//     //     return TutorialViewerDialog(tutorial: tutorial);
//     //   },
//     // );
//
//     if (tutorial.tutorialType == TutorialType.video &&
//         tutorial.videoUrl != null) {
//       showDialog(
//         context: context,
//         builder: (context) => VideoViewerDialog(videoUrl: tutorial.videoUrl!),
//       );
//     } else {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return TutorialViewerDialog(tutorial: tutorial);
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ref.listen(tutorialsProvider.select((s) => s.tutorials.length), (_, __) {
//       WidgetsBinding.instance
//           .addPostFrameCallback((_) => _updateArrowVisibility());
//     });
//
//     return Scaffold(
//       backgroundColor: ColorManager.black,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           _buildBackgroundImage(),
//           _buildOverlay(),
//           _buildContent(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackgroundImage() {
//     return Image.asset(
//       AssetsManager.onboardingBackground,
//       fit: BoxFit.cover,
//     );
//   }
//
//   Widget _buildOverlay() {
//     return Container(
//       color: ColorManager.black.withOpacity(0.6),
//     );
//   }
//
//   Widget _buildContent(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: AppPadding.p24,
//         horizontal: AppPadding.p48,
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             child: _buildTutorialDialog(context),
//           ),
//           _buildFooter(context),
//         ],
//       ),
//     );
//   }
//
//   /// Builds the central dialog box for tutorial selection.
//   Widget _buildTutorialDialog(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final dialogWidth = screenWidth * 0.8;
//
//     return Center(
//       child: SizedBox(
//         width: dialogWidth,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Select Tutorial',
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     color: ColorManager.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: AppMargin.m40),
//             _buildTutorialCarousel(context, dialogWidth),
//
//             // --- NEW WIDGETS ADDED HERE ---
//             const SizedBox(height: AppMargin.m24),
//             _buildContinueButton(),
//             // ---------------------------------
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _navigateToBoard() {
//     GoRouter.of(context).goNamed(Routes.board);
//   }
//
//   // --- NEW METHOD TO BUILD THE BUTTON ---
//   Widget _buildContinueButton() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .05),
//       child: SizedBox(
//         width: double.infinity,
//         child: OutlinedButton(
//           onPressed: () async {
//             // 1. Use GetIt to access SharedPreferences and save the state.
//             await sl<SharedPreferences>().setBool(_kOnboardingComplete, true);
//
//             // 2. Navigate to the main board screen.
//             if (mounted) {
//               _navigateToBoard();
//             }
//           },
//           style: OutlinedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
//             side: BorderSide(color: ColorManager.green),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(AppSize.s8),
//             ),
//           ),
//           child: Text(
//             'Continue with Free',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: ColorManager.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
//   // ------------------------------------
//
//   Widget _buildTutorialCarousel(BuildContext context, double containerWidth) {
//     final state = ref.watch(tutorialsProvider);
//     final tutorials = state.tutorials;
//     final itemWidth = (containerWidth - 120) / 3;
//     final itemHeight = (itemWidth * (9 / 16)) + 40;
//
//     return Row(
//       children: [
//         if (_showLeftArrow)
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios,
//                 color: ColorManager.white, size: 30),
//             onPressed: () => _scrollController.animateTo(
//               _scrollController.offset - (itemWidth + 24),
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.easeInOut,
//             ),
//           )
//         else
//           const SizedBox(width: 48),
//         Expanded(
//           child: SizedBox(
//             height: itemHeight,
//             child: switch (state.status) {
//               TutorialStatus.loading when tutorials.isEmpty => const Center(
//                   child: CircularProgressIndicator(color: ColorManager.yellow),
//                 ),
//               TutorialStatus.error => Center(
//                   child: Text(
//                     state.errorMessage ?? 'Failed to load tutorials.',
//                     style: const TextStyle(color: ColorManager.red),
//                   ),
//                 ),
//               _ when tutorials.isEmpty => const Center(
//                   child: Text('No tutorials available.',
//                       style: TextStyle(color: ColorManager.grey)),
//                 ),
//               _ => ListView.builder(
//                   controller: _scrollController,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: tutorials.length,
//                   itemBuilder: (context, index) {
//                     final tutorial = tutorials[index];
//                     return Container(
//                       width: itemWidth,
//                       margin: const EdgeInsets.symmetric(horizontal: 12.0),
//                       // child: _TutorialCard(
//                       //   tutorial: tutorial,
//                       //   onTap: () =>
//                       //       _showTutorialViewerDialog(context, tutorial),
//                       // ),
//                       child: TutorialCard(
//                           tutorial: tutorial,
//                           onTap: () =>
//                               _showTutorialViewerDialog(context, tutorial),
//                           isSelected: false),
//                     );
//                   },
//                 ),
//             },
//           ),
//         ),
//         if (_showRightArrow)
//           IconButton(
//             icon: const Icon(Icons.arrow_forward_ios,
//                 color: ColorManager.white, size: 30),
//             onPressed: () => _scrollController.animateTo(
//               _scrollController.offset + (itemWidth + 24),
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.easeInOut,
//             ),
//           )
//         else
//           const SizedBox(width: 48),
//       ],
//     );
//   }
//
//   Widget _buildFooter(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         _buildAppInfo(context),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
//           // child: Image.asset(
//           //   AssetsManager.splashLogo,
//           //   height: AppSize.s40,
//           // ),
//           child: Image.asset(
//             AssetsManager.splashLogo,
//             width: context.widthPercent(25),
//           ),
//         ),
//         QrImageView(
//           data: AppInfo.zporter_url,
//           size: AppSize.s96,
//           backgroundColor: ColorManager.white,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAppInfo(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LinkText(
//           text: AppInfo.supportLinkName,
//           url: AppInfo.supportLink,
//           style: Theme.of(context)
//               .textTheme
//               .labelMedium!
//               .copyWith(color: ColorManager.white),
//         ),
//         const SizedBox(height: AppMargin.m12),
//         Text(
//           "Version ${AppInfo.version}",
//           style: Theme.of(context)
//               .textTheme
//               .labelSmall!
//               .copyWith(color: ColorManager.white),
//         ),
//         Text(
//           "Last updated ${AppInfo.lastUpdated}",
//           style: Theme.of(context)
//               .textTheme
//               .labelSmall!
//               .copyWith(color: ColorManager.white),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- YOUR PROJECT IMPORTS ---
import 'package:zporter_board/config/version/version_info.dart';
import 'package:zporter_board/core/common/components/links/link_text.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_tactical_board/data/admin/model/tutorial_model.dart';
import 'package:zporter_tactical_board/presentation/admin/view/tutorials/tutorial_selection_dialogue.dart';
import 'package:zporter_tactical_board/presentation/admin/view/tutorials/tutorial_viewer_screen.dart';
import 'package:zporter_tactical_board/presentation/admin/view/tutorials/video_viewer_dialog.dart';
import 'package:zporter_tactical_board/presentation/admin/view_model/tutorials/tutorials_controller.dart';
import 'package:zporter_tactical_board/presentation/admin/view_model/tutorials/tutorials_state.dart';
// -----------------------------------------------------------

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final ScrollController _scrollController;
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  static const String _kOnboardingComplete = 'onboardingComplete';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateArrowVisibility);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tutorialsProvider.notifier).fetchTutorials();
      _updateArrowVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowVisibility() {
    if (!mounted ||
        !_scrollController.hasClients ||
        _scrollController.position.maxScrollExtent == 0) {
      if (_showLeftArrow || _showRightArrow) {
        setState(() {
          _showLeftArrow = false;
          _showRightArrow = false;
        });
      }
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    const scrollBuffer = 5.0;

    final shouldShowLeft = currentScroll > scrollBuffer;
    final shouldShowRight = currentScroll < (maxScroll - scrollBuffer);

    if (shouldShowLeft != _showLeftArrow ||
        shouldShowRight != _showRightArrow) {
      setState(() {
        _showLeftArrow = shouldShowLeft;
        _showRightArrow = shouldShowRight;
      });
    }
  }

  void _showTutorialViewerDialog(BuildContext context, Tutorial tutorial) {
    if (tutorial.tutorialType == TutorialType.video &&
        tutorial.videoUrl != null) {
      showDialog(
        context: context,
        builder: (context) => VideoViewerDialog(videoUrl: tutorial.videoUrl!),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TutorialViewerDialog(tutorial: tutorial);
        },
      );
    }
  }

  void _navigateToBoard() {
    if (mounted) {
      GoRouter.of(context).goNamed(Routes.board);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tutorialsProvider.select((s) => s.tutorials.length), (_, __) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _updateArrowVisibility());
    });

    return Scaffold(
      backgroundColor: ColorManager.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildOverlay(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      AssetsManager.onboardingBackground,
      fit: BoxFit.cover,
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: ColorManager.black.withOpacity(0.6),
    );
  }

  /// ✅ [FINAL VERSION] Implements the user's requested percentage-based height partitioning.
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p48),
      child: Column(
        children: [
          // The main dialog area is given 85% of the screen height.
          SizedBox(
            height: context.heightPercent(85),
            child: _buildTutorialDialog(context),
          ),
          // The footer area is given the remaining 15% of the screen height.
          SizedBox(
            height: context.heightPercent(15),
            // Padding is applied inside to vertically center the footer content.
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
              child: _buildFooter(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialDialog(BuildContext context) {
    final dialogWidth = context.screenWidth * 0.8;

    return Center(
      child: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Tutorial',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ColorManager.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppMargin.m40),
            _buildTutorialCarousel(context, dialogWidth),
            const SizedBox(height: AppMargin.m24),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .05),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            await sl<SharedPreferences>().setBool(_kOnboardingComplete, true);
            _navigateToBoard();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
            side: BorderSide(color: ColorManager.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8),
            ),
          ),
          child: Text(
            'Continue with Free',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialCarousel(BuildContext context, double containerWidth) {
    final state = ref.watch(tutorialsProvider);
    final tutorials = state.tutorials;
    final itemWidth = (containerWidth - 120) / 3;
    final itemHeight = (itemWidth * (9 / 16)) + 40;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_showLeftArrow)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: ColorManager.white, size: 30),
            onPressed: () => _scrollController.animateTo(
              _scrollController.offset - (itemWidth + 24),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            ),
          )
        else
          const SizedBox(width: 48),
        Expanded(
          child: SizedBox(
            height: itemHeight,
            child: switch (state.status) {
              TutorialStatus.loading when tutorials.isEmpty => const Center(
                  child: CircularProgressIndicator(color: ColorManager.yellow),
                ),
              TutorialStatus.error => Center(
                  child: Text(
                    state.errorMessage ?? 'Failed to load tutorials.',
                    style: const TextStyle(color: ColorManager.red),
                  ),
                ),
              _ when tutorials.isEmpty => const Center(
                  child: Text('No tutorials available.',
                      style: TextStyle(color: ColorManager.grey)),
                ),
              _ => ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: tutorials.length,
                  itemBuilder: (context, index) {
                    final tutorial = tutorials[index];
                    return Container(
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TutorialCard(
                        tutorial: tutorial,
                        onTap: () =>
                            _showTutorialViewerDialog(context, tutorial),
                        isSelected: false,
                      ),
                    );
                  },
                ),
            },
          ),
        ),
        if (_showRightArrow)
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: ColorManager.white, size: 30),
            onPressed: () => _scrollController.animateTo(
              _scrollController.offset + (itemWidth + 24),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            ),
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAppInfo(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: Image.asset(
            AssetsManager.splashLogo,
            width: context.widthPercent(25),
          ),
        ),
        QrImageView(
          data: AppInfo.zporter_url,
          size: AppSize.s96,
          backgroundColor: ColorManager.white,
        ),
      ],
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinkText(
          text: AppInfo.supportLinkName,
          url: AppInfo.supportLink,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: ColorManager.white),
        ),
        const SizedBox(height: AppMargin.m12),
        Text(
          "Version ${AppInfo.version}",
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: ColorManager.white),
        ),
        Text(
          "Last updated ${AppInfo.lastUpdated}",
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: ColorManager.white),
        ),
      ],
    );
  }
}
