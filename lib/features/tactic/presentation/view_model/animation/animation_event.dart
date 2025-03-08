import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/animation/animation_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';

sealed class AnimationEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AnimationLoadEvent extends AnimationEvent{
  final List<AnimationModel> animations;

  AnimationLoadEvent({required this.animations});

  @override
  // TODO: implement props
  List<Object?> get props => [animations];
}

class AnimationSaveEvent extends AnimationEvent{
  final AnimationModel animationModel;

  AnimationSaveEvent({required this.animationModel});

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class PlayAnimationEvent extends AnimationEvent{



  PlayAnimationEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}



