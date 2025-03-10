import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';

enum FormType { LINE, OTHER }

class FormDataModel extends FieldDraggableItem with EquatableMixin {
  String name;
  String? imagePath;
  FormType formType;

  FormDataModel({
    required super.id,
    required this.name,
    super.offset,
    this.imagePath,
    super.rotation = 0.0,
    this.formType = FormType.OTHER,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'name': name,
      'type': 'form',
      'imagePath': imagePath,
      'formType': formType.name,
    };
  }

  factory FormDataModel.fromJson(Map<String, dynamic> json) {
    return FormDataModel(
      id: FieldDraggableItem.parseObjectId(json['_id']),
      name: json['name'],
      offset: FieldDraggableItem.parseOffset(json['offset']),
      imagePath: json['imagePath'],
      rotation: json['rotation'],
      formType: FormType.values.byName(json['formType']),
    );
  }

  @override
  FormDataModel copyWith({
    ObjectId? id,
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

// Register the model
void registerFormDataModel() {
  FieldDraggableItem.register('FormDataModel', (json) => FormDataModel.fromJson(json));
}
