import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/helper.dart';
import 'package:flutter_youtube_clone/services/youtube_api_service.dart';
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

  final List<String> _categories = [
    "Explore",
    "All",
    "New to you",
    "AI",
    "Flutter",
    "JS"
  ];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    await Helper.handleRequest(() async {
      final videos = await _apiService.fetchVideos();
      debugPrint(videos.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YouTube"),
      ),
      body: Column(
        children: [
          CategoryWise(
            categories: _categories,
            selectedCategoryIndex: selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() {
                selectedCategoryIndex = index;
              });
            },
          )
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
