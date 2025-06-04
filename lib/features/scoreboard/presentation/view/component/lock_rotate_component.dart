import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/button/button_with_divider.dart';

class LockRotateButtonWidget extends StatefulWidget {
  const LockRotateButtonWidget({super.key, required this.onLocked});

  final Function(bool isLocked) onLocked;

  @override
  _LockRotateButtonWidgetState createState() => _LockRotateButtonWidgetState();
}

class _LockRotateButtonWidgetState extends State<LockRotateButtonWidget> {
  String selected = "rotate"; // Track the selected button

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Button
        ButtonWithDivider(
          label: "Lock".toUpperCase(),
          isSelected: selected == "lock",
          onPressed: () {
            setState(() {
              selected = "lock";
            });
            widget.onLocked.call(true);
          },
        ),
        // Down Button
        ButtonWithDivider(
          label: "Rotate".toUpperCase(),
          isSelected: selected == "rotate",
          onPressed: () {
            setState(() {
              selected = "rotate";
            });
            widget.onLocked.call(false);
          },
        ),
      ],
    );
  }
}
