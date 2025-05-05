import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/container/dynamic_container.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
// --- Assumed Imports (replace with your actual paths) ---
// You might not need SizeExtension if font size is determined differently now
// import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';
// --- End of Assumed Imports ---

class ScoreCard extends StatefulWidget {
  const ScoreCard({
    super.key, // Use super parameters
    required this.matchScore,
    required this.updateMatchScore,
  });
  final MatchScore? matchScore;
  final Function(MatchScore matchScore) updateMatchScore;

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  // State variables to hold the complete scores
  int _homeScore = 0;
  int _awayScore = 0;

  // Maximum score allowed (Adjust if 100 is inclusive or exclusive)
  final int _maxScore = 99; // Allows scores 0 through 100
  // Minimum score allowed
  final int _minScore = 0;

  @override
  void initState() {
    super.initState();
    _updateScoresFromWidget();
  }

  @override
  void didUpdateWidget(covariant ScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state if the input widget's score changes
    if (widget.matchScore != oldWidget.matchScore) {
      _updateScoresFromWidget();
    }
  }

  // Helper to update internal state from widget property
  void _updateScoresFromWidget() {
    // Ensure score stays within bounds when updating from widget
    final initialHomeScore = widget.matchScore?.homeScore ?? 0;
    final initialAwayScore = widget.matchScore?.awayScore ?? 0;
    setState(() {
      _homeScore = initialHomeScore.clamp(_minScore, _maxScore);
      _awayScore = initialAwayScore.clamp(_minScore, _maxScore);
    });
  }

  // Function to increment the score for a team
  void _incrementScore(int team) {
    setState(() {
      if (team == 1 && _homeScore < _maxScore) {
        _homeScore++;
      } else if (team == 2 && _awayScore < _maxScore) {
        _awayScore++;
      } else {
        // Optional: Add feedback if max score reached
        print("Max score reached for team $team");
      }
    });
    _triggerUpdate();
  }

  // Function to decrement the score for a team
  void _decrementScore(int team) {
    setState(() {
      if (team == 1 && _homeScore > _minScore) {
        _homeScore--;
      } else if (team == 2 && _awayScore > _minScore) {
        _awayScore--;
      } else {
        // Optional: Add feedback if min score reached
        print("Min score reached for team $team");
      }
    });
    _triggerUpdate();
  }

  // Function to call the update callback from the parent widget
  void _triggerUpdate() {
    final updatedMatchScore = MatchScore(
      homeScore: _homeScore,
      awayScore: _awayScore,
    );
    widget.updateMatchScore(updatedMatchScore);
  }

  @override
  Widget build(BuildContext context) {
    // Define a base text style - Give it a large font size initially.
    // FittedBox will scale it down. AppSize.s160 is used as the base.
    final baseScoreTextStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
      // fontSize: context.screenHeight * .80, // Start with a large size
      fontWeight: FontWeight.bold,
      color: ColorManager.white,
      fontFamily: 'monospaced',
      // height:
      //     1.0, // Explicitly set line height to prevent issues with large fonts
    );

    // Define the style for the dash separately
    // Use a smaller, potentially fixed size if you don't want it to scale with the numbers
    final dashTextStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
      fontSize: context.widthPercent(
        10,
      ), // Example: Smaller fixed size for dash
      fontWeight: FontWeight.bold,
      color: ColorManager.white,
      // height: 1.0,
    );

    return DynamicContainer(
      builder: (context, height, width) {
        return Center(
          child: Container(
            // padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Scores Row (Team A — Team B)
                SizedBox(
                  height: height * .85,

                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * .85,
                        width: context.widthPercent(40),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            children: [
                              if (_isSingleDigit(_homeScore))
                                Opacity(
                                  opacity: 0,
                                  child: AnimatedFlipCounter(
                                    value: _homeScore,
                                    textStyle:
                                        baseScoreTextStyle, // Use the large base style
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                ),
                              AnimatedFlipCounter(
                                value: _homeScore,
                                textStyle:
                                    baseScoreTextStyle, // Use the large base style
                                duration: const Duration(milliseconds: 300),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // const SizedBox(height: 20), // Space before buttons
                      // Big Dash
                      SizedBox(
                        height: height * .85,
                        width: context.widthPercent(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ), // Adjust horizontal space
                          // Center the dash vertically within the IntrinsicHeight
                          child: Center(child: Text('—', style: dashTextStyle)),
                        ),
                      ),

                      // const SizedBox(height: 20), // Space before buttons
                      SizedBox(
                        height: height * .85,
                        width: context.widthPercent(40),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            children: [
                              AnimatedFlipCounter(
                                value: _awayScore,
                                textStyle:
                                    baseScoreTextStyle, // Use the large base style
                                duration: const Duration(milliseconds: 300),
                              ),

                              if (_isSingleDigit(_awayScore))
                                Opacity(
                                  opacity: 0,
                                  child: AnimatedFlipCounter(
                                    value: _awayScore,
                                    textStyle:
                                        baseScoreTextStyle, // Use the large base style
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: height * .15,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreControls(1, height * .15),
                      _buildScoreControls(2, height * .15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget to create increment/decrement buttons for a team
  Widget _buildScoreControls(int team, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _incrementScore(team),
          child: Icon(
            Icons.keyboard_arrow_up,
            size: height,
            color: ColorManager.grey, // Make sure ColorManager.grey is defined
          ),
        ),
        GestureDetector(
          onTap: () => _decrementScore(team),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: height,
            color: ColorManager.grey, // Make sure ColorManager.grey is defined
          ),
        ),
      ],
    );
  }

  bool _isSingleDigit(int number) {
    return number >= 0 && number <= 9;
  }
}
