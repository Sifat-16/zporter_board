import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class LiveClockComponent extends StatefulWidget {
  const LiveClockComponent({super.key});

  @override
  State<LiveClockComponent> createState() => _LiveClockWidgetState();
}

class _LiveClockWidgetState extends State<LiveClockComponent> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
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
      "CLOCK ${_formatTime(_currentTime)}",
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 28,
        fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
