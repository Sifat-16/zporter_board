// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:zporter_board/core/extension/size_extension.dart';
// import 'package:zporter_board/core/resource_manager/assets_manager.dart';
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
// import 'package:zporter_board/core/resource_manager/route_manager.dart';
// import 'package:zporter_board/core/resource_manager/values_manager.dart';
//
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with WidgetsBindingObserver, SingleTickerProviderStateMixin {
//
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 0),
//       end: const Offset(1.5, -1.5),
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutExpo,
//       ),
//     );
//   }
//
//   void _navigateToAuth() {
//     if (kIsWeb) {
//       if (mounted) {
//         GoRouter.of(context).goNamed(Routes.auth);
//       }
//     } else {
//       if (mounted) {
//         GoRouter.of(context).pushReplacementNamed(Routes.auth);
//       }
//     }
//   }
//
//   void _navigateToBoard() async {
//
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
//
// }

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zporter_board/core/common/screen/responsive_screen.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/splash/presentation/view/responsive/splash_screen_desktop.dart';
import 'package:zporter_board/features/splash/presentation/view/responsive/splash_screen_mobile.dart';
import 'package:zporter_board/features/splash/presentation/view/responsive/splash_screen_tablet.dart';

class SplashScreen extends ResponsiveScreen{
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

class _SplashScreenState extends ResponsiveScreenState<SplashScreen> with SingleTickerProviderStateMixin{

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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );
    context.read<AuthBloc>().add(AuthStatusEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


}