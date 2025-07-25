import 'dart:async';

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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // // THE FIX: A stream to send events from services to the UI
  // final StreamController<void> _openDrawerController =
  //     StreamController.broadcast();
  // Stream<void> get openDrawerStream => _openDrawerController.stream;
  //
  // // Call this from a service to signal the UI
  // void openDrawer() {
  //   _openDrawerController.add(null);
  // }
  //
  // // It's good practice to close the stream controller when it's no longer needed
  // void dispose() {
  //   _openDrawerController.close();
  // }
}
