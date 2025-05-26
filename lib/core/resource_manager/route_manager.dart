import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zporter_board/core/common/screen/page_under_construction_screen.dart';
import 'package:zporter_board/features/auth/presentation/view/auth_screen.dart';
import 'package:zporter_board/features/board/presentation/view/board_screen.dart';
import 'package:zporter_board/features/splash/presentation/view/splash_screen.dart';

class Routes {
  // AUTH ROUTES
  static const String auth = 'auth';

  static const String board = 'board';
}

class RouteGenerator {
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );
  late final GoRouter router;

  RouteGenerator() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      observers: [BotToastNavigatorObserver()],
      initialLocation: '/',
      errorBuilder: (context, state) {
        return PageUnderConstructionScreen(error: state.error.toString());
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: SplashScreen(key: state.pageKey)),
        ),
        GoRoute(
          name: Routes.auth,
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          name: Routes.board,
          path: '/board',
          builder: (context, state) => const BoardScreen(),
        ),
      ],
    );
  }

  // return router;
  Future<void> handleDeepLink(Uri uri) async {}

  // Getter for navigator key if needed elsewhere
  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
}
