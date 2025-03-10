import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';

enum PlayerType { HOME, OTHER, AWAY }

class PlayerModel extends FieldDraggableItem with EquatableMixin {
  String role;
  int index;
  String? imagePath;
  PlayerType playerType;

  PlayerModel({
    required super.id,
    required this.role,
    super.offset,
    required this.index,
    this.imagePath,
    super.rotation = 0.0,
    required this.playerType,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'role': role,
      'type': 'player',
      'index': index,
      'imagePath': imagePath,
      'playerType': playerType.name,
    };
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: FieldDraggableItem.parseObjectId(json['_id']),
      role: json['role'],
      offset: FieldDraggableItem.parseOffset(json['offset']),
      index: json['index'],
      imagePath: json['imagePath'],
      rotation: json['rotation'],
      playerType: PlayerType.values.byName(json['playerType']),
    );
  }


  @override
  PlayerModel copyWith({
    ObjectId? id,
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

// Register the model
void registerPlayerModel() {
  FieldDraggableItem.register('PlayerModel', (json) => PlayerModel.fromJson(json));
}
