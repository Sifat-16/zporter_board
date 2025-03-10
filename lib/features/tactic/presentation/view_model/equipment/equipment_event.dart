import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';

sealed class EquipmentEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EquipmentLoadEvent extends EquipmentEvent{
  final List<EquipmentDataModel> equipments;

  EquipmentLoadEvent({required this.equipments});

  @override
  // TODO: implement props
  List<Object?> get props => [equipments];
}

class EquipmentAddToFieldEvent extends EquipmentEvent{
  final EquipmentDataModel equipmentDataModel;
  EquipmentAddToFieldEvent({required this.equipmentDataModel});
  @override
  // TODO: implement props
  List<Object?> get props => [equipmentDataModel];
}


