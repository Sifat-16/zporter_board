import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';

class AnimationModel {
  ObjectId id;
  List<FieldDraggableItem> items;
  int index;

  AnimationModel({required this.id, required this.items, required this.index});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'index': index,
    };
  }

  factory AnimationModel.fromJson(Map<String, dynamic> json) {
    return AnimationModel(
      id: FieldDraggableItem.parseObjectId(json['_id']),
      items: (json['items'] as List<dynamic>)
          .map((item) => FieldDraggableItem.fromJson(item))
          .toList(),
      index: json['index'],
    );
  }
}
