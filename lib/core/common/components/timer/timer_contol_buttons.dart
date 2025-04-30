import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

enum TimeActiveStatus { RUNNING, PAUSED, STOPPED }

class TimerControlButtons extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final TimeActiveStatus initialStatus;

  const TimerControlButtons({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    this.initialStatus = TimeActiveStatus.PAUSED,
  });

  @override
  _TimerControlButtonsState createState() => _TimerControlButtonsState();
}

class _TimerControlButtonsState extends State<TimerControlButtons> {
  TimeActiveStatus _activeStatus = TimeActiveStatus.PAUSED;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activeStatus = widget.initialStatus;
  }

  @override
  void didUpdateWidget(covariant TimerControlButtons oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStatus != widget.initialStatus) {
      _setActiveButton(widget.initialStatus);
    }
  }

  void _setActiveButton(TimeActiveStatus button) {
    setState(() {
      _activeStatus = button;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Start Button
        TimerButton(
          icon: Icons.play_circle_outline,
          label: 'Start',
          isActive: _activeStatus == TimeActiveStatus.RUNNING,
          onPressed: () {
            widget.onStart();
            _setActiveButton(TimeActiveStatus.RUNNING);
          },
        ),
        SizedBox(width: 20),
        // Pause Button
        TimerButton(
          icon: Icons.pause_circle_outline,
          label: 'Pause',
          isActive: _activeStatus == TimeActiveStatus.PAUSED,
          onPressed: () {
            widget.onPause();
            _setActiveButton(TimeActiveStatus.PAUSED);
          },
        ),
        SizedBox(width: 20),
        // Stop Button
        TimerButton(
          icon: Icons.stop,
          label: 'Stop',
          isActive: _activeStatus == TimeActiveStatus.STOPPED,
          onPressed: () {
            widget.onStop();
            _setActiveButton(TimeActiveStatus.STOPPED);
          },
        ),
      ],
    );
  }
}

class TimerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const TimerButton({
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
          child: Icon(
            icon,
            size: 40,
            color: isActive ? ColorManager.green : ColorManager.grey,
          ),
        ),

        SizedBox(height: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: ColorManager.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
