import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as md hide State;
import 'package:uuid/uuid.dart';
import 'package:zporter_board/config/database/remote/mongodb.dart';

import 'package:zporter_board/core/constant/mongo_constant.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/services/injection_container.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/analytics/presentation/view/analytics_screen.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/data/model/team.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
import 'package:zporter_board/features/scoreboard/presentation/view/scoreboard_screen.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_board/features/substitute/presentation/view/substituteboard_screen.dart';
import 'package:zporter_board/features/tactic/presentation/view/tacticboard_screen.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_board/features/time/presentation/view/timeboard_screen.dart';

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
    {'title': 'Time', 'content': TimeboardScreen()},
    {'title': 'Substitute', 'content': SubstituteboardScreen()},
    {'title': 'Tactic', 'content': TacticboardScreen()},
    {'title': 'Analytics', 'content': AnalyticsScreen()},
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
        physics: NeverScrollableScrollPhysics(),
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


class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  // Function to generate random players
  List<Player> generatePlayers(String teamName) {
    List<Player> players = [];
    for (int i = 1; i <= 11; i++) {
      players.add(
        Player(
          name: "$teamName Player $i",
          position: ["GK", "DF", "MF", "FW"][Random().nextInt(4)],
          jerseyNumber: i,
        ),
      );
    }
    return players;
  }

  // Function to generate linked list-like match time periods
  List<MatchTime> generateMatchTimes() {
    DateTime now = DateTime.now();
    Uuid uuid = Uuid();

    String firstHalfId = uuid.v4();
    String secondHalfId = uuid.v4();
    String extraTimeId = uuid.v4();
    String penaltyId = uuid.v4();

    return [
      MatchTime(
        id: firstHalfId,
        nextId: secondHalfId,
        startTime: now.subtract(Duration(minutes: 45)),
        endTime: now.subtract(Duration(minutes: 1))
      ),
      MatchTime(
        id: secondHalfId,
        nextId: extraTimeId,
        startTime: now,
        endTime: now.add(Duration(minutes: 45))
      ),
      MatchTime(
        id: extraTimeId,
        nextId: penaltyId,
        startTime: now.add(Duration(minutes: 46)),
        endTime: now.add(Duration(minutes: 60))
      ),
      MatchTime(
        id: penaltyId,
        nextId: null, // No next period after penalties
        startTime: now.add(Duration(minutes: 61)),
        endTime: now.add(Duration(minutes: 70))
      ),
    ];
  }

  // Function to generate dummy matches
  List<FootballMatch> generateDummyMatches() {
    List<String> teamNames = [
      "Real Madrid", "Barcelona", "Manchester City", "Bayern Munich",
      "Liverpool", "Chelsea", "Juventus", "AC Milan", "Inter Milan",
      "PSG", "Arsenal", "Tottenham", "Borussia Dortmund", "Atletico Madrid",
      "Napoli", "Leipzig", "Sevilla", "Roma", "Ajax", "Benfica"
    ];

    List<FootballMatch> matches = [];

    for (int i = 0; i < 20; i++) {
      String homeTeamName = teamNames[i % teamNames.length];
      String awayTeamName = teamNames[(i + 1) % teamNames.length];

      matches.add(FootballMatch(

        name: "$homeTeamName vs $awayTeamName",
        matchTime: generateMatchTimes(), // Add multiple time phases
        status: ["Not Started", "Live", "Halftime", "Ended"][Random().nextInt(4)],
        homeTeam: Team(name: homeTeamName, players: generatePlayers(homeTeamName)),
        awayTeam: Team(name: awayTeamName, players: generatePlayers(awayTeamName)),
        matchScore: MatchScore(
          homeScore: Random().nextInt(5),
          awayScore: Random().nextInt(5),
        ),
        substitutions: MatchSubstitutions(),
        venue: "Stadium ${(i + 1)}", id: md.ObjectId(),
      ));
    }
    return matches;
  }

  // Function to insert matches into MongoDB
  Future<void> insertMatches(List<FootballMatch> matches) async {
    MongoDB mongoDB = sl.get();
    md.DbCollection? matchCollection = mongoDB.db?.collection(MongoConstant.MATCH_COLLECTION);

    if (matchCollection == null) return;

    // Remove existing matches
    await matchCollection.deleteMany({});

    // Insert new matches
    List<Map<String, dynamic>> bulkData = matches.map((match) => match.toJson()).toList();
    await matchCollection.insertAll(bulkData);

    final insertedMatches = await matchCollection.find().toList();

    debug(data: "Inserted Matches IDs: ${insertedMatches.map((m) => m['_id']).toList()}");

    print("20 matches inserted successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () async {
          List<FootballMatch> matches = generateDummyMatches();
          await insertMatches(matches);
        },
        child: Text("Generate data"),
      ),
    );
  }
}
