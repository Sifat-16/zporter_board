import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/focused_item_component.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';

class EquipmentComponent extends StatefulWidget {
  const EquipmentComponent({super.key, required this.equipmentDataModel, this.activateFocus=false});
  final EquipmentDataModel equipmentDataModel;
  final bool activateFocus;

  @override
  State<EquipmentComponent> createState() => _EquipmentComponentState();
}

class _EquipmentComponentState extends State<EquipmentComponent> {
  bool _isFocused = false;

  void _setFocus(bool focus) {
    setState(() {
      _isFocused = focus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusedItemComponent(
      draggableItem: widget.equipmentDataModel,
      isFocused: _isFocused,
      onFocusChanged: _setFocus,
      focusActivated: widget.activateFocus,
      child: GestureDetector(
        onTap: () => _setFocus(!_isFocused),
        child: Draggable<EquipmentDataModel>(
          data: widget.equipmentDataModel,
          onDragStarted: () => _setFocus(true),
          onDragEnd: (_) => _setFocus(false),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: _buildEquipmentComponent(),
          ),
          feedback: Material(
            color: Colors.transparent,
            child: _buildEquipmentComponent(),
          ),
          child: _buildEquipmentComponent(),
        ),
      ),
    );
  }

  Widget _buildEquipmentComponent() {
    return RepaintBoundary(
      key: UniqueKey(),
      child: Center(
        child: Container(
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(AppSize.s4),
            border: _isFocused
                ? Border.all(color: Colors.yellow, width: 3)
                : null, // Add border if focused
          ),
          child: SizedBox(
            height: AppSize.s32,
            width: AppSize.s32,
            child: Image.asset(widget.equipmentDataModel.imagePath??"", color: ColorManager.white,)
          ),
        ),
      ),
    );
  }
}
