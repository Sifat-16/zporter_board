import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zporter_board/core/common/components/timer/counter_timer_component.dart';
import 'package:zporter_board/core/common/components/timer/live_clock_component.dart';
import 'package:zporter_board/core/common/components/timer/timer_contol_buttons.dart';
import 'package:zporter_board/core/utils/match/match_utils.dart';
import 'package:zporter_board/features/time/data/model/match_time.dart';
import 'package:zporter_tactical_board/app/helper/logger.dart';
// Import any necessary packages or local files (like logger if needed)
// import 'package:zporter_tactical_board/app/helper/logger.dart'; // Example if using zlog

// --- Controller Definition ---

// --- Countdown Timer Widget ---

/// A widget that displays a countdown timer (MM:SS) and can be controlled externally.
class CountDownTimerWidget extends StatefulWidget {
  final Duration initialDuration;
  final CountDownTimerController controller;
  final bool isRunning; // Can be used to set initial running state
  // Styling
  final Color? textColor;
  final double? textSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final double periodDivider;
  // Callbacks
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onStop;
  final VoidCallback? onFinished;

  const CountDownTimerWidget({
    super.key,
    required this.initialDuration,
    required this.controller,
    this.isRunning = false,
    this.textColor,
    this.textSize,
    this.letterSpacing,
    this.fontWeight,
    this.periodDivider = 4,
    this.onStart,
    this.onPause,
    this.onStop,
    this.onFinished,
  });

  @override
  State<CountDownTimerWidget> createState() => _CountDownTimerWidgetState();
}

class _CountDownTimerWidgetState extends State<CountDownTimerWidget> {
  Timer? _timer;
  late Duration _remainingDuration;
  bool _isRunning = false; // Internal running state

  @override
  void initState() {
    super.initState();
    _initializeState();

    // Attach internal methods to the controller
    widget.controller.attach(
      start: _startTimer,
      pause: _pauseTimer,
      stop: _stopTimer,
      increaseDuration: _increaseDuration,
      decreaseDuration: _decreaseDuration,
    );

    // Auto-start if needed
    if (widget.isRunning && _remainingDuration > Duration.zero) {
      _startTimer(callCallback: false);
    }
  }

  @override
  void didUpdateWidget(covariant CountDownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset if initial duration changes from parent
    if (widget.initialDuration != oldWidget.initialDuration) {
      _resetTimer(widget.initialDuration);
    }

    zlog(data: "Match time status here i got ${widget.isRunning}");

    // Sync internal running state with parent's isRunning prop
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _startTimer();
      } else {
        _pauseTimer();
      }
    }
  }

  void _initializeState() {
    _remainingDuration = widget.initialDuration;
    if (_remainingDuration.isNegative) _remainingDuration = Duration.zero;
    // _isRunning = widget.isRunning && _remainingDuration > Duration.zero;
  }

  void _resetTimer(Duration? newDuration) {
    _timer?.cancel();
    setState(() {
      _remainingDuration = newDuration ?? widget.initialDuration;
      if (_remainingDuration.isNegative) _remainingDuration = Duration.zero;
      // Reflect parent's desired running state after reset
      _isRunning = widget.isRunning && _remainingDuration > Duration.zero;
    });
    if (_isRunning) {
      _startTimer(callCallback: false); // Restart if needed
    }
  }

  void _increaseDuration() {
    if (!mounted) return;
    setState(() {
      _remainingDuration += const Duration(minutes: 1);
      // Add max limit if desired
    });
    print(
      "Increased remaining duration display to: $_remainingDuration",
    ); // Use print or logger
  }

  void _decreaseDuration() {
    if (!mounted) return;
    setState(() {
      final newDuration = _remainingDuration - const Duration(minutes: 1);
      _remainingDuration = newDuration.isNegative ? Duration.zero : newDuration;
    });
    print(
      "Decreased remaining duration display to: $_remainingDuration",
    ); // Use print or logger

    if (_isRunning && _remainingDuration <= Duration.zero) {
      _stopTimer(callOnFinished: true, callCallback: false);
    }
  }

  void _startTimer({bool callCallback = true}) {
    zlog(
      data:
          "Command came for start timer ${_remainingDuration} - ${_isRunning}",
    );
    if (!_isRunning && _remainingDuration > Duration.zero) {
      zlog(data: "Command came for start timer step 2");
      _timer?.cancel();
      setState(() {
        _isRunning = true;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_remainingDuration > Duration.zero) {
            _remainingDuration -= const Duration(seconds: 1);
          }
          if (_remainingDuration <= Duration.zero) {
            _remainingDuration = Duration.zero;
            _stopTimer(callOnFinished: true); // Stop and call finished
          }
        });
      });
      if (callCallback) widget.onStart?.call();
    } else if (_remainingDuration <= Duration.zero && _isRunning) {
      setState(() => _isRunning = false); // Ensure stopped state if at zero
    }
  }

  void _pauseTimer({bool callCallback = true}) {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      if (callCallback) widget.onPause?.call();
    }
  }

  void _stopTimer({bool callOnFinished = false, bool callCallback = true}) {
    bool wasRunning = _isRunning;
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      if (callCallback) widget.onStop?.call();
    }
    if (callOnFinished && (wasRunning || _remainingDuration <= Duration.zero)) {
      // Call finished if requested and timer was running OR if already at zero
      if (_remainingDuration != Duration.zero) {
        setState(() => _remainingDuration = Duration.zero);
      }
      widget.onFinished?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.detach(); // Detach controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: widget.textColor ?? Colors.white,
      fontSize: widget.textSize ?? 48.0,
      fontWeight: widget.fontWeight ?? FontWeight.bold,
      letterSpacing: widget.letterSpacing,
      fontFamily: 'monospace',
    );

    Duration duration = _remainingDuration;
    if (duration.isNegative) duration = Duration.zero;
    final int minutes = duration.inMinutes.abs();
    final int seconds = duration.inSeconds.abs() % 60;

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(minutes.toString().padLeft(2, '0'), style: textStyle),
          Text(
            ":",
            style: textStyle.copyWith(
              fontSize: (widget.textSize ?? 48) / widget.periodDivider,
            ),
          ),
          Text(seconds.toString().padLeft(2, '0'), style: textStyle),
        ],
      ),
    );
  }
}

