import 'package:flutter/material.dart';

class YouTubeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const YouTubeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset('assets/images/youtube.png'),
      ),
      title: const Text(
        "YouTube",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.cast,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            )),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey,
          child: Text(
            "A",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
