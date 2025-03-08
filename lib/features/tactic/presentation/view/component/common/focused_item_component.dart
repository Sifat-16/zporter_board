import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/random/random_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/line_component/straight_line_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_event.dart';

class FocusedItemComponent extends StatefulWidget {
  const FocusedItemComponent({
    super.key,
    required this.child,
    required this.isFocused,
    required this.onFocusChanged,
    required this.draggableItem,
    this.focusActivated = true,
  });

  final Widget child;
  final bool isFocused;
  final bool focusActivated;
  final ValueChanged<bool> onFocusChanged;
  final FieldDraggableItem draggableItem;

  @override
  State<FocusedItemComponent> createState() => _FocusedItemComponentState();
}

class _FocusedItemComponentState extends State<FocusedItemComponent> {

  Offset? _endOffset;


  @override
  void initState() {
    super.initState();
  }



  void _onPanDown(DragDownDetails details) {
    setState(() {
      _endOffset = details.localPosition;
    });
  }

  void _onPanStart(DragStartDetails details) {
    debug(data: "Dragging happening \${details.localPosition}");
    setState(() {
      _endOffset = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _endOffset = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) {

    // ArrowHead arrowHead = ArrowHead(parent: widget.draggableItem, parentPoint: widget.draggableItem.offset, id: RandomUtils.randomString(), offset:_endOffset);
    //
    // debug(data: "looks down the arrow head ${arrowHead.parent.runtimeType} -${arrowHead.parent.offset} - ${arrowHead.parentPoint} - ${arrowHead.offset}");
    // context.read<FormBloc>().add(ArrowHeadAddEvent(arrowHead: arrowHead));
  }


  @override
  Widget build(BuildContext context) {
    return widget.focusActivated
        ? GestureDetector(
      onTap: () => widget.onFocusChanged(!widget.isFocused),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: widget.child,

          ),
          if (widget.isFocused) ...[
            _buildDot(),
          ],
        ],
      ),
    )
        : widget.child;
  }

  Widget _buildDot() {

    return Align(
      alignment: Alignment.centerRight,
      child: StraightLineComponent(arrowHead: ArrowHead(parent: widget.draggableItem, id: RandomUtils.randomString(), offset: widget.draggableItem.offset)),


      // child: GestureDetector(
      //   onPanDown: _onPanDown,
      //   onPanStart: _onPanStart,
      //   onPanUpdate: _onPanUpdate,
      //   onPanEnd: _onPanEnd,
      //   child: Container(
      //     width: 12,
      //     height: 12,
      //     margin: const EdgeInsets.all(4),
      //     decoration: BoxDecoration(
      //       color: Colors.yellow,
      //       shape: BoxShape.circle,
      //     ),
      //   ),
      // ),
    );
  }
}

