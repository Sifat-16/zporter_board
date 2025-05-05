import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/container/dynamic_container.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/features/scoreboard/data/model/score.dart';

class ScoreComponent extends StatefulWidget {
  const ScoreComponent({super.key, required this.matchScore});

  final MatchScore matchScore;

  @override
  State<ScoreComponent> createState() => _ScoreComponentState();
}

class _ScoreComponentState extends State<ScoreComponent> {
  @override
  Widget build(BuildContext context) {
    return DynamicContainer(
      builder: (context, height, width) {
        double textHeight = height - (height * .32);
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Score",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: ColorManager.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: textHeight * .3,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${widget.matchScore.homeScore}",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: ColorManager.green,
                      fontWeight: FontWeight.bold,
                      fontSize: textHeight * .7,
                    ),
                  ),
                  Text(
                    "-",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: ColorManager.green,
                      fontWeight: FontWeight.bold,
                      fontSize: textHeight * .7,
                    ),
                  ),
                  Text(
                    "${widget.matchScore.awayScore}",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: ColorManager.green,
                      fontWeight: FontWeight.bold,
                      fontSize: textHeight * .7,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
