import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/domain/usecase/get_all_animation_usecase.dart';
import 'package:zporter_board/features/tactic/domain/usecase/save_animation_usecase.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState>{

  GetAllAnimationUsecase _getAllAnimationUsecase;
  SaveAnimationUsecase _saveAnimationUsecase;

  AnimationBloc({
    required GetAllAnimationUsecase getAllAnimationUsecase,
    required SaveAnimationUsecase saveAnimationUsecase
}) :
      _getAllAnimationUsecase = getAllAnimationUsecase,
      _saveAnimationUsecase = saveAnimationUsecase,
        super(AnimationInitialState()){
        on<AnimationSaveEvent>(_animationSave);
        on<PlayAnimationEvent>(_playAnimation);
        on<AnimationDatabaseSaveEvent>(_saveAnimationToDatabase);
        on<LoadAnimationEvent>(_loadAnimation);
        on<AnimationSelectEvent>(_onAnimationSelect);
        on<AnimationUpdateEvent>(_onAnimationUpdate);

  }

  List<AnimationModel> animations = [];
  List<AnimationDataModel> animationDataModel = [];
  int selectedIndex=0;


  FutureOr<void> _animationSave(AnimationSaveEvent event, Emitter<AnimationState> emit) {
    AnimationModel animationModel = AnimationModel(id: event.animationModel.id, items: event.animationModel.items, index: animations.length+1);
    animations.add(animationModel);
    emit(AnimationSavedState(animations: List.from(animations)));
  }

  FutureOr<void> _playAnimation(PlayAnimationEvent event, Emitter<AnimationState> emit) {
    emit(PlayAnimationState(animations: animations));
  }

  FutureOr<void> _saveAnimationToDatabase(AnimationDatabaseSaveEvent event, Emitter<AnimationState> emit) async{
    try{
      AnimationDataModel ad = await _saveAnimationUsecase.call(event.animationDataModel);
      animationDataModel.add(ad);
      debug(data: "Saved animation ${ad.id}");
      emit(AnimationUpdateState());
    }catch(e){
      debug(data: "Error while saving animation ${e}");
    }
  }

  FutureOr<void> _loadAnimation(LoadAnimationEvent event, Emitter<AnimationState> emit) async{
    try{
      animationDataModel = await _getAllAnimationUsecase.call(null);
      emit(AnimationUpdateState());
    }catch(e){
      debug(data: "Animation fetch error ${e}");
    }


  }

  FutureOr<void> _onAnimationSelect(AnimationSelectEvent event, Emitter<AnimationState> emit) async{
    selectedIndex = event.index;
    emit(AnimationUpdateState());
  }

  FutureOr<void> _onAnimationUpdate(AnimationUpdateEvent event, Emitter<AnimationState> emit) {
    emit(AnimationUpdateState());
  }
}