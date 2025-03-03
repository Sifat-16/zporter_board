import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class AppTheme {
  static TextTheme textTheme = TextTheme(
    displayLarge: _regularTextStyle, // Black (Gilroy Regular)
    displayMedium: _regularTextStyle, // ExtraBold (Gilroy Regular)
    displaySmall: _regularTextStyle, // Bold (Gilroy Regular)

    headlineLarge: _regularTextStyle, // SemiBold (Gilroy Regular)
    headlineMedium: _regularTextStyle, // Medium (Gilroy Regular)
    headlineSmall: _regularTextStyle, // Regular (Gilroy Regular)

    titleLarge: _regularTextStyle, // Bold (Gilroy Regular)
    titleMedium: _regularTextStyle, // SemiBold (Gilroy Regular)
    titleSmall: _regularTextStyle, // Medium (Gilroy Regular)

    bodyLarge: _regularTextStyle, // Regular (Gilroy Regular)
    bodyMedium: _regularTextStyle, // Light (Gilroy Regular)
    bodySmall: _regularTextStyle, // UltraLight (Gilroy Regular)

    labelLarge: _regularTextStyle, // Bold (Gilroy Regular)
    labelMedium: _regularTextStyle, // SemiBold (Gilroy Regular)
    labelSmall: _regularTextStyle, // Medium (Gilroy Regular)
  );

  static const TextStyle _regularTextStyle = TextStyle(fontFamily: 'Gilroy');

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorManager.yellow,
    textTheme: textTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    textTheme: textTheme,
  );
}