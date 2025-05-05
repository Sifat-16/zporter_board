import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';

import 'injection_container.dart';

class NavigationService {
  NavigationService._privateConstructor();
  static final NavigationService instance =
      NavigationService._privateConstructor();

  GlobalKey<NavigatorState> get key =>
      sl.get<RouteGenerator>().rootNavigatorKey;

  BuildContext? get currentContext => key.currentContext;
  NavigatorState? get currentState => key.currentState;
}
