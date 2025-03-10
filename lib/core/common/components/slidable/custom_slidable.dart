import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class SlidableOptionsWidget extends StatelessWidget {
  final Widget content;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SlidableOptionsWidget({
    Key? key,
    required this.content,
    required this.onEdit,
    required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(), // Unique key for each item
      endActionPane: ActionPane(
        motion: const ScrollMotion(), // Smooth sliding motion
        children: [


          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: ColorManager.grey.withValues(alpha: 0.1),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            flex: 1,
            padding: EdgeInsets.zero,


          ),

          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: ColorManager.grey.withValues(alpha: 0.1),
            foregroundColor: Colors.white,
            flex: 1,
            icon: Icons.edit,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      child: content,
    );
  }
}
