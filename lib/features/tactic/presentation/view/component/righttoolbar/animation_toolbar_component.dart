import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_mini_component.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_state.dart';

class AnimationToolbarComponent extends StatefulWidget {
  const AnimationToolbarComponent({super.key});

  @override
  State<AnimationToolbarComponent> createState() => _AnimationToolbarComponentState();
}

class _AnimationToolbarComponentState extends State<AnimationToolbarComponent> with AutomaticKeepAliveClientMixin {
  List<AnimationModel> animations = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<AnimationBloc, AnimationState>(
      listener: (BuildContext context, Object? state) {
        if(state is AnimationSavedState){
          debug(data: "Animation is saved");
          setState(() {
            animations = state.animations;
          });
        }
      },
      builder: (context, state) {
        return ListView.builder(
            itemCount: animations.length,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                  child: FieldMiniComponent(itemPosition: animations[index].items));
            }
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
