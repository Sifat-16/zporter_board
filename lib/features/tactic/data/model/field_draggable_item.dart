import 'dart:ui';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/form_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';

abstract class FieldDraggableItem {
  ObjectId id;
  Offset? offset;
  double rotation;

  FieldDraggableItem({
    required this.id,
    this.offset,
    required this.rotation,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'offset': offset != null ? {'dx': offset!.dx, 'dy': offset!.dy} : null,
      'rotation': rotation,
      'type': runtimeType.toString(), // Store the class name for deserialization
    };
  }

  static Offset? parseOffset(Map<String, dynamic>? json) {
    return json != null ? Offset(json['dx'], json['dy']) : null;
  }

  static ObjectId parseObjectId(dynamic id) {
    return id is ObjectId ? id : ObjectId.parse(id);
  }

  static final Map<String, FieldDraggableItem Function(Map<String, dynamic>)>
  _constructors = {};

  static void register<T extends FieldDraggableItem>(
      String type, FieldDraggableItem Function(Map<String, dynamic>) constructor) {
    _constructors[type] = constructor;
  }

  static FieldDraggableItem fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'player':
        return PlayerModel.fromJson(json);
      case 'form':
        return FormDataModel.fromJson(json);
      case 'equipment':
        return EquipmentDataModel.fromJson(json);
      case 'arrow':
        return ArrowHead.fromJson(json);
      default:
        throw Exception('Unknown FieldDraggableItem type: ${json['type']}');
    }
  }

  FieldDraggableItem copyWith({
    ObjectId? id,
    Offset? offset,
    double? rotation
  });
}
