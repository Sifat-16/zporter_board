import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class TimeManagerComponent extends StatelessWidget {
  const TimeManagerComponent({super.key,
    required this.onStart,
    required this.onPause,
    required this.onStop,});
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("CLOCK 18:47", style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: ColorManager.grey,
            fontWeight: FontWeight.bold,
            fontSize: AppSize.s28
          ),),
          TimerControlButtons(onStart: onStart, onPause: onPause, onStop: onStop),
          Text("TOTAL 01:45:59", style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: ColorManager.grey,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.s28
          ),),
        ],
      ),
    );
  }

}
