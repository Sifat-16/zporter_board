import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';

class ScoreCard extends StatefulWidget {
  const ScoreCard({Key? key, required this.matchScore, required this.updateMatchScore}) : super(key: key);
  final MatchScore? matchScore;
  final Function(MatchScore matchScore) updateMatchScore;

  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initiate();

  }

  @override
  void didUpdateWidget(covariant ScoreCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _initiate();
  }




  _initiate(){
    MatchScore? matchScore = widget.matchScore;

    if(matchScore!=null){
      _teamHomeFirstDigit = (matchScore.homeScore/10).toInt();
      _teamHomeSecondDigit = matchScore.homeScore%10;

      _teamAwayFirstDigit = (matchScore.awayScore/10).toInt();
      _teamAwaySecondDigit = matchScore.awayScore%10;
    }

  }

  int _teamHomeFirstDigit = 0;
  int _teamHomeSecondDigit = 0;

  int _teamAwayFirstDigit = 0;
  int _teamAwaySecondDigit = 0;


  //duplicate for update
  int _teamHomeFirstDigitDuplicate = 0;
  int _teamHomeSecondDigitDuplicate = 0;

  int _teamAwayFirstDigitDuplicate = 0;
  int _teamAwaySecondDigitDuplicate = 0;


  initiateDuplicates(){
    _teamHomeFirstDigitDuplicate = _teamHomeFirstDigit;
    _teamHomeSecondDigitDuplicate = _teamHomeSecondDigit;

    _teamAwayFirstDigitDuplicate = _teamAwayFirstDigit;
    _teamAwaySecondDigitDuplicate = _teamAwaySecondDigit;
  }

  // Function to increment a digit
  void _incrementDigit(int team, String digit) {

    initiateDuplicates();

    if (team == 1) {
      if (digit == 'first' && _teamHomeFirstDigit < 9) {
        _teamHomeFirstDigitDuplicate++;
      } else if (digit == 'second' && _teamHomeSecondDigit < 9) {
        _teamHomeSecondDigitDuplicate++;
      }
    } else {
      if (digit == 'first' && _teamAwayFirstDigit < 9) {
        _teamAwayFirstDigitDuplicate++;
      } else if (digit == 'second' && _teamAwaySecondDigit < 9) {
        _teamAwaySecondDigitDuplicate++;
      }
    }

    _updateMatchScore();

  }

  // Function to decrement a digit
  void _decrementDigit(int team, String digit) {
    initiateDuplicates();
    if (team == 1) {
      if (digit == 'first' && _teamHomeFirstDigit > 0) {
        _teamHomeFirstDigitDuplicate--;
      } else if (digit == 'second' && _teamHomeSecondDigit > 0) {
        _teamHomeSecondDigitDuplicate--;
      }
    } else {
      if (digit == 'first' && _teamAwayFirstDigit > 0) {
        _teamAwayFirstDigitDuplicate--;
      } else if (digit == 'second' && _teamAwaySecondDigit > 0) {
        _teamAwaySecondDigitDuplicate--;
      }
    }

    _updateMatchScore();
  }


  _updateMatchScore(){
    MatchScore matchScore = MatchScore(
        homeScore: (_teamHomeFirstDigitDuplicate*10)+_teamHomeSecondDigitDuplicate,
        awayScore: (_teamAwayFirstDigitDuplicate*10)+_teamAwaySecondDigitDuplicate
    );
    widget.updateMatchScore(matchScore);
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scores Row (Team A — Team B)
            Row(
              children: [
                // Team A Score
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AnimatedFlipCounter(
                        value: _teamHomeFirstDigit,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: AppSize.s160,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between digits
                      AnimatedFlipCounter(
                        value: _teamHomeSecondDigit,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: AppSize.s160,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Big Dash
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust spacing around the dash
                  child: Text(
                    '—',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: AppSize.s160, // Match the score size
                      fontWeight: FontWeight.bold,
                      color: ColorManager.white,
                    ),
                  ),
                ),

                // Team B Score
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AnimatedFlipCounter(
                        value: _teamAwayFirstDigit,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: AppSize.s160,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between digits
                      AnimatedFlipCounter(
                        value: _teamAwaySecondDigit,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: AppSize.s160,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Buttons Row (Team A and Team B buttons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Team A Buttons
                _buildButtonColumn(1, 'first'),
                const SizedBox(width: 30), // Space between buttons
                _buildButtonColumn(1, 'second'),
                const SizedBox(width: 120), // Space between teams




                // Team B Buttons
                _buildButtonColumn(2, 'first'),
                const SizedBox(width: 30), // Space between buttons
                _buildButtonColumn(2, 'second'),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Helper widget to create buttons for each digit
  Widget _buildButtonColumn(int team, String digit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: AppSize.s48),
          onTap: () => _incrementDigit(team, digit),
        ),
        GestureDetector(
          child: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: AppSize.s48),
          onTap: () => _decrementDigit(team, digit),
        ),
      ],
    );
  }
}