import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/tactic/data/model/form_data_model.dart';

class FormComponent extends StatefulWidget {
  const FormComponent({super.key, required this.formDataModel});

  final FormDataModel formDataModel;

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  bool _isFocused = false;

  void _setFocus(bool focus) {
    setState(() {
      _isFocused = focus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _setFocus(!_isFocused),
      child: Draggable<FormDataModel>(
        data: widget.formDataModel,
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
              child: Image.asset(widget.formDataModel.imagePath??"", color: ColorManager.white,)
          ),
        ),
      ),
    );
  }
}
