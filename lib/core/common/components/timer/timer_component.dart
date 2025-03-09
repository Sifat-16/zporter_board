import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class TimerComponent extends StatefulWidget {
  final int elapsedSeconds;  // Pass elapsed time in seconds
  final bool isRunning;  // Determine whether the timer should run
  final Color? textColor;
  final double? textSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onPause;
  final TimerController controller; // Controller for the timer

  const TimerComponent({
    super.key,
    required this.elapsedSeconds,
    this.isRunning = false,
    required this.controller, // Pass the controller
    this.textColor,
    this.textSize,
    this.fontWeight,
    this.onStart,
    this.onStop,
    this.onPause,
    this.letterSpacing,
  });

  @override
  _TimerComponentState createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent> with TickerProviderStateMixin {
  late int _elapsedSeconds;
  late int _minutes;
  late int _seconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = widget.elapsedSeconds;
    _minutes = _elapsedSeconds ~/ 60;
    _seconds = _elapsedSeconds % 60;


    // Attach controller's methods
    widget.controller.attach(
      startTimer: startTimer,
      pauseTimer: pauseTimer,
      stopTimer: stopTimer,
    );

    // Start the timer if it is running initially
    if (widget.isRunning) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant TimerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update when widget parameters change
    if (widget.isRunning) {
      startTimer();
    } else {
      stopTimer();
    }

    if (widget.elapsedSeconds != _elapsedSeconds) {
      setState(() {
        _elapsedSeconds = widget.elapsedSeconds;
        _minutes = _elapsedSeconds ~/ 60;
        _seconds = _elapsedSeconds % 60;
      });
    }
  }

  void startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          _minutes = _elapsedSeconds ~/ 60;
          _seconds = _elapsedSeconds % 60;
        });
      });

      widget.onStart?.call();
    }
  }

  void stopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });

      widget.onStop?.call();
    }
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });

      widget.onPause?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: widget.textColor ?? Colors.green,
      fontSize: widget.textSize ?? 48.0,
      fontWeight: widget.fontWeight ?? FontWeight.bold,
      letterSpacing: widget.letterSpacing,
    );

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}",
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
