import 'package:dhun/core/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/app_bg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          AppBg(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  _buildAppBar(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildSongSection("New Release"),
                  const SizedBox(height: 24),
                  _buildSongSection("Popular List 2025"),
                  const SizedBox(height: 24),
                  _buildArtistSection("Popular Artist 2025"),
                  const SizedBox(height: 24),
                  _buildSongSection("Popular Album 2025"),
                ],
              ),
            ),
          ),
        ),
        const NavBar(),
        ]
      ),
    );
  }
}

Widget _buildAppBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
      ),
      const Text(
        "Dhun",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.notifications_none_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    ],
  );
}

Widget _buildSearchBar() {
  return TextField(
    decoration: InputDecoration(
      hintText: 'Track Artist, track or album',
      hintStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
      filled: true,
      fillColor: const Color(0xFF3A2F7D).withAlpha(128),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      TextButton(
        onPressed: () {},
        child: const Text(
          'See All',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    ],
  );
}

Widget _buildSongSection(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. Use our new header widget
      _buildSectionHeader(title),
      const SizedBox(height: 16),

      // 2. Create the horizontal list
      SizedBox(
        height: 200, // This fixed height is crucial
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // We'll use 5 dummy items for now
          itemBuilder: (context, index) {
            // This is the individual card for each song.
            return Container(
              width: 150,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Album Art Placeholder
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Song Title
                  const Text(
                    'Song Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Artist Name
                  const Text(
                    'Artist',
                    style: TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildArtistListItem() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Row(
      children: [
        // Left Image Placeholder
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 16),

        // Artist Info (This will expand to fill the space)
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Artist',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Number of songs',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        // Right Image Placeholder
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}

Widget _buildArtistSection(String title) {
  return Column(
    children: [
      _buildSectionHeader(title),
      const SizedBox(height: 16),
      // For the UI build, we'll just repeat the item.
      // Later, this would be a ListView.
      _buildArtistListItem(),
      _buildArtistListItem(),
      _buildArtistListItem(),
    ],
  );
}