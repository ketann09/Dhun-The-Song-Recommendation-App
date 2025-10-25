import 'package:dhun/features/auth/services/firestore_service.dart';
import 'package:dhun/features/home/bloc/home_bloc.dart';
import 'package:dhun/features/home/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dhun/core/widgets/navbar.dart';
import 'package:dhun/core/widgets/app_bg.dart';
import '../../player/view/player_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        body: Stack(
          children: [
            AppBg(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error: ${state.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else if (state is HomeSuccess) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            _buildAppBar(),
                            const SizedBox(height: 24),
                            _buildSearchBar(context),
                            const SizedBox(height: 24),
                            _buildSongSection(
                                "New Release", state.newReleases, context),
                            const SizedBox(height: 24),
                            _buildSongSection(
                                "Popular List 2025", state.popularList, context),
                            const SizedBox(height: 24),
                            _buildArtistSection(
                                "Popular Artists", state.popularArtists),
                            const SizedBox(height: 24),
                            _buildRecommendationSection(
                                state.recommendations ?? [], context), // Pass empty list if null
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Something went wrong.'));
                },
              ),
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://picsum.photos/id/1011/200'),
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

  Widget _buildSearchBar(BuildContext context) {
     return TextField(
      readOnly: true,
      onTap: () {
        // Navigator.push(... SearchScreen ...);
      },
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

  Widget _buildSongSection(String title, List<Map<String, dynamic>> songs, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: songs.isEmpty
              ? const Center(child: Text('No songs found.', style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final artworkUrl = song['albumArtUrl'] ?? 'https://via.placeholder.com/150';
                    final audioUrl = song['audioUrl'] ?? '';

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
                              initialUrl: audioUrl,
                              initialTitle: song['track_name'] ?? 'Unknown Title',
                              initialArtist: song['artist_name'] ?? 'Unknown Artist',
                              initialArtworkUrl: artworkUrl,
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
                                  image: NetworkImage(artworkUrl),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {},
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              song['track_name'] ?? 'Unknown Title',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song['artist_name'] ?? 'Unknown Artist',
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

  Widget _buildArtistSection(String title, List<Map<String, dynamic>> artists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 16),
        artists.isEmpty
          ? const Center(child: Text('No artists found.', style: TextStyle(color: Colors.white70)))
          : Column(
              children: artists.map((artist) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(artist['photoUrl'] ?? 'https://via.placeholder.com/60'),
                          fit: BoxFit.cover,
                           onError: (exception, stackTrace) {},
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist['artist'] ?? 'Unknown Artist',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${artist['songCount'] ?? 0} songs',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ),
      ],
    );
 }

  Widget _buildRecommendationSection(List<Map<String, dynamic>> recommendations, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Recommended For You"),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: recommendations.isEmpty
              ? const Center(child: Text("Play a song to get recommendations!", style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final song = recommendations[index];
                    final artworkUrl = song['albumArtUrl'] ?? 'https://via.placeholder.com/150';
                    final audioUrl = song['audioUrl'] ?? '';

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
                              initialUrl: audioUrl,
                              initialTitle: song['track_name'] ?? 'Unknown',
                              initialArtist: song['artist_name'] ?? 'Unknown',
                              initialArtworkUrl: artworkUrl,
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
                                   image: DecorationImage(image: NetworkImage(artworkUrl), fit: BoxFit.cover, onError: (e,s){}),
                                   borderRadius: BorderRadius.circular(12),
                                   color: Colors.deepPurple,
                                ),
                             ),
                             const SizedBox(height: 8),
                             Text(song['track_name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                             Text(song['artist_name'] ?? 'Unknown', style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
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