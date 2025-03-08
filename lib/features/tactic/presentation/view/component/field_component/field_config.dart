import 'dart:math';

import 'package:flutter/material.dart';

class FieldConfig {
  /// The space between the field external lines and the screen borders
  final double margins;

  // Thickness of the white lines used to draw the field
  final double strokeWidth;

  // The size of the corner arcs
  final double cornerWidth;

  // The diameter of the dots in the middle of the field and penalty disks
  // IDK if they're actually the same size, but they look like it
  final double pointsSize;

  // The size of the circle in the middle of the field
  final double midfieldCircleSize;

  // Width and height of the penalty area
  final Size penaltyAreaSize;

  // Position of the penalty spot
  final double penaltyY;

  // Width and height of the keeper area
  final Size keeperAreaSize;

  // We'll use these variables in the next articles
  final double playersSize;
  final double ballSize;

  FieldConfig.autosizedAreaFromHeight(
      {required this.margins,
        required this.strokeWidth,
        required this.cornerWidth,
        required this.pointsSize,
        required this.midfieldCircleSize,
        required this.playersSize,
        required this.ballSize,
        penaltyAreaHeight})
      : penaltyAreaSize = Size(penaltyAreaHeight * 3, penaltyAreaHeight),
        penaltyY = penaltyAreaHeight / 1.5,
        keeperAreaSize = Size(penaltyAreaHeight * 1.11, penaltyAreaHeight / 3);

  FieldConfig(
      {required this.margins,
        required this.strokeWidth,
        required this.cornerWidth,
        required this.pointsSize,
        required this.midfieldCircleSize,
        required this.playersSize,
        required this.ballSize,
        required this.penaltyAreaSize,
        required this.penaltyY,
        required this.keeperAreaSize});
}

final defaultFieldConfig = FieldConfig(
    margins: 14.0,
    strokeWidth: 2,
    cornerWidth: 20.0,
    penaltyAreaSize: const Size(210, 70),
    penaltyY: 50,
    keeperAreaSize: const Size(75, 25),
    midfieldCircleSize: 50.0,
    pointsSize: 4,
    playersSize: 40,
    ballSize: 25);

final defaultFieldMiniConfig = FieldConfig(
    margins: 1.40,
    strokeWidth: .2,
    cornerWidth: 2.0,
    penaltyAreaSize: const Size(21.0, 7.0),
    penaltyY: 5.0,
    keeperAreaSize: const Size(7.5, 2.5),
    midfieldCircleSize: 5.00,
    pointsSize: .4,
    playersSize: 4.0,
    ballSize: 2.5);

FieldConfig getDefaultFieldConfig() {
  return FieldConfig.autosizedAreaFromHeight(
      margins: 4.0,
      strokeWidth: 2,
      cornerWidth: 50.0,
      penaltyAreaHeight: 70.0,
      midfieldCircleSize: 50.0,
      pointsSize: 4,
      playersSize: 40,
      ballSize: 25);
}

FieldConfig getFieldConfig(Size fieldSize) {
  return FieldConfig.autosizedAreaFromHeight(
      margins: 4.0,
      strokeWidth: 2,
      cornerWidth: fieldSize.width / 14,
      penaltyAreaHeight: fieldSize.height / 6.36,
      midfieldCircleSize: fieldSize.width / 7.5,
      pointsSize: 4,
      playersSize: min(fieldSize.width, fieldSize.height) / 9.5,
      ballSize: min(fieldSize.width, fieldSize.height) / 15);
}