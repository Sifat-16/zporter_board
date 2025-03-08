import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';

class EquipmentDataModel extends FieldDraggableItem with EquatableMixin{
  String name;
  String? imagePath;
  double rotation;
  EquipmentDataModel({required super.id, required this.name, super.offset, this.imagePath,
    this.rotation = 0.0});

  @override
  EquipmentDataModel copyWith({
    String? id,
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