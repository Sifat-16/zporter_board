import 'package:flutter/material.dart';
import 'package:zporter_board/core/utils/screen/responsive_screen_helper.dart';

extension ResponsiveScreenHelperExtension on BuildContext{
  bool get isMobile => ResponsiveScreenHelper().isMobile(this);
  bool get isTablet => ResponsiveScreenHelper().isTablet(this);
  bool get isDesktop => ResponsiveScreenHelper().isDesktop(this);
}