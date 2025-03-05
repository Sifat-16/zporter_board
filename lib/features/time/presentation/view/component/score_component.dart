import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class ScoreComponent extends StatelessWidget {
  const ScoreComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("4", style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: ColorManager.green,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.s56
            ),),
            Text("-", style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: ColorManager.green,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.s56
            ),),
            Text("3", style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: ColorManager.green,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.s56
            ),),
          ],
        ),
      ),
    );
  }
}
