import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';

import 'field_config.dart';
import '../../../../data/model/field_draggable_item.dart';

class FieldPainter extends CustomPainter {
  FieldPainter({required this.config, required this.items});

  FieldConfig config;
  List<FieldDraggableItem> items; // Add items list


  // We'll use just one paint for all the drawings
  final Paint fieldPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // Let's paint the field background. For now, we'll just use a green color
    fieldPaint.color = ColorManager.grey;
    fieldPaint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), fieldPaint);

    // LFrom now on, we'll just use white lines

    fieldPaint.color = ColorManager.black;
    fieldPaint.style = PaintingStyle.stroke;
    fieldPaint.strokeWidth = config.strokeWidth;

    // The margins must be subtracted from the available size
    final Rect field = Rect.fromLTRB(config.margins, config.margins,
        size.width - config.margins, size.height - config.margins);

    // From now on, we'll use the field to determine the available space, since we already subtracted the margins
    drawBorders(canvas, field);
    drawMidline(canvas, field);
    drawCorners(canvas, field);
    drawPenaltyArea(canvas, field);

    // Draw players based on their offsets
    // drawPlayers(canvas, field);
    drawArrowHeadLines(canvas);
  }

  void drawBorders(Canvas canvas, Rect field) {
    Path path = Path();
    path.addRect(field);


    canvas.drawPath(path, fieldPaint);
  }

  void drawMidline(Canvas canvas, Rect field) {
    canvas.drawLine(field.centerLeft, field.centerRight, fieldPaint);
    canvas.drawCircle(field.center, config.midfieldCircleSize, fieldPaint);
    fieldPaint.style = PaintingStyle.fill;
    canvas.drawCircle(field.center, config.pointsSize, fieldPaint);
  }

  void drawCorners(Canvas canvas, Rect field) {
    fieldPaint.style = PaintingStyle.stroke;
    canvas.drawArc(
        Rect.fromCenter(
            center: field.topLeft,
            width: config.cornerWidth,
            height: config.cornerWidth),
        pi / 2,
        -pi / 2,
        false,
        fieldPaint);
    canvas.drawArc(
        Rect.fromCenter(
            center: field.topRight,
            width: config.cornerWidth,
            height: config.cornerWidth),
        pi,
        -pi / 2,
        false,
        fieldPaint);
    canvas.drawArc(
        Rect.fromCenter(
            center: field.bottomLeft,
            width: config.cornerWidth,
            height: config.cornerWidth),
        0,
        -pi / 2,
        false,
        fieldPaint);
    canvas.drawArc(
        Rect.fromCenter(
            center: field.bottomRight,
            width: config.cornerWidth,
            height: config.cornerWidth),
        -pi / 2,
        -pi / 2,
        false,
        fieldPaint);
  }

  void drawPenaltyArea(Canvas canvas, Rect field) {
    drawAreas(canvas, field, config.penaltyAreaSize.width,
        config.penaltyAreaSize.height);
    drawAreas(canvas, field, config.keeperAreaSize.width,
        config.keeperAreaSize.height); // Keeper area
    drawPenalties(canvas, field);
  }

  void drawAreas(Canvas canvas, Rect field, double width, double height) {
    final halfWidth = width / 2;
    Path path = Path();
    path.moveTo(field.center.dx - halfWidth, field.top);
    path.lineTo(field.center.dx - halfWidth, field.top + height);
    path.lineTo(field.center.dx + halfWidth, field.top + height);
    path.lineTo(field.center.dx + halfWidth, field.top);
    canvas.drawPath(path, fieldPaint);

    path = Path();
    path.moveTo(field.center.dx - halfWidth, field.bottom);
    path.lineTo(field.center.dx - halfWidth, field.bottom - height);
    path.lineTo(field.center.dx + halfWidth, field.bottom - height);
    path.lineTo(field.center.dx + halfWidth, field.bottom);
    canvas.drawPath(path, fieldPaint);
  }

  void drawPenalties(Canvas canvas, Rect field) {
    // Penalty circles
    fieldPaint.style = PaintingStyle.fill;

    final topPenalty = Offset(field.center.dx, field.top + config.penaltyY);
    final bottomPenalty =
    Offset(field.center.dx, field.bottom - config.penaltyY);
    canvas.drawCircle(topPenalty, config.pointsSize, fieldPaint);
    canvas.drawCircle(bottomPenalty, config.pointsSize, fieldPaint);

    fieldPaint.style = PaintingStyle.stroke;

    // Penalty arcs
    final angle = findPenaltyCircleAngle();
    final topArcRect = Rect.fromLTRB(
        topPenalty.dx - config.midfieldCircleSize,
        topPenalty.dy - config.midfieldCircleSize,
        topPenalty.dx + config.midfieldCircleSize,
        topPenalty.dy + config.midfieldCircleSize);
    canvas.drawArc(topArcRect, angle, pi - angle * 2, false, fieldPaint);

    final bottomArcRect = Rect.fromLTRB(
        bottomPenalty.dx - config.midfieldCircleSize,
        bottomPenalty.dy - config.midfieldCircleSize,
        bottomPenalty.dx + config.midfieldCircleSize,
        bottomPenalty.dy + config.midfieldCircleSize);
    canvas.drawArc(
        bottomArcRect, pi + angle, pi - angle * 2, false, fieldPaint);
  }

  double findPenaltyCircleAngle() {
    final height = config.penaltyAreaSize.height - config.penaltyY;
    return asin(height / config.midfieldCircleSize);
  }


  void drawArrowHeadLines(Canvas canvas) {
    for (final item in items) {
      if (item is ArrowHead) {
        final parentOffset = item.parent.offset;
        final arrowOffset = item.offset;

        if (parentOffset != null && arrowOffset != null) {
          final linePaint = Paint()
            ..color = Colors.red // Customize line color
            ..strokeWidth = 2; // Customize line width

          canvas.drawLine(parentOffset, arrowOffset, linePaint);
        }
      }
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}