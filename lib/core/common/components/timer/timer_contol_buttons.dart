import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class TimerControlButtons extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const TimerControlButtons({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  @override
  _TimerControlButtonsState createState() => _TimerControlButtonsState();
}

class _TimerControlButtonsState extends State<TimerControlButtons> {
  String _activeButton = '';

  void _setActiveButton(String button) {
    setState(() {
      _activeButton = button;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Start Button
        _TimerButton(
          icon: Icons.play_circle_outline,
          label: 'Start',
          isActive: _activeButton == 'start',
          onPressed: () {
            widget.onStart();
            _setActiveButton('start');
          },
        ),
        SizedBox(width: 20),
        // Pause Button
        _TimerButton(
          icon: Icons.pause_circle_outline,
          label: 'Pause',
          isActive: _activeButton == 'pause',
          onPressed: () {
            widget.onPause();
            _setActiveButton('pause');
          },
        ),
        SizedBox(width: 20),
        // Stop Button
        _TimerButton(
          icon: Icons.stop,
          label: 'Stop',
          isActive: _activeButton == 'stop',
          onPressed: () {
            widget.onStop();
            _setActiveButton('stop');
          },
        ),
      ],
    );
  }
}

class _TimerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _TimerButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Icon(icon, size: 40, color: isActive ? ColorManager.green : ColorManager.grey),
        ),

        SizedBox(height: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: ColorManager.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}
