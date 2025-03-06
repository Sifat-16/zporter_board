import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class SubstituteComponent extends StatefulWidget {
  const SubstituteComponent({super.key});

  @override
  State<SubstituteComponent> createState() => _SubstituteComponentState();
}

class _SubstituteComponentState extends State<SubstituteComponent> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Scores Row (Team A — Team B)
          Row(
            children: [
              // Team A Score
              Flexible(
                flex: 1,
                child: Container(
                  width: context.widthPercent(50),
                  height: context.heightPercent(50),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ),
              ),

              // // Big Dash
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: FittedBox(
              //     fit: BoxFit.fitWidth,
              //     child: Text(
              //       '—',
              //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //         fontSize: AppSize.s160,
              //         fontWeight: FontWeight.bold,
              //         color: ColorManager.white,
              //       ),
              //     ),
              //   ),
              // ),

              // Team B Score
              Flexible(
                flex: 1,
                child: Container(
                  width: context.widthPercent(50),
                  height: context.heightPercent(50),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
