import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer_component.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class ScoreBoardHeader extends StatefulWidget {
  const ScoreBoardHeader({super.key});

  @override
  State<ScoreBoardHeader> createState() => _ScoreBoardHeaderState();
}

class _ScoreBoardHeaderState extends State<ScoreBoardHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("HOME", style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: ColorManager.grey
        ),),
        TimerComponent(startMinutes: 45, startSeconds: 30),
        Text("AWAY", style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: ColorManager.grey
        ),),
      ],
    );
  }
}
