import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/navbar.dart';
import 'package:dhun/core/widgets/app_bg.dart';
import '../../player/view/player_screen.dart';
import 'initial_songs.dart';
import 'package:dhun/features/home/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dhun/features/auth/services/firestore_service.dart';

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

  @override
  void initState() {
    super.initState();
    _initUserProfile();
    fetchSongs();
    fetchRecommendations();
  }

  /// Create user profile if first login
  Future<void> _initUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await firestoreService.createUserProfile(
        uid: user.uid,
        email: user.email ?? '',
      );
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
    try {
      final recs = await songService.getRecommendations();
      setState(() {
        recommendations = recs;
        isRecLoading = false;
      });
    } catch (e) {
      print("Error fetching recommendations: $e");
      setState(() {
        isRecLoading = false;
      });
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
    return TextField(
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
                    // Log user interaction
                    await firestoreService.logInteraction(
                      userId: user.uid,
                      trackId: song['track_id'],
                      interactionStrength: 1,
                    );
                  }
                  // Navigate to PlayerScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        initialUrl: song['url'],
                        initialTitle: song['track_name'],
                        initialArtist: song['artist_name'],
                        initialArtworkUrl: song['url'],
                        initialTrackId: song['track_id'],
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
                            image: NetworkImage(song['url']),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        song['track_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song['artist_name'],
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
      'photoUrl': songs
          .firstWhere((s) => s['artist_name'] == artist)['url'],
      'songCount': songs
          .where((s) => s['artist_name'] == artist)
          .length,
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
                        image: NetworkImage(artist['photoUrl']),
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
                          artist['artist'],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        initialUrl: song['url'],
                        initialTitle: song['track_name'],
                        initialArtist: song['artist_name'],
                        initialArtworkUrl: song['url'],
                        initialTrackId: song['track_id'],
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
                            image: NetworkImage(song['url']),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        song['track_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song['artist_name'],
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
