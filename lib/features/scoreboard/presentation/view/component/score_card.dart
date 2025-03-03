import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class ScoreCard extends StatefulWidget {
  const ScoreCard({Key? key}) : super(key: key);

  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  int _teamAFirstDigit = 4;
  int _teamASecondDigit = 3;

  int _teamBFirstDigit = 4;
  int _teamBSecondDigit = 3;


  // Function to increment a digit
  void _incrementDigit(int team, String digit) {
    setState(() {

      if (team == 1) {
        if (digit == 'first' && _teamAFirstDigit < 9) {
          _teamAFirstDigit++;
        } else if (digit == 'second' && _teamASecondDigit < 9) {
          _teamASecondDigit++;
        }
      } else {
        if (digit == 'first' && _teamBFirstDigit < 9) {
          _teamBFirstDigit++;
        } else if (digit == 'second' && _teamBSecondDigit < 9) {
          _teamBSecondDigit++;
        }
      }
    });
  }

  // Function to decrement a digit
  void _decrementDigit(int team, String digit) {
    setState(() {

      if (team == 1) {
        if (digit == 'first' && _teamAFirstDigit > 0) {
          _teamAFirstDigit--;
        } else if (digit == 'second' && _teamASecondDigit > 0) {
          _teamASecondDigit--;
        }
      } else {
        if (digit == 'first' && _teamBFirstDigit > 0) {
          _teamBFirstDigit--;
        } else if (digit == 'second' && _teamBSecondDigit > 0) {
          _teamBSecondDigit--;
        }
      }
    });
  }

  // Helper widget to create a custom transition for each digit
  Widget _buildDigitColumn(int team, String digit) {
    int digitValue = (team == 1)
        ? (digit == 'first' ? _teamAFirstDigit : _teamASecondDigit)
        : (digit == 'first' ? _teamBFirstDigit : _teamBSecondDigit);

    return Padding(
      padding:  EdgeInsets.symmetric(vertical: AppSize.s8, horizontal: AppSize.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedFlipCounter(
            value: digitValue,
            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: AppSize.s160,
              fontWeight: FontWeight.bold,
              color: ColorManager.white
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child:  Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: AppSize.s48,),
                onTap: () => _incrementDigit(team, digit),
              ),

              GestureDetector(
                child:  Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: AppSize.s48,),
                onTap: () => _decrementDigit(team, digit),
              ),

            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
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
                        value: _teamAFirstDigit,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: AppSize.s160,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between digits
                      AnimatedFlipCounter(
                        value: _teamASecondDigit,
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
                        value: _teamBFirstDigit,
                        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: AppSize.s160,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between digits
                      AnimatedFlipCounter(
                        value: _teamBSecondDigit,
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