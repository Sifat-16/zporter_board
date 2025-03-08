import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/animation/animation_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState>{
  AnimationBloc():
        super(AnimationInitialState()){
        on<AnimationSaveEvent>(_animationSave);
        on<PlayAnimationEvent>(_playAnimation);

  }

  List<AnimationModel> animations = [];


  FutureOr<void> _animationSave(AnimationSaveEvent event, Emitter<AnimationState> emit) {
    AnimationModel animationModel = AnimationModel(id: event.animationModel.id, items: event.animationModel.items, index: animations.length+1);
    animations.add(animationModel);
    emit(AnimationSavedState(animations: List.from(animations)));
  }

  FutureOr<void> _playAnimation(PlayAnimationEvent event, Emitter<AnimationState> emit) {
    emit(PlayAnimationState(animations: animations));
  }
}