/// Controller to manage the state and actions of a CountDownTimerWidget.
class CountDownTimerController {
  VoidCallback? _start;
  VoidCallback? _pause;
  VoidCallback? _stop;
  VoidCallback? _increaseDuration;
  VoidCallback? _decreaseDuration;

  /// Attaches the internal implementation functions from the widget's state
  /// to the controller's public methods.
  void attach({
    required VoidCallback start,
    required VoidCallback pause,
    required VoidCallback stop,
    VoidCallback? increaseDuration,
    VoidCallback? decreaseDuration,
  }) {
    _start = start;
    _pause = pause;
    _stop = stop;
    _increaseDuration = increaseDuration;
    _decreaseDuration = decreaseDuration;
  }

  /// Starts the countdown timer.
  void start() => _start?.call();

  /// Pauses the countdown timer.
  void pause() => _pause?.call();

  /// Stops (pauses) the countdown timer.
  void stop() => _stop?.call();

  /// Resets the countdown timer to the specified duration.

  /// Increases the currently displayed remaining duration by one minute.
  void increaseDuration() => _increaseDuration?.call();

  /// Decreases the currently displayed remaining duration by one minute (won't go below zero).
  void decreaseDuration() => _decreaseDuration?.call();

  /// Detaches the internal functions to prevent memory leaks when the widget disposes.
  void detach() {
    _start = null;
    _pause = null;
    _stop = null;
    _increaseDuration = null;
    _decreaseDuration = null;
  }
}

// --- Timer Management Widget ---

class CountdownTimeManagerComponent extends StatelessWidget {
  const CountdownTimeManagerComponent({
    super.key,
    required this.matchPeriod,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    this.status,
  });
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  final MatchPeriod? matchPeriod;
  final TimeActiveStatus? status;
  @override
  Widget build(BuildContext context) {
    zlog(data: "State of the period status ${status}");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LiveClockComponent(),

          Row(
            children: [
              TimerControlButtons(
                onStart: onStart,
                onPause: onPause,
                onStop: onStop,
                initialStatus: status ?? TimeActiveStatus.STOPPED,
              ),
            ],
          ),
          CounterTimerComponent(
            startTime: MatchUtils.findInitialTime(matchPeriod: matchPeriod),
          ),
        ],
      ),
    );
  }
}
