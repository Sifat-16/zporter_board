import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/utils/random/random_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_data_model.dart';

class FormUtils{
  static final List<FormDataModel> _forms = [
    // FormDataModel(
    //     id: RandomUtils.randomString(),
    //     name: "line",
    //     formType: FormType.LINE,
    //     imagePath: AssetsManager.line
    // )
  ];

  static List<FormDataModel> generateFormModelList(){
    return _forms;
  }
}