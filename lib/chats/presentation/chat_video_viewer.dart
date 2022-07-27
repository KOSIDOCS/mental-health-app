import 'package:flutter/material.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class ChatVideoViewer extends StatefulWidget {
  final String videoUrl;
  const ChatVideoViewer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<ChatVideoViewer> createState() => _ChatVideoViewerState();
}

class _ChatVideoViewerState extends State<ChatVideoViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ) : CircularProgressIndicator(
              color: AppColors.mentalBrandColor,
              strokeWidth: 5,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: BackButton(),
          ),
        ],
      ),
    );
  }
}
