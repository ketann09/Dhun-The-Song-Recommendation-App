import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/core/widgets/navbar.dart';
import 'package:dhun/features/player/view/player_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  // 🔍 Function to search songs in Firestore
  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    setState(() => isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('songs')
          .where('track_name', isGreaterThanOrEqualTo: query)
          .where('track_name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final results = snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        searchResults = List<Map<String, dynamic>>.from(results);
        isLoading = false;
      });
    } catch (e) {
      print("Error searching songs: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100), // 👈 FIXED: space for NavBar
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(context),
                      _buildSearchBar(),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator()),
                      if (!isLoading && searchResults.isEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTrendingSection(),
                            _buildRecentSearchesSection(),
                          ],
                        ),
                      if (searchResults.isNotEmpty)
                        _buildSearchResults(searchResults),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const NavBar(), // 👈 stays above, but now results won't hide under it
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 16),
        const Text(
          'Search',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: TextField(
        controller: _controller,
        onChanged: searchSongs,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search tracks, artists...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF3A2F7D).withAlpha(180),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Results',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (context, index) {
            final song = results[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerScreen(
                      playlist: results,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: song['url'] != null
                          ? Image.network(
                        song['url'],
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 55,
                        height: 55,
                        color: Colors.grey,
                        child: const Icon(Icons.music_note,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song['track_name'] ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            song['artist_name'] ?? '',
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    Widget buildChip(String label) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 1.5,
            color: Colors.purpleAccent.withAlpha(128),
          ),
        ),
        child: Text(label),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Search',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          children: [
            buildChip('Saiyaara'),
            buildChip('Sahiba'),
            buildChip('Deewaniyat'),
            buildChip('Apna Bana Le'),
            buildChip('Zara Sa'),
          ],
        )
      ],
    );
  }

  Widget _buildRecentSearchesSection() {
    Widget buildRecentSearchItem(String query) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: Colors.white70),
                const SizedBox(width: 16),
                Text(query, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.white24),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recently Search',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          buildRecentSearchItem('Agar Tum Saath Ho'),
          buildRecentSearchItem('Raatan Lambiyan'),
          buildRecentSearchItem('Kaho Na Kaho'),
          buildRecentSearchItem('Humsafar'),
          buildRecentSearchItem('Tum Hi Ho'),
        ],
      ),
    );
  }
}
