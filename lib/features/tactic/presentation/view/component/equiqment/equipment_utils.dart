import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';

class EquipmentUtils{
  static final List<EquipmentDataModel> _equipment = [
    EquipmentDataModel(
        id: ObjectId(),
        name: "Football",
        imagePath: AssetsManager.football
    )
  ];

  static List<EquipmentDataModel> generateEquipmentModelList(){
    return _equipment;
  }
}