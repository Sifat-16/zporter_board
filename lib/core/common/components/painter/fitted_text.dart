import 'dart:math' as math; // For math.max

import 'package:flutter/material.dart';

// The main widget you'll use
class FittedText extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final TextStyle
  style; // Base style (color, fontWeight, etc.). Font size will be calculated.
  final TextAlign textAlign;
  final TextDirection textDirection;

  const FittedText({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    this.style = const TextStyle(color: Colors.black), // Default style
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    // Handle trivial cases
    if (text.isEmpty || width <= 0 || height <= 0) {
      return SizedBox(width: width, height: height);
    }

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _TextFitPainter(
          text: text,
          targetWidth: width,
          targetHeight: height,
          baseTextStyle: style,
          textAlign: textAlign,
          textDirection: textDirection,
        ),
      ),
    );
  }
}

// The CustomPainter that does the work
class _TextFitPainter extends CustomPainter {
  final String text;
  final double targetWidth;
  final double targetHeight;
  final TextStyle baseTextStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;

  _TextFitPainter({
    required this.text,
    required this.targetWidth,
    required this.targetHeight,
    required this.baseTextStyle,
    required this.textAlign,
    required this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 'size' here is (targetWidth, targetHeight)
    final textPainter = TextPainter(
      textAlign: textAlign,
      textDirection: textDirection,
    );

    double minFont = 1.0;
    // Initialize maxFont carefully. If targetHeight is very small,
    // multiplying by 2 might still be small.
    // Using targetHeight directly as a starting point for maxFont is often reasonable.
    double maxFont = math.max(
      2.0,
      targetHeight * 1.5,
    ); // Ensure maxFont is at least 2.0
    double bestFittingFontSize = minFont;

    if (targetHeight < 1.0) {
      // Avoid issues with extremely small target heights
      // Optionally, don't draw or draw a placeholder if targetHeight is too small.
      // For now, we let it try with a tiny font.
    }

    // Binary search to find the largest font size that fits the targetHeight
    for (int i = 0; i < 20; i++) {
      // 20 iterations for precision
      double currentTestFont = (minFont + maxFont) / 2;
      if (currentTestFont < 0.5) {
        // Prevent font size from becoming too small or negative
        bestFittingFontSize = math.max(
          0.5,
          bestFittingFontSize,
        ); // Ensure a minimum practical size
        break;
      }

      textPainter.text = TextSpan(
        text: text,
        style: baseTextStyle.copyWith(fontSize: currentTestFont),
      );
      // Layout with infinite width to get the "natural" height for this font size
      textPainter.layout(minWidth: 0, maxWidth: double.infinity);

      if (textPainter.height <= targetHeight) {
        bestFittingFontSize = currentTestFont;
        minFont = currentTestFont; // Try a larger font
      } else {
        maxFont = currentTestFont; // Font is too big, try smaller
      }
    }

    // Ensure a minimum font size if it ended up too small, e.g. if targetHeight was tiny.
    bestFittingFontSize = math.max(1.0, bestFittingFontSize);

    // Final layout with the chosen font size
    textPainter.text = TextSpan(
      text: text,
      style: baseTextStyle.copyWith(fontSize: bestFittingFontSize),
    );
    // Layout again with infinite width to get the text's natural dimensions at this font size
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    double actualTextWidth = textPainter.width;
    double actualTextHeight = textPainter.height;

    // If text is empty or font size is too small, dimensions might be zero or invalid
    if (actualTextWidth <= 0 || actualTextHeight <= 0) {
      return; // Don't draw anything
    }

    // Calculate scaling factors
    double scaleX = targetWidth / actualTextWidth;
    double scaleY = targetHeight / actualTextHeight;

    canvas.save();

    // --- Apply transformations to center and scale the text ---

    // 1. Translate to the center of the target bounds
    canvas.translate(targetWidth / 2, targetHeight / 2);

    // 2. Scale the canvas
    canvas.scale(scaleX, scaleY);

    // 3. Translate back by half of the text's original (pre-scale)
    //    dimensions. This ensures the text (which is painted starting from
    //    its own top-left for TextPainter) is centered in the scaled space.
    canvas.translate(-actualTextWidth / 2, -actualTextHeight / 2);

    // Paint the text at the new (0,0) of the transformed canvas
    textPainter.paint(canvas, Offset.zero);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TextFitPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.targetWidth != targetWidth ||
        oldDelegate.targetHeight != targetHeight ||
        oldDelegate.baseTextStyle != baseTextStyle ||
        oldDelegate.textAlign != textAlign ||
        oldDelegate.textDirection != textDirection;
  }
}
