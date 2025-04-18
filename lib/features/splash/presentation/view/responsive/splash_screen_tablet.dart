import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';

class SplashScreenTablet extends StatefulWidget {
  const SplashScreenTablet({super.key});

  @override
  State<SplashScreenTablet> createState() => _SplashScreenTabletState();
}

class _SplashScreenTabletState extends State<SplashScreenTablet> {
  final String _zporter_url = "https://onelink.to/zporter";

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStatusFailure) {
              Future.delayed(Duration(seconds: 2), () {
                // _navigateToBoard();
                // _navigateToAuth();
                _guestLogin();
              });
            } else if (state is AuthStatusSuccess) {
              Future.delayed(Duration(seconds: 1), () {
                _navigateToBoard();
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.black,
        body: Padding(
          padding: const EdgeInsets.all(AppMargin.m12),
          child: Stack(
            children: [
              Center(
                child: SvgPicture.asset(
                  AssetsManager.splashLogo,
                  width: context.widthPercent(50),
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: QrImageView(
                  data: _zporter_url,
                  size: AppSize.s96,
                  backgroundColor: ColorManager.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAuth() {
    if (kIsWeb) {
      if (mounted) {
        GoRouter.of(context).goNamed(Routes.auth);
      }
    } else {
      if (mounted) {
        GoRouter.of(context).pushReplacementNamed(Routes.auth);
      }
    }
  }

  void _navigateToBoard() {
    if (kIsWeb) {
      if (mounted) {
        GoRouter.of(context).goNamed(Routes.board);
      }
    } else {
      if (mounted) {
        GoRouter.of(context).pushReplacementNamed(Routes.board);
      }
    }
  }

  void _guestLogin() {
    context.read<AuthBloc>().add(GuestLoginEvent());
  }
}
