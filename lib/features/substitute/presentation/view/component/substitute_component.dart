import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';

class SubstituteComponent extends StatefulWidget {
  const SubstituteComponent({
    super.key,
    required this.substitution,
    required this.onSubUpdate,
  });

  final Substitution substitution;
  final Function(Substitution) onSubUpdate;

  @override
  State<SubstituteComponent> createState() => _SubstituteComponentState();
}

class _SubstituteComponentState extends State<SubstituteComponent> {
  int _outFirstDigit = 4;
  int _outSecondDigit = 3;

  int _inFirstDigit = 4;
  int _inSecondDigit = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      _extractSub(widget.substitution);
    });
  }

  @override
  void didUpdateWidget(covariant SubstituteComponent oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.substitution != widget.substitution) {
      _extractSub(widget.substitution);
    }
  }

  _updateSub() {
    Substitution substitution = widget.substitution.copyWith(
      playerOutId: "${_outFirstDigit}${_outSecondDigit}",
      playerInId: "${_inFirstDigit}${_inSecondDigit}",
    );
    widget.onSubUpdate.call(substitution);
  }

  _extractSub(Substitution sub) {
    setState(() {
      _outFirstDigit = (int.parse(sub.playerOutId) / 10).toInt();
      _outSecondDigit = (int.parse(sub.playerOutId) % 10).toInt();
      _inFirstDigit = (int.parse(sub.playerInId) / 10).toInt();
      _inSecondDigit = (int.parse(sub.playerInId) % 10).toInt();
    });
  }

  // Function to increment a digit
  void _incrementDigit(int team, String digit) {
    setState(() {
      if (team == 1) {
        if (digit == 'first' && _outFirstDigit < 9) {
          _outFirstDigit++;
        } else if (digit == 'second' && _outSecondDigit < 9) {
          _outSecondDigit++;
        }
      } else {
        if (digit == 'first' && _inFirstDigit < 9) {
          _inFirstDigit++;
        } else if (digit == 'second' && _inSecondDigit < 9) {
          _inSecondDigit++;
        }
      }
    });
    _updateSub();
  }

  // Function to decrement a digit
  void _decrementDigit(int team, String digit) {
    setState(() {
      if (team == 1) {
        if (digit == 'first' && _outFirstDigit > 0) {
          _outFirstDigit--;
        } else if (digit == 'second' && _outSecondDigit > 0) {
          _outSecondDigit--;
        }
      } else {
        if (digit == 'first' && _inFirstDigit > 0) {
          _inFirstDigit--;
        } else if (digit == 'second' && _inSecondDigit > 0) {
          _inSecondDigit--;
        }
      }
    });

    _updateSub();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
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
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedFlipCounter(
                          value: _outFirstDigit,
                          textStyle: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontSize: AppSize.s128,
                            fontWeight: FontWeight.bold,
                            color:
                                _outFirstDigit == 0
                                    ? ColorManager.transparent
                                    : ColorManager.white,
                          ),
                        ),
                        const SizedBox(width: 10), // Space between digits
                        AnimatedFlipCounter(
                          value: _outSecondDigit,
                          textStyle: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontSize: AppSize.s128,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

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
                          value: _inFirstDigit,
                          textStyle: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontSize: AppSize.s128,
                            fontWeight: FontWeight.bold,
                            color:
                                _inFirstDigit == 0
                                    ? ColorManager.transparent
                                    : ColorManager.white,
                          ),
                        ),
                        const SizedBox(width: 10), // Space between digits
                        AnimatedFlipCounter(
                          value: _inSecondDigit,
                          textStyle: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontSize: AppSize.s128,
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
          child: Icon(
            Icons.keyboard_arrow_up,
            color: ColorManager.grey,
            size: AppSize.s48,
          ),
          onTap: () => _incrementDigit(team, digit),
        ),
        GestureDetector(
          child: Icon(
            Icons.keyboard_arrow_down,
            color: ColorManager.grey,
            size: AppSize.s48,
          ),
          onTap: () => _decrementDigit(team, digit),
        ),
      ],
    );
  }
}
