import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/features/player/bloc/player_bloc.dart';
import 'package:dhun/features/player/widgets/more_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlayerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> playlist; // All songs
  final int initialIndex; // Which song to start

  const PlayerScreen({
    super.key,
    required this.playlist,
    this.initialIndex = 0,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final PlayerBloc _playerBloc;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _playerBloc = PlayerBloc();
    _loadSong(currentIndex);
  }

  void _loadSong(int index) {
    final song = widget.playlist[index];

    _playerBloc.add(StopSong()); // Stop current song first

    _playerBloc.add(LoadSong(
      url: song['songurl'] ?? '',
      title: song['track_name'] ?? 'Unknown',
      artist: song['artist_name'] ?? 'Unknown',
      artworkUrl: song['url'] ?? '',
    ));

    setState(() {
      currentIndex = index; // update current index for next/prev
    });
  }

  void _nextSong() {
    if (currentIndex < widget.playlist.length - 1) {
      _loadSong(currentIndex + 1);
    }
  }

  void _previousSong() {
    if (currentIndex > 0) {
      _loadSong(currentIndex - 1);
    }
  }


  @override
  void dispose() {
    _playerBloc.close();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerBloc>.value(
      value: _playerBloc,
      child: Scaffold(
        body: AppBg(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
                  Duration currentPosition = Duration.zero;
                  Duration totalDuration = Duration.zero;
                  String currentTitle = widget.playlist[currentIndex]['track_name'] ?? 'Unknown';
                  String currentArtist = widget.playlist[currentIndex]['artist_name'] ?? 'Unknown';
                  String currentArtworkUrl = widget.playlist[currentIndex]['url'] ?? '';
                  bool isPlaying = false;

                  if (state is PlayerPlaying) {
                    currentPosition = state.position;
                    totalDuration = state.duration;
                    currentTitle = state.title;
                    currentArtist = state.artist;
                    currentArtworkUrl = state.artworkUrl;
                    isPlaying = true;
                  } else if (state is PlayerPaused) {
                    currentPosition = state.position;
                    totalDuration = state.duration;
                    currentTitle = state.title;
                    currentArtist = state.artist;
                    currentArtworkUrl = state.artworkUrl;
                    isPlaying = false;
                  }

                  return Column(
                    children: [
                      _buildAppBar(context),
                      Expanded(child: _buildAlbumArt(currentArtworkUrl)),
                      _buildSongInfo(currentTitle, currentArtist, widget.playlist[currentIndex]['track_id'] ?? ''),
                      const SizedBox(height: 16),
                      _buildProgressBar(context, currentPosition, totalDuration),
                      _buildPlayerControls(context, isPlaying),
                      _buildSocialActions(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Text(
          'Now Playing',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.fullscreen, size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildAlbumArt(String artworkUrl) {
    ImageProvider imageProvider;
    if (artworkUrl.startsWith('http')) {
      imageProvider = NetworkImage(artworkUrl);
    } else {
      imageProvider = AssetImage(artworkUrl);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image(image: imageProvider, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildSongInfo(String title, String artist, String trackId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(artist, style: const TextStyle(fontSize: 18, color: Colors.white70)),
            ],
          ),
          const Icon(Icons.favorite_border, color: Colors.white, size: 32),
        ],
      );
    }

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(trackId);

    return StreamBuilder<DocumentSnapshot>(
      stream: favRef.snapshots(),
      builder: (context, snapshot) {
        bool isFavorite = snapshot.data?.exists ?? false;

        Future<void> toggleFavorite() async {
          if (isFavorite) {
            await favRef.delete();
          } else {
            await favRef.set({
              'track_id': trackId,
              'title': title,
              'artist': artist,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(artist, style: const TextStyle(fontSize: 18, color: Colors.white70)),
              ],
            ),
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.white, size: 32),
              onPressed: toggleFavorite,
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(BuildContext context, Duration position, Duration duration) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            activeTrackColor: Colors.purpleAccent,
            inactiveTrackColor: Colors.grey.shade700,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
            min: 0,
            max: duration.inSeconds.toDouble() + 1.0,
            onChanged: (value) {
              _playerBloc.add(SeekSong(Duration(seconds: value.toInt())));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(_formatDuration(position)), Text(_formatDuration(duration))],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControls(BuildContext context, bool isPlaying) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 40),
            onPressed: _previousSong,
          ),
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.purpleAccent),
            child: IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 60, color: Colors.white),
              onPressed: () {
                if (isPlaying) {
                  _playerBloc.add(PauseSong());
                } else {
                  _playerBloc.add(ResumeSong());
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, size: 40),
            onPressed: _nextSong,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialActions() {
    Widget buildSocialButton(IconData icon, String label) {
      return Column(children: [Icon(icon, size: 28), const SizedBox(height: 4), Text(label)]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildSocialButton(Icons.favorite, '1.0M'),
        buildSocialButton(Icons.comment, '7.5K'),
        buildSocialButton(Icons.share, '5K'),
      ],
    );
  }
}
