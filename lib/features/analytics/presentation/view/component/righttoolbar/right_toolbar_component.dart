// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
// import 'package:zporter_board/core/resource_manager/values_manager.dart';
// import 'package:zporter_board/features/analytics/presentation/view/component/righttoolbar/highlight_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/lefttoolbar/equipment_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/lefttoolbar/forms_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/lefttoolbar/players_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/righttoolbar/animation_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/righttoolbar/design_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/righttoolbar/saved_animation_toolbar_component.dart';
// import 'package:zporter_board/features/tactic/presentation/view/component/righttoolbar/settings_toolbar_component.dart';
//
// class RighttoolbarComponent extends StatefulWidget {
//   const RighttoolbarComponent({super.key});
//
//   @override
//   State<RighttoolbarComponent> createState() => _RighttoolbarComponentState();
// }
//
// class _RighttoolbarComponentState extends State<RighttoolbarComponent> with SingleTickerProviderStateMixin {
//
//   late TabController _tabController;
//   late PageController _pageController;
//
//   // List of tab names and content to display
//   final List<Map<String, dynamic>> _tabs = [
//     {'title': 'All', 'content': Container()},
//     {'title': 'Highlights', 'content': HighlightToolbarComponent()},
//     {'title': 'Yours', 'content': Container()}
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the TabController
//     _tabController = TabController(length: _tabs.length, vsync: this);
//     _pageController = PageController();
//
//     // Sync TabBar with PageView swipe
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         _pageController.jumpToPage(_tabController.index);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           TabBar(
//             controller: _tabController,
//             labelColor: ColorManager.yellow,
//             padding: EdgeInsets.zero,
//             unselectedLabelColor: ColorManager.white,
//             indicatorColor: ColorManager.yellow, // Remove the indicator line
//             labelPadding: EdgeInsets.symmetric(horizontal: AppSize.s8), // Remove padding between tab labels
//             isScrollable: true,
//             dividerHeight: 0,
//             tabs: _tabs.map((tab) {
//               return Tab(
//                 text: tab['title'],
//               );
//             }).toList(),
//
//           ),
//
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                   color: ColorManager.grey.withValues(alpha: 0.1)
//               ),
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   _tabController.animateTo(index); // Sync TabBar with PageView
//                 },
//                 children: _tabs.map((tab) {
//                   dynamic type = tab['content'];
//                   if(type is Widget){
//                     return type;
//                   }
//                   return Center(
//                     child: Text(
//                       tab['content'],
//                       style: TextStyle(color: ColorManager.white),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
