import 'package:zporter_board/features/board/presentation/view/components/board_menu_component.dart';

abstract class BoardEvent {}

class ScreenChangeEvent extends BoardEvent {
  Screens selectedScreen;
  ScreenChangeEvent({required this.selectedScreen});
}

class BoardInitialized extends BoardEvent {}
