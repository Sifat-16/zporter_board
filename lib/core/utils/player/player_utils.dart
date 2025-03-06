import 'package:uuid/uuid.dart';
import 'package:zporter_board/core/utils/player/PlayerDataModel.dart';

class PlayerUtils{
  static List<String> players = [
    "GK", "RB", "LB", "CB", "CM", "AM", "AM", "S", "RW", "LW", "FW", "CAM", "CDM", "RM", "GK", "RB", "LB", "CB", "CB", "CM","AM","AM","S"
  ];

  static List<PlayerDataModel> generatePlayerModelList(){
    List<PlayerDataModel> generatedPlayers = [];
    for(String p in players){
      String id = Uuid().v4();
      PlayerDataModel playerDataModel = PlayerDataModel(id: id, type: p);
      generatedPlayers.add(playerDataModel);
    }
    return generatedPlayers;
  }
}