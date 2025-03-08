import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState>{
  EquipmentBloc():
        super(EquipmentInitialState()){

    on<EquipmentLoadEvent>(_onEquipmentLoad);
    on<EquipmentAddToFieldEvent>(_onEquipmentAdded);

  }

   List<EquipmentDataModel> equipments = [];
   List<EquipmentDataModel> using = [];



  FutureOr<void> _onEquipmentLoad(EquipmentLoadEvent event, Emitter<EquipmentState> emit) {
    equipments = event.equipments;
    emit(EquipmentLoadedState(equipments: List.from(equipments)));

  }

  FutureOr<void> _onEquipmentAdded(EquipmentAddToFieldEvent event, Emitter<EquipmentState> emit) {
    using.add(event.equipmentDataModel);
    emit(EquipmentAddedToFieldState(equipment: event.equipmentDataModel));
  }
}