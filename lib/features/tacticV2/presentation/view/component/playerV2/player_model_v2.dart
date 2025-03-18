import 'package:flutter/material.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';

class PlayerModelV2{
  String id;
  String role;
  Offset? offset;
  int index;
  String? imagePath;
  PlayerType playerType;

  PlayerModelV2({
    required this.id,
    required this.role,
    this.offset,
    required this.index,
    this.imagePath,
    required this.playerType,
  });

}

