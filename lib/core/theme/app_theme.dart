import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorManager.yellow,
    fontFamily: "Gilroy",
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Gilroy",
  );
}
