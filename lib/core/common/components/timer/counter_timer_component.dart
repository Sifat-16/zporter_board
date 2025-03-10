import 'dart:async';
import 'package:flutter/material.dart';

class CounterTimerComponent extends StatefulWidget {
  final DateTime? startTime;

  const CounterTimerComponent({super.key, this.startTime});

  @override
  State<CounterTimerComponent> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<CounterTimerComponent> {
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.startTime != null) {
      _elapsedTime = DateTime.now().difference(widget.startTime!);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(widget.startTime!);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "TOTAL ${_formatDuration(_elapsedTime)}",
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
