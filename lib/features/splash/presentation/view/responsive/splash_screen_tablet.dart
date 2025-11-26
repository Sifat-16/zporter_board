import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zporter_board/config/version/version_info.dart';
import 'package:zporter_board/core/common/components/links/link_text.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/services/version_check_service.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';

class SplashScreenTablet extends StatefulWidget {
  const SplashScreenTablet({super.key});

  @override
  State<SplashScreenTablet> createState() => _SplashScreenTabletState();
}

class _SplashScreenTabletState extends State<SplashScreenTablet> {
  static const String _kOnboardingComplete = 'onboardingComplete';

  // --- ADDED: Create an instance of the service ---
  final _versionCheckService = VersionCheckService();

  Future<void> _handleAuthenticatedState(
      BuildContext context, AuthState state) async {
    if (state.status == AuthStatus.authenticated) {
      final userId = state.user?.uid ?? 'unknown_user';

      // The Manager now listens for a "yes" (true) or "no" (false) answer.
      final bool shouldStop = await _versionCheckService
          .performVersionCheck(context, userId: userId);

      // If the answer is "yes, stop!", the manager does nothing else.
      if (shouldStop) {
        return;
      }

      // Only if the answer is "no, continue!" does this code run.
      if (mounted) {
        _checkOnboardingStatusAndNavigate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          // --- MODIFIED: The listener now calls our new handler ---
          listener: _handleAuthenticatedState,
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.black,
        body: Padding(
          padding: const EdgeInsets.all(AppMargin.m12),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  // Assuming Image.asset is correct, was SvgPicture.asset
                  AssetsManager.splashLogo,
                  width: context.widthPercent(50),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: QrImageView(
                  data: AppInfo.zporter_url,
                  size: AppSize.s96,
                  backgroundColor: ColorManager.white,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildAppInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This method is now called *after* the version check
  void _checkOnboardingStatusAndNavigate() {
    final isOnboardingComplete =
        sl<SharedPreferences>().getBool(_kOnboardingComplete) ?? false;

    // The delay here might not be necessary anymore, but kept for consistency
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      if (isOnboardingComplete) {
        _navigateToBoard();
      } else {
        _navigateToOnboarding();
      }
    });
  }

  // --- All methods below are unchanged ---

  void _navigateToAuth() {
    if (kIsWeb) {
      if (mounted) GoRouter.of(context).goNamed(Routes.auth);
    } else {
      if (mounted) GoRouter.of(context).pushReplacementNamed(Routes.auth);
    }
  }

  void _navigateToBoard() {
    if (kIsWeb) {
      if (mounted) GoRouter.of(context).goNamed(Routes.board);
    } else {
      if (mounted) GoRouter.of(context).pushReplacementNamed(Routes.board);
    }
  }

  void _navigateToOnboarding() {
    // Assuming 'onBoarding' is your route name, was Routes.onBoarding
    final routeName = 'onBoarding';
    if (kIsWeb) {
      if (mounted) GoRouter.of(context).goNamed(routeName);
    } else {
      if (mounted) GoRouter.of(context).pushReplacementNamed(routeName);
    }
  }

  Widget _buildAppInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinkText(
          text: AppInfo.supportLinkName,
          url: AppInfo.supportLink,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: ColorManager.white),
        ),
        // --- CORRECTED: Replaced non-standard 'spacing' with SizedBox ---
        const SizedBox(height: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Version ${AppInfo.version}",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: ColorManager.white),
            ),
            // --- CORRECTED ---
            const SizedBox(height: 2),
            Text(
              "Last updated ${AppInfo.lastUpdated}",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: ColorManager.white),
            ),
          ],
        )
      ],
    );
  }
}
