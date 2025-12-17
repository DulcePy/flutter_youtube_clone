import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/helper.dart';
import 'package:flutter_youtube_clone/models/video_model.dart';
import 'package:flutter_youtube_clone/screens/channel_page.dart';
import 'package:flutter_youtube_clone/services/youtube_api_service.dart';
import 'package:flutter_youtube_clone/widgets/comments_section.dart';
import 'package:flutter_youtube_clone/widgets/video_info.dart';
import 'package:flutter_youtube_clone/widgets/video_list_widget.dart';
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
        body: _isFullScreen
            ? YoutubePlayerWidget(
                videoId: widget.video.id,
                onPlayerStateCreated: (state) {
                  _playerState = state;
                },
                onFullScreenChange: (isFullScreen) {
                  setState(() {
                    _isFullScreen = isFullScreen;
                  });
                })
            : Column(
                children: [
                  YoutubePlayerWidget(
                      videoId: widget.video.id,
                      onPlayerStateCreated: (state) {
                        _playerState = state;
                      },
                      onFullScreenChange: (isFullScreen) {
                        setState(() {
                          _isFullScreen = isFullScreen;
                        });
                      }),
                  Expanded(
                      child: _isCommentsExpanded
                          ? CommentsSection(
                              comments: _comments,
                              isLoading: _isCommentLoading,
                              onCommentsTap: _toggleComments,
                              isCommentsExpanded: true,
                              onClose: _toggleComments,
                            )
                          : ListView(
                              children: [
                                VideoInfo(
                                  video: widget.video,
                                  onChannelTap: () {
                                    _playerState.pause();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChannelPage(
                                                channelId:
                                                    widget.video.channelId)));
                                  },
                                ),
                                CommentsSection(
                                  comments: _comments,
                                  isLoading: _isCommentLoading,
                                  onCommentsTap: _toggleComments,
                                  isCommentsExpanded: false,
                                  onClose: _toggleComments,
                                ),
                                if (_isLoading)
                                  const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                else if (error != null)
                                  Center(
                                      child: Text(error!,
                                          style: const TextStyle(
                                              color: Colors.white)))
                                else
                                  Column(
                                    children: _recommendedVideos.map((video) {
                                      return VideoListWidget(
                                          videos: [video],
                                          isLoading: false,
                                          onVideoSelected: (video) {
                                            _playerState.pause();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPage(
                                                            video: video)));
                                          });
                                    }).toList(),
                                  )
                              ],
                            ))
                ],
              ));
  }
}
