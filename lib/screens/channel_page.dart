import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/helper.dart';
import 'package:flutter_youtube_clone/models/channel_model.dart';
import 'package:flutter_youtube_clone/models/video_model.dart';
import 'package:flutter_youtube_clone/services/youtube_api_service.dart';

class ChannelPage extends StatefulWidget {
  final String channelId;

  const ChannelPage({
    super.key,
    required this.channelId,
  });

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage>
    with SingleTickerProviderStateMixin {
  final YoutubeApiService _apiService = YoutubeApiService();
  ChannelModel? _channel;
  List<VideoModel> _videos = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadChannelData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadChannelData() async {
    setState(() {
      _isLoading = true;
    });

    final channelResult = await Helper.handleRequest(
        () => _apiService.fetchChannelDetails(widget.channelId));
    final videosResult = await Helper.handleRequest(
        () => _apiService.fetchChannelVideos(widget.channelId));

    if (mounted) {
      setState(() {
        _channel = channelResult;
        _videos = videosResult ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_channel == null) {
      return const Scaffold(
        body: Center(
          child: Text('Failed to load channel'),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back)),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.cast)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ],
              ),
            ];
          },
          body: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  _channel!.bannerUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.error),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
