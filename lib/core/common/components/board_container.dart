import 'package:flutter/cupertino.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class BoardContainer extends StatelessWidget {
  const BoardContainer({super.key, required this.child, this.zeroPadding=false});

  final bool zeroPadding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:zeroPadding ? EdgeInsets.zero : EdgeInsets.symmetric(vertical: AppSize.s0, horizontal: AppSize.s32),
      child: child,
    );
  }
}
