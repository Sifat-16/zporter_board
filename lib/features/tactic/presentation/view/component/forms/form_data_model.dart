import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';

enum FormType{
  LINE,
  OTHER
}

class FormDataModel extends FieldDraggableItem with EquatableMixin{

  String name;
  String? imagePath;
  double rotation;
  FormType formType;
  FormDataModel({required super.id, required this.name, super.offset, this.imagePath,
    this.rotation = 0.0, this.formType=FormType.OTHER});

  @override
  FormDataModel copyWith({
    String? id,
    Offset? offset,
    String? name,
    String? imagePath,
    double? rotation,
    FormType? formType,
  }) {
    return FormDataModel(
      id: id ?? this.id,
      offset: offset ?? this.offset,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      rotation: rotation ?? this.rotation,
      formType: formType ?? this.formType,
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath, rotation, offset];
}