import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';

class EquipmentUtils{
  static final List<EquipmentDataModel> _equipment = [
    EquipmentDataModel(
        id: "football_id",
        name: "Football",
        imagePath: AssetsManager.football
    )
  ];

  static List<EquipmentDataModel> generateEquipmentModelList(){
    return _equipment;
  }
}