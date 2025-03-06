import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

double getBoardHeightLeft(BuildContext context){
  return context.screenHeight-(2*AppSize.s0)-kToolbarHeight-context.padding.top-context.padding.bottom;
}