// import 'package:flutter/cupertino.dart';
// import 'package:multi_split_view/multi_split_view.dart';
// import 'package:zporter_board/core/extension/size_extension.dart';
// import 'package:zporter_board/features/analytics/presentation/view/component/analytics_board/analytics_board_component.dart';
// import 'package:zporter_board/features/analytics/presentation/view/component/righttoolbar/right_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/field_component/field_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/lefttoolbar/lefttoolbar_component.dart';
//
// class AnalyticsScreenTablet extends StatefulWidget {
//   const AnalyticsScreenTablet({super.key});
//
//   @override
//   State<AnalyticsScreenTablet> createState() => _AnalyticsScreenTabletState();
// }
//
// class _AnalyticsScreenTabletState extends State<AnalyticsScreenTablet> {
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiSplitView(initialAreas: [
//       Area(
//           flex: 1,
//           max: 1,
//           builder: (context, area) {
//             return LefttoolbarComponent();
//           }
//       ),
//       Area(
//           flex: 3,
//           max: 3,
//           builder: (context, area) {
//             return AnalyticsBoardComponent();
//           }
//       ),
//       Area(
//           flex: 1,
//           max: 1,
//           builder: (context, area) {
//             return RighttoolbarComponent();
//           }
//
//       )
//     ]
//     );
//   }
// }
