import 'dart:ui';

class PlayerDataModel{
  String id;
  String type;
  Offset? offset;
  PlayerDataModel({required this.id, required this.type, this.offset});
}