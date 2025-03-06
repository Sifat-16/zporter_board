import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class PaginationComponent extends StatelessWidget {
  const PaginationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: NumberPaginator(
        numberPages: 3,
        initialPage: 1,
        onPageChange: (int index) {
          // handle page change...
        },
        prevButtonContent: Icon(Icons.chevron_left, color: ColorManager.grey, size: AppSize.s32,),
        nextButtonContent: Icon(Icons.chevron_right, color: ColorManager.grey,size: AppSize.s32),
        config: NumberPaginatorUIConfig(
          buttonShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded edges
          ),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          buttonSelectedForegroundColor: ColorManager.yellow, // Selected text color
          buttonSelectedBackgroundColor: Colors.black, // Background of selected button
          buttonUnselectedForegroundColor: ColorManager.grey, // Unselected text color
          buttonUnselectedBackgroundColor: Colors.transparent, // Unselected button background
          buttonTextStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: AppSize.s28
          ),
        ),
      ),
    );
  }
}
