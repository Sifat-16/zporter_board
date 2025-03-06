import 'dart:async';
import 'package:flutter/material.dart';

class TimerController {
  VoidCallback? _onStart;
  VoidCallback? _onStop;
  VoidCallback? _onPause;

  void Function()? _startTimer;
  void Function()? _pauseTimer;
  void Function()? _stopTimer;

  void attach({
    required void Function() startTimer,
    required void Function() pauseTimer,
    required void Function() stopTimer,
  }) {
    _startTimer = startTimer;
    _pauseTimer = pauseTimer;
    _stopTimer = stopTimer;
  }

  void start() => _startTimer?.call();
  void pause() => _pauseTimer?.call();
  void stop() => _stopTimer?.call();
}
