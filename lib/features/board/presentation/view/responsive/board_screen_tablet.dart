import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/scoreboard_screen.dart';

class BoardScreenTablet extends StatefulWidget {
  const BoardScreenTablet({super.key});

  @override
  State<BoardScreenTablet> createState() => _BoardScreenTabletState();
}

class _BoardScreenTabletState extends State<BoardScreenTablet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  // List of tab names and content to display
  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Scoreboard', 'content': ScoreBoardScreen()},
    {'title': 'Time', 'content': 'Time Content'},
    {'title': 'Substitute', 'content': 'Substitute Content'},
    {'title': 'Tactic', 'content': 'Tactic Content'},
    {'title': 'Analytics', 'content': 'Analytics Content'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the TabController
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();

    // Sync TabBar with PageView swipe
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        backgroundColor: ColorManager.black,

        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            AssetsManager.logo,
            height: AppSize.s24,
            width: AppSize.s24,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: [
            TabBar(
              controller: _tabController,
              labelColor: ColorManager.yellow,
              padding: EdgeInsets.zero,
              unselectedLabelColor: ColorManager.white,
              indicatorColor: ColorManager.transparent, // Remove the indicator line
              labelPadding: EdgeInsets.symmetric(horizontal: AppSize.s16), // Remove padding between tab labels
              isScrollable: true,
              dividerHeight: 0,


              tabs: _tabs.map((tab) {
                return Tab(
                  text: tab['title'],
                );
              }).toList(),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index); // Sync TabBar with PageView
        },
        children: _tabs.map((tab) {
          dynamic type = tab['content'];
          if(type is Widget){
            return type;
          }
          return Center(
            child: Text(
              tab['content'],
              style: TextStyle(color: ColorManager.white),
            ),
          );
        }).toList(),
      ),
    );
  }
}
