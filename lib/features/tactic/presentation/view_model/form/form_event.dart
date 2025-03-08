import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_data_model.dart';

sealed class FormEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FormLoadEvent extends FormEvent{
  final List<FormDataModel> forms;

  FormLoadEvent({required this.forms});

  @override
  // TODO: implement props
  List<Object?> get props => [forms];
}

class FormAddToFieldEvent extends FormEvent{
  final FormDataModel formDataModel;
  FormAddToFieldEvent({required this.formDataModel});
  @override
  // TODO: implement props
  List<Object?> get props => [formDataModel];
}

class ArrowHeadAddEvent extends FormEvent{
  final ArrowHead arrowHead;
  ArrowHeadAddEvent({required this.arrowHead});
  @override
  // TODO: implement props
  List<Object?> get props => [arrowHead];
}


