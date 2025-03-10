import 'dart:math';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/model/PlayerDataModel.dart';

class PlayerUtils{
  static List<String> players = [
    "GK", "RB", "LB", "CB", "CM", "AM", "AM", "S", "RW", "LW", "FW", "CAM", "CDM", "RM", "GK", "RB", "LB", "CB", "CB", "CM","AM","AM","S"
  ];

  static List<PlayerModel> generatePlayerModelList({required PlayerType playerType}){
    List<PlayerModel> generatedPlayers = [];
    int index=1;
    for(String p in players){
      ObjectId id = ObjectId();
      PlayerModel playerDataModel = PlayerModel(id:id, role: p, index: index, playerType: playerType);
      // if(playerType != PlayerType.HOME){
      //   playerDataModel.rotation = pi;
      // }
      generatedPlayers.add(playerDataModel);
      index++;
    }
    return generatedPlayers;
  }
}

