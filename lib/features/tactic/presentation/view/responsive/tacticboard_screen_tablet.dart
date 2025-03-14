import 'package:flutter/cupertino.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_component.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/lefttoolbar/lefttoolbar_component.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/righttoolbar/righttoolbar_component.dart';

class TacticboardScreenTablet extends StatefulWidget {
  const TacticboardScreenTablet({super.key});

  @override
  State<TacticboardScreenTablet> createState() => _TacticboardScreenTabletState();
}

class _TacticboardScreenTabletState extends State<TacticboardScreenTablet> {

  @override
  Widget build(BuildContext context) {
    return MultiSplitView(initialAreas: [
      Area(
          flex: 1,
          max: 1,
          builder: (context, area) {
            return LefttoolbarComponent();
          }
      ),
      Area(
          flex: 3,
          max: 3,
          builder: (context, area) {
            return FieldComponent();
          }
      ),
      Area(
          flex: 1,
          max: 1,
          builder: (context, area) {
            return RighttoolbarComponent();
          }

      )
    ]
    );
  }
}
