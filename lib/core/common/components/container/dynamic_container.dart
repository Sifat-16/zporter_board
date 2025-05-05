import 'package:flutter/material.dart';

/// A widget that measures the height its child occupies after layout
/// and provides that height to a builder function.
class DynamicContainer extends StatefulWidget {
  /// Builder function that receives the context and the measured height.
  final Widget Function(BuildContext context, double height, double width)
  builder;

  const DynamicContainer({Key? key, required this.builder}) : super(key: key);

  @override
  State<DynamicContainer> createState() => _DynamicContainerState();
}

class _DynamicContainerState extends State<DynamicContainer> {
  final GlobalKey _key = GlobalKey();
  // Initialize height to 0.0 for the initial build before measurement.
  double _measuredHeight = 0.0;
  double _measuredWidth = 0.0;
  @override
  void initState() {
    super.initState();
    // Measure after the first frame is rendered.
    _scheduleMeasurement();
  }

  @override
  void didUpdateWidget(DynamicContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Schedule measurement on update in case constraints or builder changed.
    _scheduleMeasurement();
  }

  void _scheduleMeasurement() {
    // Use addPostFrameCallback to ensure measurement happens after layout.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
  }

  void _measureHeight() {
    // Ensure the widget is still mounted before trying to access context/render object.
    if (!mounted) {
      return;
    }

    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final newHeight = renderBox.size.height;
      final newWidth = renderBox.size.width;

      // Only trigger setState if the height has actually changed.
      if (_measuredHeight != newHeight) {
        setState(() {
          _measuredHeight = newHeight;
        });
      }
      if (_measuredWidth != newWidth) {
        setState(() {
          _measuredWidth = newWidth;
        });
      }
    } else {
      // If size is 0 and we previously had a size, reset state to 0
      // This handles cases where the widget might temporarily disappear or shrink to zero.
      if (_measuredHeight != 0.0 && (renderBox == null || !renderBox.hasSize)) {
        setState(() {
          _measuredHeight = 0.0;
        });
      }

      if (_measuredWidth != 0.0 && (renderBox == null || !renderBox.hasSize)) {
        setState(() {
          _measuredWidth = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Schedule a measurement on each build to catch potential layout changes.
    _scheduleMeasurement();

    // Use KeyedSubtree to associate the key with the widget tree built by the builder.
    // This ensures we measure the actual rendered content.
    return KeyedSubtree(
      key: _key,
      // Call the builder function, passing the current measured height.
      // The builder is responsible for constructing the child widget(s).
      child: widget.builder(context, _measuredHeight, _measuredWidth),
    );
  }
}
