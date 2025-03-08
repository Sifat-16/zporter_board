import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';

class ArrowHead extends FieldDraggableItem with EquatableMixin{
  FieldDraggableItem parent;
  Offset? parentPoint;
  ArrowHead({required this.parent, this.parentPoint, required super.id, required super.offset});

  @override
  ArrowHead copyWith({
    String? id,
    Offset? offset,
    FieldDraggableItem? parent,
    Offset? parentPoint,
  }) {
    return ArrowHead(
      id: id ?? this.id,
      offset: offset ?? this.offset,
      parent: parent ?? this.parent,
      parentPoint: parentPoint ?? this.parentPoint,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [parent, parentPoint, id, offset];
}