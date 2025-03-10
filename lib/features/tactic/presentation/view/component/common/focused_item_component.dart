import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'dart:math';

import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/core/utils/random/random_utils.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';
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


  @override
  void initState() {
    super.initState();
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
      child: StraightLineComponent(arrowHead: ArrowHead(parent: widget.draggableItem, id: ObjectId(), offset: widget.draggableItem.offset, rotation: widget.draggableItem.rotation,)),

    );
  }
}

