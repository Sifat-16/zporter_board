import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';

class ArrowHead extends FieldDraggableItem with EquatableMixin {
  FieldDraggableItem parent;
  Offset? parentPoint;

  ArrowHead({
    required this.parent,
    this.parentPoint,
    required super.id,
    required super.offset,
    required super.rotation,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'parent': parent.toJson(),
      'type': 'arrow',
      'parentPoint': parentPoint != null
          ? {'dx': parentPoint!.dx, 'dy': parentPoint!.dy}
          : null,
    };
  }

  factory ArrowHead.fromJson(Map<String, dynamic> json) {
    return ArrowHead(
      id: FieldDraggableItem.parseObjectId(json['_id']),
      parent: FieldDraggableItem.fromJson(json['parent']),
      parentPoint: FieldDraggableItem.parseOffset(json['parentPoint']),
      offset: FieldDraggableItem.parseOffset(json['offset']),
      rotation: json['rotation'],
    );
  }

  @override
  ArrowHead copyWith({
    ObjectId? id,
    Offset? offset,
    FieldDraggableItem? parent,
    Offset? parentPoint,
    double? rotation,
  }) {
    return ArrowHead(
        id: id ?? this.id,
        offset: offset ?? this.offset,
        parent: parent ?? this.parent,
        parentPoint: parentPoint ?? this.parentPoint,
        rotation:  rotation??this.rotation
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [parent, parentPoint, id, offset];
}
