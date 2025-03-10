import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';

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

class AnimationDatabaseSaveEvent extends AnimationEvent{
  final AnimationDataModel animationDataModel;

  AnimationDatabaseSaveEvent({required this.animationDataModel});

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class LoadAnimationEvent extends AnimationEvent{


  LoadAnimationEvent();

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

class AnimationSelectEvent extends AnimationEvent{
  final int index;
  AnimationSelectEvent({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class AnimationUpdateEvent extends AnimationEvent{

}



