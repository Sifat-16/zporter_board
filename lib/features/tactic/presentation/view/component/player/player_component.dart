import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/focused_item_component.dart';

import 'PlayerDataModel.dart';

class PlayerComponent extends StatefulWidget {
  const PlayerComponent({super.key, required this.playerDataModel, this.activateFocus=false});

  final PlayerModel playerDataModel;
  final bool activateFocus;

  @override
  State<PlayerComponent> createState() => _PlayerComponentState();
}

class _PlayerComponentState extends State<PlayerComponent> {
  bool _isFocused = false;

  void _setFocus(bool focus) {
    setState(() {
      _isFocused = focus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusedItemComponent(
      draggableItem: widget.playerDataModel,
      isFocused: _isFocused,
      onFocusChanged: _setFocus,
      focusActivated: widget.activateFocus,
      child: GestureDetector(
        onTap: () => _setFocus(!_isFocused),
        child: Draggable<PlayerModel>(
          data: widget.playerDataModel,
          onDragStarted: () => _setFocus(true),
          onDragEnd: (_) => _setFocus(false),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: _buildPlayerComponent(),
          ),
          feedback: Material(
            color: Colors.transparent,
            child: _buildPlayerComponent(),
          ),
          child: _buildPlayerComponent(),
        ),
      ),
    );
  }

  Widget _buildPlayerComponent() {
    return RepaintBoundary(
      key: UniqueKey(),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppSize.s8),
          decoration: BoxDecoration(
            color: widget.playerDataModel.playerType == PlayerType.HOME
                ? ColorManager.blueAccent
                : ColorManager.red,
            borderRadius: BorderRadius.circular(AppSize.s4),
            // border: _isFocused
            //     ? Border.all(color: Colors.yellow, width: 3)
            //     : null, // Add border if focused
          ),
          child: SizedBox(
            height: AppSize.s32,
            width: AppSize.s32,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.playerDataModel.role,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "${widget.playerDataModel.index}",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: ColorManager.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
