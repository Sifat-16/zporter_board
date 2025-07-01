// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
//
// class SlidableOptionsWidget extends StatelessWidget {
//   final Widget content;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   const SlidableOptionsWidget({
//     Key? key,
//     required this.content,
//     required this.onEdit,
//     required this.onDelete
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       key: UniqueKey(), // Unique key for each item
//       endActionPane: ActionPane(
//         motion: const ScrollMotion(), // Smooth sliding motion
//         children: [
//
//
//           SlidableAction(
//             onPressed: (context) => onDelete(),
//             backgroundColor: ColorManager.grey.withValues(alpha: 0.1),
//             foregroundColor: Colors.white,
//             icon: Icons.delete,
//             flex: 1,
//             padding: EdgeInsets.zero,
//
//
//           ),
//
//           SlidableAction(
//             onPressed: (context) => onEdit(),
//             backgroundColor: ColorManager.grey.withValues(alpha: 0.1),
//             foregroundColor: Colors.white,
//             flex: 1,
//             icon: Icons.edit,
//             padding: EdgeInsets.zero,
//           ),
//         ],
//       ),
//       child: content,
//     );
//   }
// }
//
//
//

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

/// A reusable slidable widget that reveals actions like 'Delete' or 'Share'.
///
/// This component wraps any given [child] widget with slidable functionality
/// using the `flutter_slidable` package.
class CustomSlidable extends StatelessWidget {
  const CustomSlidable({
    Key? key,
    required this.child,
    this.onDelete,
    this.onShare,
  }) : super(key: key);

  final Widget child;
  final Function()? onDelete;
  final Function()? onShare;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // A key is important for lists of slidable items.
      key: const ValueKey(0),

      // The endActionPane appears when the user slides from right to left.
      endActionPane: ActionPane(
        // The motion effect for the actions.
        motion: const ScrollMotion(),
        children: [
          // The 'Delete' action, only shown if an onDelete callback is provided.
          if (onDelete != null)
            SlidableAction(
              onPressed: (context) {
                if (onDelete != null) {
                  onDelete!();
                }
              },
              backgroundColor: ColorManager.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          // The 'Share' action, only shown if an onShare callback is provided.
          if (onShare != null)
            SlidableAction(
              onPressed: (context) {
                if (onShare != null) {
                  onShare!();
                }
              },
              backgroundColor: ColorManager.yellowLight,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
        ],
      ),
      // The main content that is visible by default.
      child: child,
    );
  }
}
