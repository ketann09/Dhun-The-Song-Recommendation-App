import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/navbar.dart';
import 'package:dhun/core/widgets/app_bg.dart';
import '../../player/view/player_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../../search/view/search_screen.dart';
import 'initial_songs.dart';
import 'package:dhun/features/home/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dhun/features/auth/services/firestore_service.dart';
import 'package:dhun/data/models/song_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> recommendations = [];
  bool isLoading = true;
  bool isRecLoading = true;

  final songService = SongService();
  final firestoreService = FirestoreService();
  String? userPhotoUrl;
  String? userEmail;
  @override
  void initState() {
    super.initState();
    _initUserProfile();
    fetchSongs();
    fetchRecommendations();
  }

  Future<void> _initUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create user profile in Firestore
      await firestoreService.createUserProfile(
        uid: user.uid,
        email: user.email ?? '',
      );

      // Update state to show user info in UI
      setState(() {
        userPhotoUrl = user.photoURL;
        userEmail = user.email;
      });
    }
  }

  Future<void> fetchSongs() async {
    final data = await songService.getSongs();
    setState(() {
      songs = data;
      isLoading = false;
    });
  }

  Future<void> fetchRecommendations() async {
    setState(() => isRecLoading = true);

    try {
      // Use numeric user id
      final int numericUserId = 12345; // Replace with dynamic id later if needed
      final url = "https://song-recommender-4.onrender.com/recommend_hybrid?user_id=$numericUserId&top_k=10&alpha=0.5";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        print("ML backend returned status: ${response.statusCode}");
        setState(() => isRecLoading = false);
        return;
      }

      final body = jsonDecode(response.body);
      print("ML response: $body"); // Debug: check what is returned

      if (body['status'] != 'success' || body['data'] == null) {
        print("No recommendations found");
        setState(() => isRecLoading = false);
        return;
      }

      final recs = body['data']['recommendations'] as List<dynamic>;

      final mapped = recs.map((rec) => {
        'track_id': rec['song_id'],
        'track_name': rec['title'],
        'artist_name': rec['artist'],
        'url': rec['cover_image'],   // artwork
        'songurl': rec['url'],       // audio
      }).toList();

      setState(() {
        recommendations = List<Map<String, dynamic>>.from(mapped);
        isRecLoading = false;
      });

      print("Mapped recommendations: $mapped"); // Debug: see final mapped data

    } catch (e) {
      print("Error fetching recommendations: $e");
      setState(() => isRecLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
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
                    _buildSongSection("New Release", initialSongs),
                    const SizedBox(height: 24),
                    _buildSongSection("Popular List 2025", initialSongs),
                    const SizedBox(height: 24),
                    _buildArtistSection("Popular Artists", initialSongs),
                    const SizedBox(height: 24),
                    _buildRecommendationSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          const NavBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final String initial = (userEmail != null && userEmail!.isNotEmpty)
        ? userEmail![0].toUpperCase()
        : '?';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Only Avatar, clickable
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.deepPurpleAccent.withOpacity(0.8),
            backgroundImage: (userPhotoUrl != null && userPhotoUrl!.isNotEmpty)
                ? NetworkImage(userPhotoUrl!)
                : null,
            child: (userPhotoUrl == null || userPhotoUrl!.isEmpty)
                ? Text(
              initial,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                : null,
          ),
        ),

        const Text(
          "Dhun",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
      },
      child: AbsorbPointer( // prevent keyboard opening automatically
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Track, Artist, or Album',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFF3A2F7D).withAlpha(128),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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

  Widget _buildSongSection(String title, List<Map<String, dynamic>> songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return GestureDetector(
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && song['track_id'] != null) {
                    await firestoreService.logInteraction(
                      userId: user.uid,
                      trackId: song['track_id'],
                      interactionStrength: 1,
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PlayerScreen(
                            playlist: songs,
                            initialIndex: index,
                          ),
                    ),
                  ).then((_) {
                    // Optional: reset currentIndex if needed
                  });
                },

    child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(song['url'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        song['track_name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song['artist_name'] ?? '',
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistSection(String title, List<Map<String, dynamic>> songs) {
    final artists = songs
        .map((song) => song['artist_name'])
        .toSet()
        .map((artist) => {
      'artist': artist,
      'photoUrl': songs.firstWhere((s) => s['artist_name'] == artist)['url'],
      'songCount': songs.where((s) => s['artist_name'] == artist).length,
    })
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 16),
        Column(
          children: artists
              .map(
                (artist) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(artist['photoUrl'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artist['artist'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${artist['songCount']} songs',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
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
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Recommended For You"),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: isRecLoading
              ? const Center(child: CircularProgressIndicator())
              : recommendations.isEmpty
              ? const Center(
            child: Text(
              "No recommendations yet",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final song = recommendations[index];
              return GestureDetector(
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && song['track_id'] != null) {
                    await firestoreService.logInteraction(
                      userId: user.uid,
                      trackId: song['track_id'],
                      interactionStrength: 1,
                    );
                  }

                  // Open PlayerScreen with the **recommendations list** so you can skip next/prev properly
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        playlist: recommendations, // pass recommendations list
                        initialIndex: index,        // start at tapped song
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(song['url'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        song['track_name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song['artist_name'] ?? '',
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
