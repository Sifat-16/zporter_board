import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';

sealed class EquipmentState extends Equatable{
  @override
  List<Object?> get props => [];
}

class EquipmentInitialState extends EquipmentState{

}


class EquipmentLoadedState extends EquipmentState{
  final List<EquipmentDataModel> equipments;

  EquipmentLoadedState({required this.equipments});

  @override
  // TODO: implement props
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch,equipments];
}

class EquipmentAddedToFieldState extends EquipmentState{
  final EquipmentDataModel equipment;
  final String forceEmitKey;

  EquipmentAddedToFieldState({required this.equipment, String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [equipment, forceEmitKey];
}


