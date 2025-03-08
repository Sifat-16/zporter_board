import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';

enum PlayerType{
  HOME,
  OTHER,
  AWAY
}

class PlayerModel extends FieldDraggableItem with EquatableMixin{
  String role;
  int index;
  String? imagePath;
  double rotation;
  PlayerType playerType;

  PlayerModel({required super.id, required this.role, super.offset, required this.index, this.imagePath,
    this.rotation = 0.0, required this.playerType});

  @override
  PlayerModel copyWith({
    String? id,
    Offset? offset,
    String? role,
    int? index,
    String? imagePath,
    double? rotation,
    PlayerType? playerType,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      offset: offset ?? this.offset,
      role: role ?? this.role,
      index: index ?? this.index,
      imagePath: imagePath ?? this.imagePath,
      rotation: rotation ?? this.rotation,
      playerType: playerType ?? this.playerType,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, role, offset, index, imagePath, rotation, playerType];


}