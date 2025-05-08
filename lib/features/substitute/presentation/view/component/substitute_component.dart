import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/extension/size_extension.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/features/substitute/data/model/substitution.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';

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
  int _outFirstDigit = 1;
  int _outSecondDigit = 1;

  int _inFirstDigit = 1;
  int _inSecondDigit = 2;

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
      child: Row(
        children: [
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  width: context.widthPercent(25),
                  child: Column(
                    children: [
                      Expanded(child: _buildFlipperCounter(_outFirstDigit)),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          zlog(
                            data:
                                "Available button width ${constraints.maxWidth}",
                          );
                          return _buildButtonColumn(1, 'first');
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: context.widthPercent(25),
                  child: Column(
                    children: [
                      Expanded(child: _buildFlipperCounter(_outSecondDigit)),
                      _buildButtonColumn(1, 'second'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  width: context.widthPercent(25),
                  child: Column(
                    children: [
                      Expanded(child: _buildFlipperCounter(_inFirstDigit)),
                      _buildButtonColumn(2, 'first'),
                    ],
                  ),
                ),
                SizedBox(
                  width: context.widthPercent(25),
                  child: Column(
                    children: [
                      Expanded(child: _buildFlipperCounter(_inSecondDigit)),
                      _buildButtonColumn(2, 'second'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // // Scores Row (Team A — Team B)
          // Row(
          //   children: [
          //     // Team A Score
          //     Flexible(
          //       flex: 1,
          //       child: Container(
          //         width: context.widthPercent(50),
          //         height: context.heightPercent(45),
          //         padding: EdgeInsets.symmetric(horizontal: 5),
          //         child: FittedBox(
          //           fit: BoxFit.fitWidth,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               AnimatedFlipCounter(
          //                 value: _outFirstDigit,
          //                 textStyle: Theme.of(
          //                   context,
          //                 ).textTheme.titleLarge!.copyWith(
          //                   fontSize: AppSize.s128,
          //                   fontWeight: FontWeight.bold,
          //                   color:
          //                       _outFirstDigit == 0
          //                           ? ColorManager.transparent
          //                           : ColorManager.white,
          //                 ),
          //               ),
          //               const SizedBox(width: 10), // Space between digits
          //               AnimatedFlipCounter(
          //                 value: _outSecondDigit,
          //                 textStyle: Theme.of(
          //                   context,
          //                 ).textTheme.titleLarge!.copyWith(
          //                   fontSize: AppSize.s128,
          //                   fontWeight: FontWeight.bold,
          //                   color: ColorManager.white,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //
          //     // Team B Score
          //     Flexible(
          //       flex: 1,
          //       child: Container(
          //         width: context.widthPercent(50),
          //         height: context.heightPercent(45),
          //         padding: EdgeInsets.symmetric(horizontal: 10),
          //         child: FittedBox(
          //           fit: BoxFit.fitWidth,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               AnimatedFlipCounter(
          //                 value: _inFirstDigit,
          //                 textStyle: Theme.of(
          //                   context,
          //                 ).textTheme.titleLarge!.copyWith(
          //                   fontSize: AppSize.s128,
          //                   fontWeight: FontWeight.bold,
          //                   color:
          //                       _inFirstDigit == 0
          //                           ? ColorManager.transparent
          //                           : ColorManager.white,
          //                 ),
          //               ),
          //               const SizedBox(width: 10), // Space between digits
          //               AnimatedFlipCounter(
          //                 value: _inSecondDigit,
          //                 textStyle: Theme.of(
          //                   context,
          //                 ).textTheme.titleLarge!.copyWith(
          //                   fontSize: AppSize.s128,
          //                   fontWeight: FontWeight.bold,
          //                   color: ColorManager.white,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          //
          // // Buttons Row (Team A and Team B buttons)
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     // Team A Buttons
          //     _buildButtonColumn(1, 'first'),
          //     const SizedBox(width: 30), // Space between buttons
          //     _buildButtonColumn(1, 'second'),
          //     const SizedBox(width: 120), // Space between teams
          //     // Team B Buttons
          //     _buildButtonColumn(2, 'first'),
          //     const SizedBox(width: 30), // Space between buttons
          //     _buildButtonColumn(2, 'second'),
          //   ],
          // ),
        ],
      ),
    );
  }

  // Helper widget to create buttons for each digit
  Widget _buildButtonColumn(int team, String digit) {
    return Row(
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

  Widget _buildFlipperCounter(int digit) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double currentAvailableWidth = constraints.maxWidth;
        final double currentAvailableHeight = constraints.maxHeight;

        // Ensure constraints are valid before passing to SizedBox/FittedBox
        if (!currentAvailableWidth.isFinite ||
            currentAvailableWidth <= 0 ||
            !currentAvailableHeight.isFinite ||
            currentAvailableHeight <= 0) {
          print(
            '[FittedBox Approach] Constraints are not valid. Rendering empty. W: $currentAvailableWidth, H: $currentAvailableHeight',
          );
          // Return an empty SizedBox or the unscaled counter if constraints are bad
          return AnimatedFlipCounter(
            value: digit, // Default unscaled
            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: AppSize.s128,
              fontWeight: FontWeight.bold,
              color: digit == 0 ? ColorManager.transparent : ColorManager.white,
            ),
          );
        }

        return SizedBox(
          width: currentAvailableWidth,
          height: currentAvailableHeight,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit:
                BoxFit
                    .fitWidth, // This is key: stretches to fill both dimensions
            child: AnimatedFlipCounter(
              value: digit,
              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize:
                    AppSize.s128, // Provide a good base font size for quality
                fontWeight: FontWeight.bold,
                // For FittedBox, TextStyle.height: 1.0 can sometimes help ensure a tighter intrinsic bound
                // You can also try null (default) to see if it behaves differently.
                height: 1.0,
                color:
                    digit == 0 ? ColorManager.transparent : ColorManager.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
