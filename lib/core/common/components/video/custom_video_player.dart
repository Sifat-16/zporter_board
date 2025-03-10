import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Function(VideoPlayerController) onVideoInitialized;

  const CustomVideoPlayer({Key? key, required this.videoUrl, required this.onVideoInitialized}) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
          _hasError = false;
        });
      }).catchError((error) {
        debug(data: "Video player error ${error}");
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      });

    _controller.addListener(() {
      if (!_controller.value.isPlaying && _controller.value.isBuffering) {
        setState(() => _isLoading = true);
      } else {
        setState(() => _isLoading = false);
      }
    });

    widget.onVideoInitialized(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.isInitialized ? _controller.value.aspectRatio : 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video Player
          _hasError
              ? const Center(
            child: Text(
              "Error loading video",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          )
              : VideoPlayer(_controller),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

        ],
      ),
    );
  }
}
