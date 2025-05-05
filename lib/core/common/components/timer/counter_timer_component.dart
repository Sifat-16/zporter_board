import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class CounterTimerComponent extends StatefulWidget {
  /// The absolute time the session originally started.
  /// The timer will display the duration between [startTime] and now.
  final DateTime? startTime;

  const CounterTimerComponent({super.key, this.startTime});

  @override
  State<CounterTimerComponent> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<CounterTimerComponent> {
  Timer? _timer; // Make timer nullable to manage its lifecycle
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Initialize state based on initial startTime
    _updateTimerState();
  }

  @override
  void didUpdateWidget(CounterTimerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the startTime provided by the parent widget has changed
    if (widget.startTime != oldWidget.startTime) {
      // If it changed, reset the timer logic based on the new startTime
      _updateTimerState();
    }
  }

  /// Sets up or resets the timer based on the current widget.startTime
  void _updateTimerState() {
    // 1. Cancel any existing timer
    _cancelTimer();

    // 2. Check if we have a valid start time
    if (widget.startTime != null) {
      // Calculate the initial elapsed duration
      _elapsedTime = DateTime.now().difference(widget.startTime!);
      // Safety check: If startTime is somehow in the future, show zero duration
      if (_elapsedTime.isNegative) {
        _elapsedTime = Duration.zero;
      }
      // Start a new timer to update the elapsed time every second
      _startTimer();
    } else {
      // If startTime is null, reset elapsed time to zero
      _elapsedTime = Duration.zero;
    }

    // Update the UI immediately if the widget is still mounted
    if (mounted) {
      setState(() {});
    }
  }

  /// Starts the periodic timer only if startTime is valid
  void _startTimer() {
    // Ensure we don't start multiple timers if one is already running (handled by _updateTimerState calling _cancelTimer first)
    // Ensure startTime is not null
    if (widget.startTime == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if the widget is still in the tree before calling setState
      if (!mounted) {
        timer.cancel(); // Cancel the timer if widget is disposed
        return;
      }

      // Calculate elapsed time based on the CURRENT startTime
      // This ensures it uses the latest value if widget was updated
      final now = DateTime.now();
      setState(() {
        _elapsedTime = now.difference(widget.startTime!);
        // Safety check
        if (_elapsedTime.isNegative) {
          _elapsedTime = Duration.zero;
        }
      });
    });
  }

  /// Cancels the timer if it's active
  void _cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = null; // Set to null after cancelling
  }

  @override
  void dispose() {
    _cancelTimer(); // Ensure timer is cancelled when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display the formatted elapsed time
    return Text(
      "TOTAL ${_formatDuration(_elapsedTime)}",
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 28, // Keep original font size
        fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
      ),
    );
  }

  /// Formats the duration into HH:MM:SS format
  String _formatDuration(Duration duration) {
    // Defensively handle negative durations
    if (duration.isNegative) {
      duration = Duration.zero;
    }
    // Use String manipulation for padding
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // Limit hours display if needed (e.g., % 100 for 00-99 range)
    // final String twoDigitHours = twoDigits(duration.inHours % 100);
    final String twoDigitHours = twoDigits(
      duration.inHours,
    ); // Allow hours > 99 for TOTAL
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
