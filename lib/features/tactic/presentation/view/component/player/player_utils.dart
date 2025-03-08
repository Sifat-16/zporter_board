import 'package:uuid/uuid.dart';

import 'PlayerDataModel.dart';

class PlayerUtils{
  static List<String> players = [
    "GK", "RB", "LB", "CB", "CM", "AM", "AM", "S", "RW", "LW", "FW", "CAM", "CDM", "RM", "GK", "RB", "LB", "CB", "CB", "CM","AM","AM","S"
  ];

  static List<PlayerModel> generatePlayerModelList({required PlayerType playerType}){
    List<PlayerModel> generatedPlayers = [];
    int index=1;
    for(String p in players){
      String id = Uuid().v4();
      PlayerModel playerDataModel = PlayerModel(id: id, role: p, index: index, playerType: playerType);
      generatedPlayers.add(playerDataModel);
      index++;
    }
    return generatedPlayers;
  }
}

