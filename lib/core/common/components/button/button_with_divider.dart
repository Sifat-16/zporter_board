import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class ButtonWithDivider extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const ButtonWithDivider({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Button with GestureDetector
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    isSelected
                        ? ColorManager.yellow
                        : ColorManager.grey, // Text color
              ),
            ),
          ),
        ),
        // Divider as tab selection indicator
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: isSelected ? 40 : 0, // Divider width when selected
          height: 4, // Divider height
          color:
              isSelected
                  ? ColorManager.yellow
                  : Colors.transparent, // Divider color
        ),
      ],
    );
  }
}
