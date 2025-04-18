import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_event.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardState.initial()) {
    on<BoardInitialized>(_onBoardInitialized);
    on<ScreenChangeEvent>(_changeScreen);
  }

  FutureOr<void> _changeScreen(
    ScreenChangeEvent event,
    Emitter<BoardState> emit,
  ) {
    emit(BoardState(selectedScreen: event.selectedScreen));
  }

  FutureOr<void> _onBoardInitialized(
    BoardInitialized event,
    Emitter<BoardState> emit,
  ) {
    emit(state);
  }
}
