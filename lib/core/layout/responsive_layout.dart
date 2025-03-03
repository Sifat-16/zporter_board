import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/responsive_screen_helper_extension.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.desktop, required this.mobile, required this.tablet});

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return switch(true){
      _ when context.isMobile => mobile,
      _ when context.isTablet => tablet,
      _ when context.isDesktop => desktop,
      _ => mobile
    };
  }
}
