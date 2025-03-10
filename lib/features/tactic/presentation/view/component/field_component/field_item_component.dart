import 'package:flutter/material.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_component.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/field_draggable_item.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_component.dart';
import 'package:zporter_board/features/tactic/data/model/form_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/line_component/straight_line_component.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/player_component.dart';

class FieldItemComponent extends StatefulWidget {
  const FieldItemComponent({super.key, required this.fieldDraggableItem, this.activateFocus=false});

  final FieldDraggableItem fieldDraggableItem;
  final bool activateFocus;

  @override
  State<FieldItemComponent> createState() => _FieldItemComponentState();
}

class _FieldItemComponentState extends State<FieldItemComponent> {
  @override
  Widget build(BuildContext context) {
    FieldDraggableItem fieldDraggableItem = widget.fieldDraggableItem;
    return Transform.rotate(
      angle: fieldDraggableItem.rotation,
      child: Builder(
          builder: (context){
            if(fieldDraggableItem is PlayerModel){
              return PlayerComponent(playerDataModel: fieldDraggableItem, activateFocus: widget.activateFocus,);
            }else if(fieldDraggableItem is EquipmentDataModel){
              return EquipmentComponent(equipmentDataModel: fieldDraggableItem, activateFocus: widget.activateFocus,);
            } else if(fieldDraggableItem is FormDataModel){
              if(fieldDraggableItem.formType==FormType.LINE){
                return Container();
              }else{
                return FormComponent(formDataModel: fieldDraggableItem);
              }

            }else if(fieldDraggableItem is ArrowHead){
              return StraightLineComponent(arrowHead: fieldDraggableItem);
            }
            else{
              return SizedBox.shrink();
            }
          }
      ),
    );

  }
}
