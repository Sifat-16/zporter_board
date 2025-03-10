import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class CustomVideoController extends StatefulWidget {
  final VideoPlayerController controller;

  const CustomVideoController({Key? key, required this.controller}) : super(key: key);

  @override
  _CustomVideoControllerState createState() => _CustomVideoControllerState();
}

class _CustomVideoControllerState extends State<CustomVideoController> {
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _isMuted = false;

  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      setState(() {
        _currentPosition = widget.controller.value.position;
        _isPlaying = widget.controller.value.isPlaying;
        _isMuted = widget.controller.value.volume == 0;
      });
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _play() {
    widget.controller.play();
  }

  void _pause() {
    widget.controller.pause();
  }

  void _stop() {
    widget.controller.seekTo(Duration.zero);
    widget.controller.pause();
  }

  void _toggleMute() {
    widget.controller.setVolume(_isMuted ? 1.0 : 0.0);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Volume Toggle Button
        IconButton(
          icon: Column(
            children: [
              Icon(
                _isMuted ? Icons.mic_off : Icons.mic,
                size: 30,
                color: ColorManager.white,
              ),
              Text(
                _isMuted ? "Muted" : "Sound",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: ColorManager.white,
                ),
              ),
            ],
          ),
          onPressed: _toggleMute,
        ),
        // Play Button
        IconButton(
          icon: Column(
            children: [
              Icon(
                Icons.play_arrow,
                size: 30,
                color: _isPlaying ? ColorManager.grey : ColorManager.white,
              ),
              Text(
                _formatDuration(_currentPosition),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: ColorManager.white,
                ),
              ),
            ],
          ),
          onPressed: _isPlaying ? null : _play,
        ),
        // Pause Button (Disabled when not playing)
        IconButton(
          icon: Column(
            children: [
              Icon(
                Icons.pause,
                size: 30,
                color: _isPlaying ? ColorManager.white : ColorManager.grey,
              ),
              Text(
                "Pause",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: _isPlaying ? ColorManager.white : ColorManager.grey,
                ),
              ),
            ],
          ),
          onPressed: _isPlaying ? _pause : null,
        ),
        // Stop Button (Disabled when not playing)
        IconButton(
          icon: Column(
            children: [
              Icon(
                Icons.stop_circle,
                size: 30,
                color: _isPlaying ? ColorManager.white : ColorManager.grey,
              ),
              Text(
                "Stop",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: _isPlaying ? ColorManager.white : ColorManager.grey,
                ),
              ),
            ],
          ),
          onPressed: _isPlaying ? _stop : null,
        ),
      ],
    );
  }
}
