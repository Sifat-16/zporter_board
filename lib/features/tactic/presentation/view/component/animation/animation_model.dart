import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_draggable_item.dart';

class AnimationModel extends Equatable{
  String id;
  List<FieldDraggableItem> items;
  int index;
  AnimationModel({required this.id, required this.items, required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [id, items, index];

}