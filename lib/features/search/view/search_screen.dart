import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/core/widgets/navbar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(context),
                      _buildSearchBar(),
                      _buildTrendingSection(),
                      _buildRecentSearchesSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const NavBar(),
        ],
      ),
    );
  }
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
      decoration: InputDecoration(
        hintText: '',
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
          color: Colors.purpleAccent.withAlpha(128)
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
          buildChip('Apna Bna le'),
          buildChip('Zara sa'),
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
        buildRecentSearchItem('Agar tum Sath ho'),
        buildRecentSearchItem('Raatan Lambiyan'),
        buildRecentSearchItem('Kaho na Kaho'),
        buildRecentSearchItem('Humsafar'),
        buildRecentSearchItem('Tum Hi Ho'),
      ],
    ),
  );
}

