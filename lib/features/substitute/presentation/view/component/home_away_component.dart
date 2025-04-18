import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/button/button_with_divider.dart';

class HomeAwayComponent extends StatefulWidget {
  const HomeAwayComponent({super.key});

  @override
  _HomeAwayComponentState createState() => _HomeAwayComponentState();
}

class _HomeAwayComponentState extends State<HomeAwayComponent> {
  String selected = "home"; // Track the selected button

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Button
        ButtonWithDivider(
          label: "Home".toUpperCase(),
          isSelected: selected == "home",
          onPressed: () {
            setState(() {
              selected = "home";
            });
          },
        ),
        // Down Button
        ButtonWithDivider(
          label: "Away".toUpperCase(),
          isSelected: selected == "away",
          onPressed: () {
            setState(() {
              selected = "away";
            });
          },
        ),
      ],
    );
  }
}
