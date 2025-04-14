import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EmbeddedVideosPage extends StatefulWidget {
  final List<String> videoUrls;

  const EmbeddedVideosPage({super.key, required this.videoUrls});

  @override
  State<EmbeddedVideosPage> createState() => _EmbeddedVideosPageState();
}

class _EmbeddedVideosPageState extends State<EmbeddedVideosPage> {
  late List<YoutubePlayerController> _controllers;

  String _extractVideoId(String url) {
    Uri uri = Uri.parse(url);
    if (uri.pathSegments.contains('embed')) {
      return uri.pathSegments.last; // e.g. /embed/VIDEO_ID
    }
    return YoutubePlayer.convertUrlToId(url) ?? '';
  }

  @override
  void initState() {
    super.initState();
    _controllers = widget.videoUrls.map((url) {
      final videoId = _extractVideoId(url);
      return YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Embedded Videos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: _controllers.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: YoutubePlayer(
              controller: _controllers[index],
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.deepPurple,
            ),
          );
        },
      ),
    );
  }
}
