import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/helper.dart';
import 'package:flutter_youtube_clone/models/video_model.dart';
import 'package:flutter_youtube_clone/services/youtube_api_service.dart';
import 'package:flutter_youtube_clone/widgets/appbar.dart';
import 'package:flutter_youtube_clone/widgets/bottom_navigation_bar.dart';
import 'package:flutter_youtube_clone/widgets/categorywise_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryIndex = 1;
  final YoutubeApiService _apiService = YoutubeApiService();

  bool _isLoading = true;
  bool _isLoadingMore = false;
  List<VideoModel> _videos = [];

  final List<String> _categories = [
    "Explore",
    "All",
    "New to you",
    "AI",
    "Flutter",
    "JS"
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _LoadMoreVideos();
    }
  }

  Future<void> _loadVideos() async {
    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final videos = await _apiService.fetchVideos();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _videos = videos;
        });
      }
      debugPrint(videos.length.toString());
    });
  }

  Future<void> _LoadMoreVideos() async {
    if (_isLoadingMore) return;
    final nextPageToken = _apiService.nextPageToken;

    await Helper.handleRequest(() async {
      if (mounted) {
        setState(() {
          _isLoadingMore = true;
        });
      }

      final moreVideos =
          await _apiService.fetchVideos(pageToken: nextPageToken);

      if (mounted) {
        setState(() {
          _videos.addAll(moreVideos);
          _isLoadingMore = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const YouTubeAppBar(),
      body: Column(
        children: [
          CategoryWise(
              categories: _categories,
              selectedCategoryIndex: selectedCategoryIndex,
              onCategorySelected: (index) {
                setState(() {
                  selectedCategoryIndex = index;
                });
              }),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadVideos,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return const Text("Video");
                  }, childCount: _videos.length)),
                  if (_isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
