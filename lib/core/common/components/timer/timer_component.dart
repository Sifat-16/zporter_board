import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/timer_controller.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';

class TimerComponent extends StatefulWidget {
  final int startMinutes;
  final int startSeconds;
  final Color? textColor;
  final double? textSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onPause;
  final TimerController controller; // Add this

  const TimerComponent({
    super.key,
    required this.startMinutes,
    required this.startSeconds,
    required this.controller, // Add this
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

class _TimerComponentState extends State<TimerComponent> {
  late int _minutes;
  late int _seconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _minutes = widget.startMinutes;
    _seconds = widget.startSeconds;

    // Attach the controller's methods
    widget.controller.attach(
      startTimer: startTimer,
      pauseTimer: pauseTimer,
      stopTimer: stopTimer,
    );
  }

  void startTimer() {

    if (!_isRunning || _isPaused) {
      setState(() {
        _isRunning = true;
        _isPaused = false;
      });

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

      widget.onStart?.call();
    }
  }

  void stopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = false;
        _minutes = widget.startMinutes;
        _seconds = widget.startSeconds;
      });

      widget.onStop?.call();
    }
  }

  void pauseTimer() {
    if (_isRunning && !_isPaused) {
      _timer?.cancel();
      setState(() {
        _isPaused = true;
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
      child: Text(
        "${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}",
        style: textStyle,
      ),
    );
  }
}
