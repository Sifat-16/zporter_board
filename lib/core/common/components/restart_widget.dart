import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child; // Your actual root widget (e.g., MaterialApp)

  const RestartWidget({required this.child, super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?._restart();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void _restart() {
    setState(() {
      _key = UniqueKey();
      print("--- Restarting App ---");
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
