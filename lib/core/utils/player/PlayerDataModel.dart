import 'dart:ui';

enum PlayerType{
  HOME,
  OTHER,
  AWAY
}

class PlayerModel{
  String id;
  String role;
  int index;
  Offset? offset;
  String? imagePath;
  double rotation;
  PlayerType playerType;
  PlayerModel({required this.id, required this.role, this.offset, required this.index, this.imagePath,
    this.rotation = 0.0, required this.playerType});
}