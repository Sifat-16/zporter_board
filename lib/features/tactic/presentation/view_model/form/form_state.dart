import 'package:equatable/equatable.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/common/arrow_head.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/equiqment/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/player/PlayerDataModel.dart';

sealed class FormState extends Equatable{
  @override
  List<Object?> get props => [];
}

class FormInitialState extends FormState{

}


class FormLoadedState extends FormState{
  final List<FormDataModel> forms;

  FormLoadedState({required this.forms});

  @override
  // TODO: implement props
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch,forms];
}

class FormAddedToFieldState extends FormState{
  final FormDataModel formDataModel;
  final String forceEmitKey;

  FormAddedToFieldState({required this.formDataModel, String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [formDataModel, forceEmitKey];
}


class ArrowAddedToFieldState extends FormState{
  final ArrowHead arrowHead;
  final String forceEmitKey;

  ArrowAddedToFieldState({required this.arrowHead, String? forceEmitKey}):forceEmitKey=forceEmitKey??DateTime.now().toIso8601String();

  @override
  // TODO: implement props
  List<Object?> get props => [arrowHead, forceEmitKey];
}