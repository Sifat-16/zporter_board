import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_data_model.dart';

class StraightLineComponent extends StatefulWidget {
  const StraightLineComponent({super.key, required this.arrowHead});

  final ArrowHead arrowHead;

  @override
  State<StraightLineComponent> createState() => _StraightLineComponentState();
}

class _StraightLineComponentState extends State<StraightLineComponent> {
  bool _isFocused = false;

  void _setFocus(bool focus) {
    setState(() {
      _isFocused = focus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _setFocus(!_isFocused),
      child: Draggable<ArrowHead>(
        data: widget.arrowHead,
        onDragStarted: () => _setFocus(true),
        onDragEnd: (_) => _setFocus(false),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _buildArrowComponent(),
        ),
        feedback: Material(
          color: Colors.transparent,
          child: _buildArrowComponent(),
        ),
        child: _buildArrowComponent(),
      ),
    );
  }

  Widget _buildArrowComponent() {
    return RepaintBoundary(
      key: UniqueKey(),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s4),
            border: _isFocused
                ? Border.all(color: Colors.yellow, width: 3)
                : null, // Add border if focused
          ),
          child: Icon(Icons.arrow_forward_ios, color: ColorManager.white, size: AppSize.s16,),
        ),
      ),
    );
  }
}
