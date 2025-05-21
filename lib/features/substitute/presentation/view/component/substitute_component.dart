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
          zlog(data: "Out first is decrementing");
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
                      Expanded(
                        child: _buildFlipperCounter(
                          _outFirstDigit,
                          isZeroAllowed: false,
                        ),
                      ),
                      _buildButtonColumn(1, 'first'),
                    ],
                  ),
                ),
                SizedBox(
                  width: context.widthPercent(25),
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildFlipperCounter(
                          _outSecondDigit,
                          isZeroAllowed: true,
                        ),
                      ),
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
                      Expanded(
                        child: _buildFlipperCounter(
                          _inFirstDigit,
                          isZeroAllowed: false,
                        ),
                      ),
                      _buildButtonColumn(2, 'first'),
                    ],
                  ),
                ),
                SizedBox(
                  width: context.widthPercent(25),
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildFlipperCounter(
                          _inSecondDigit,
                          isZeroAllowed: true,
                        ),
                      ),
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

  Widget _buildFlipperCounter(int digit, {required bool isZeroAllowed}) {
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     double height = constraints.maxHeight;
    //     return AnimatedFlipCounter(
    //       value: digit,
    //       textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
    //         fontSize: height, // Provide a good base font size for quality
    //         fontWeight: FontWeight.bold,
    //         height: 1.0,
    //         color: digit == 0 ? ColorManager.transparent : ColorManager.white,
    //       ),
    //     );
    //   },
    // );

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
              fontFamily: 'monospaced',
              fontWeight: FontWeight.bold,
              color:
                  (!isZeroAllowed && digit == 0)
                      ? ColorManager.transparent
                      : ColorManager.white,
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
                fontFamily: 'monospaced',
                fontSize:
                    AppSize.s128, // Provide a good base font size for quality
                fontWeight: FontWeight.bold,
                height: 1.0,
                color:
                    (!isZeroAllowed && digit == 0)
                        ? ColorManager.transparent
                        : ColorManager.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
