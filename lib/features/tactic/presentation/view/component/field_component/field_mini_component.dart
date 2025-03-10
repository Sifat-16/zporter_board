import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/size_extension.dart';

import 'field_config.dart';
import '../../../../data/model/field_draggable_item.dart';
import 'field_item_component.dart';
import 'field_painter.dart';

class FieldMiniComponent extends StatefulWidget {
  const FieldMiniComponent({super.key, required this.itemPosition});

  final List<FieldDraggableItem> itemPosition;

  @override
  State<FieldMiniComponent> createState() => _FieldMiniComponentState();
}

class _FieldMiniComponentState extends State<FieldMiniComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(context.screenHeight * .25, context.screenHeight * .15),
          painter: FieldPainter(config: defaultFieldMiniConfig, items: widget.itemPosition),
        ),

        // Render existing players
        ...widget.itemPosition.map((item) {
          return Positioned(
            left: item.offset?.dx,
            top: item.offset?.dy,
            child: FieldItemComponent(fieldDraggableItem: item, activateFocus: true,),
          );
        }),

      ],
    );
  }
}
