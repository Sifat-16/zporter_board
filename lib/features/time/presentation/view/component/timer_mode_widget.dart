import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/button/button_with_divider.dart';

enum TimerMode { UP, DOWN, EXTRA }

// Optional: Extension to get display names easily (improves code readability)
extension TimerModeExtension on TimerMode {
  String get displayTitle {
    switch (this) {
      case TimerMode.UP:
        return "Up";
      case TimerMode.DOWN:
        return "Down";
      case TimerMode.EXTRA:
        return "Extra";
    }
  }
}

class TimerModeWidget extends StatefulWidget {
  final TimerMode
  currentTimerMode; // Input: Mode as a string ("UP", "DOWN", "EXTRA")
  final ValueChanged<TimerMode>
  onModeSelected; // Output: Callback when a mode is chosen

  const TimerModeWidget({
    super.key,
    required this.currentTimerMode,
    required this.onModeSelected,
  });

  @override
  State<TimerModeWidget> createState() => _TimerModeWidgetState();
}

class _TimerModeWidgetState extends State<TimerModeWidget> {
  // --- Helper method MOVED INSIDE the State class ---
  // Converts the input string prop to the corresponding TimerMode enum
  // TimerMode _getModeFromString(String modeString) {
  //   switch (modeString.toUpperCase()) {
  //     case "DOWN":
  //       return TimerMode.DOWN;
  //     case "EXTRA":
  //       return TimerMode.EXTRA;
  //     case "UP":
  //     default: // Default to UP if string is unexpected or empty
  //       return TimerMode.UP;
  //   }
  // }
  // ----------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(TimerModeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTimerMode != oldWidget.currentTimerMode) {
      // Optional: Add logic if needed when the mode string prop changes.
      // The build method will handle the visual update automatically.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the currently active mode using the helper method
    final TimerMode activeMode = widget.currentTimerMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Button
        ButtonWithDivider(
          label: TimerMode.UP.displayTitle.toUpperCase(),
          isSelected: activeMode == TimerMode.UP,
          onPressed: () {
            widget.onModeSelected(TimerMode.UP);
          },
        ),

        // // Down Button
        // ButtonWithDivider(
        //   label: TimerMode.DOWN.displayTitle.toUpperCase(),
        //   isSelected: activeMode == TimerMode.DOWN,
        //   onPressed: () {
        //     widget.onModeSelected(TimerMode.DOWN);
        //   },
        // ),

        // Extra Button
        ButtonWithDivider(
          label: TimerMode.EXTRA.displayTitle.toUpperCase(),
          isSelected: activeMode == TimerMode.EXTRA,
          onPressed: () {
            widget.onModeSelected(TimerMode.EXTRA);
          },
        ),
      ],
    );
  }
}
