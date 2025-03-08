import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/animation/animation_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/PlayerDataModel.dart';

sealed class AnimationState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AnimationInitialState extends AnimationState{

}


class AnimationLoadedState extends AnimationState{
  final List<AnimationModel> animations;

  AnimationLoadedState({required this.animations});

  @override
  // TODO: implement props
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch,animations];
}

class AnimationSavedState extends AnimationState{
  final List<AnimationModel> animations;
  final String forceEmitKey;

  AnimationSavedState({required this.animations, String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [forceEmitKey,animations];
}

class PlayAnimationState extends AnimationState{
  final List<AnimationModel> animations;
  final String forceEmitKey;

  PlayAnimationState({required this.animations, String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [forceEmitKey,animations];
}




