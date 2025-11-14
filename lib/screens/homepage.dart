import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/widgets/bottom_navigation_bar.dart';
import 'package:flutter_youtube_clone/widgets/categorywise_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryIndex = 1;

  final List<String> _categories = [
    "Explore",
    "All",
    "New to you",
    "AI",
    "Flutter",
    "JS"
  ];

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
