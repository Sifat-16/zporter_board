import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';

class AnimationDataModel {
  ObjectId id;
  List<AnimationModel> items;

  AnimationDataModel({required this.id, required this.items});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory AnimationDataModel.fromJson(Map<String, dynamic> json) {
    return AnimationDataModel(
      id: FieldDraggableItem.parseObjectId(json['_id']),
      items: (json['items'] as List<dynamic>)
          .map((item) => AnimationModel.fromJson(item))
          .toList()
    );
  }
}
