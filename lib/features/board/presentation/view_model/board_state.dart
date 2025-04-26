import 'package:zporter_board/features/board/presentation/view/components/board_menu_component.dart';

class BoardState {
  final Screens selectedScreen;
  const BoardState({required this.selectedScreen});
  factory BoardState.initial() {
    return const BoardState(selectedScreen: Screens.TACTICS);
  }

  BoardState copyWith({
    Screens? selectedScreen, // Parameter is nullable
  }) {
    return BoardState(selectedScreen: selectedScreen ?? this.selectedScreen);
  }
}
