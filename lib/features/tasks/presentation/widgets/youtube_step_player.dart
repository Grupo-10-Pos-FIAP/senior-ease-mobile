import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Plays a `watchContent` step's YouTube video. Recreates the underlying
/// [YoutubePlayerController] whenever [videoUrl] changes (e.g. moving
/// between steps), since the controller is tied to a single video.
class YoutubeStepPlayer extends StatefulWidget {
  const YoutubeStepPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<YoutubeStepPlayer> createState() => _YoutubeStepPlayerState();
}

class _YoutubeStepPlayerState extends State<YoutubeStepPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = _buildController(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant YoutubeStepPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      final oldController = _controller;
      _controller = _buildController(widget.videoUrl);
      oldController?.close();
    }
  }

  YoutubePlayerController? _buildController(String videoUrl) {
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    if (videoId == null) return null;
    return YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showControls: true),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDesignTokens.borderRadiusDefault),
      child: controller == null
          ? AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: AppDesignTokens.colorGray800,
                child: Center(
                  child: Text(
                    'Não foi possível carregar o vídeo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppDesignTokens.colorWhite,
                      fontSize: AppDesignTokens.fontSizeBody,
                    ),
                  ),
                ),
              ),
            )
          : YoutubePlayerThumbnail(
              controller: controller,
              aspectRatio: 16 / 9,
              playIcon: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppDesignTokens.colorPrimary,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDesignTokens.spacingMd),
                  child: Icon(
                    Icons.play_arrow,
                    color: AppDesignTokens.colorContentInverse,
                    size: 40,
                  ),
                ),
              ),
            ),
    );
  }
}
