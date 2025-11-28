import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/helper.dart';
import 'package:flutter_youtube_clone/models/video_model.dart';
import 'package:flutter_youtube_clone/services/youtube_api_service.dart';
import 'package:flutter_youtube_clone/widgets/youtube_player.dart';

class VideoPage extends StatefulWidget {
  final VideoModel video;
  const VideoPage({super.key, required this.video});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final YoutubeApiService _apiService = YoutubeApiService();
  List<VideoModel> _recommendedVideos = [];
  bool _isLoading = true;
  String? error;
  List<Map<String, dynamic>> _comments = [];
  late YoutubePlayerWidgetState _playerState;
  bool _isCommentLoading = true;
  bool _isCommentsExpanded = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _loadRecommendedVideos();
  }

  void _toggleComments() {
    setState(() {
      _isCommentsExpanded = !_isCommentsExpanded;
    });
  }

  Future<void> _loadComments() async {
    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          _isCommentLoading = true;
        });
      }

      final comments = await _apiService.fetchComments(widget.video.id);

      if (mounted) {
        setState(() {
          _comments = comments;
          _isCommentLoading = false;
        });
      }
    });
  }

  Future<void> _loadRecommendedVideos() async {
    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          _isLoading = true;
          error = null;
        });

        final videos = await _apiService.fetchVideos(query: widget.video.title);
        if (mounted) {
          setState(() {
            _recommendedVideos = videos;
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: YoutubePlayerWidget(
          videoId: widget.video.id,
          onPlayerStateCreated: (state) {
            _playerState = state;
          },
          onFullScreenChange: (isFullScreen) {
            setState(() {
              _isFullScreen = isFullScreen;
            });
          }),
    );
  }
}
