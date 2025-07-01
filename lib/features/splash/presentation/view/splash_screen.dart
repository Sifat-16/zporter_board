import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/splash/presentation/view/responsive/splash_screen_tablet.dart';

class SplashScreen extends ResponsiveScreen {
  const SplashScreen({super.key});

  @override
  Widget buildDesktop(BuildContext context) {
    return SplashScreenTablet();
  }

  @override
  Widget buildMobile(BuildContext context) {
    return SplashScreenTablet();
  }

  @override
  Widget buildTablet(BuildContext context) {
    return SplashScreenTablet();
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ResponsiveScreenState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1.5, -1.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));
    // context.read<AuthBloc>().add(AuthStatusEvent());

    // MODIFIED: Dispatch the new AppOpened event to start the auth flow.
    context.read<AuthBloc>().add(AppOpened());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
