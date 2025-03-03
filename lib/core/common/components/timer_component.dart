import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class TimerComponent extends StatefulWidget {
  final int startMinutes; // Starting minutes
  final int startSeconds; // Starting seconds

  const TimerComponent({
    super.key,
    required this.startMinutes,
    required this.startSeconds,
  });

  @override
  _TimerComponentState createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent> {
  late int _minutes;
  late int _seconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _minutes = widget.startMinutes;
    _seconds = widget.startSeconds;

    // Start the timer
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds < 59) {
          _seconds++;
        } else {
          _seconds = 0;
          _minutes++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}",
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: ColorManager.green,
            fontWeight: FontWeight.bold
        )
    );
  }
}
