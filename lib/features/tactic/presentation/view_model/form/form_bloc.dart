import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/model/arrow_head.dart';
import 'package:zporter_board/features/tactic/data/model/equipment_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/form_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/PlayerDataModel.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_state.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_state.dart';

class FormBloc extends Bloc<FormEvent, FormState>{
  FormBloc():
        super(FormInitialState()){

    on<FormLoadEvent>(_onFormLoad);
    on<FormAddToFieldEvent>(_onFormAdded);
    on<ArrowHeadAddEvent>(_onAddArrowHead);

  }

  List<FormDataModel> forms = [];
  List<FormDataModel> using = [];
  List<ArrowHead> arrows = [];

  FutureOr<void> _onFormLoad(FormLoadEvent event, Emitter<FormState> emit) {
    forms = event.forms;
    emit(FormLoadedState(forms: List.from(forms)));
  }

  FutureOr<void> _onFormAdded(FormAddToFieldEvent event, Emitter<FormState> emit) {
    using.add(event.formDataModel);
    emit(FormAddedToFieldState(formDataModel: event.formDataModel));
  }


  FutureOr<void> _onAddArrowHead(ArrowHeadAddEvent event, Emitter<FormState> emit) {
    arrows.add(event.arrowHead);
    emit(ArrowAddedToFieldState(arrowHead: event.arrowHead));
  }
}