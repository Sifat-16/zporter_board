import 'package:bson/src/classes/object_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';

class EquipmentDataModel extends FieldDraggableItem with EquatableMixin {
  String name;
  String? imagePath;

  EquipmentDataModel({
    required super.id,
    required this.name,
    super.offset,
    this.imagePath,
    super.rotation = 0.0,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'name': name,
      'type': 'equipment',
      'imagePath': imagePath,
    };
  }

  factory EquipmentDataModel.fromJson(Map<String, dynamic> json) {
    return EquipmentDataModel(
      id: FieldDraggableItem.parseObjectId(json['_id']),
      name: json['name'],
      offset: FieldDraggableItem.parseOffset(json['offset']),
      imagePath: json['imagePath'],
      rotation: json['rotation'],
    );
  }

  @override
  EquipmentDataModel copyWith({
    ObjectId? id,
    Offset? offset,
    String? name,
    String? imagePath,
    double? rotation,
  }) {
    return EquipmentDataModel(
      id: id ?? this.id,
      offset: offset ?? this.offset,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath, rotation, offset];
}
