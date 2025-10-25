import 'package:dhun/core/widgets/app_bg.dart';
import 'package:dhun/features/player/bloc/player_bloc.dart';
import 'package:dhun/features/player/widgets/more_options.dart'; // Ensure correct path
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// <<< CHANGE >>>: Converted to StatefulWidget
class PlayerScreen extends StatefulWidget {
  final String initialUrl;
  final String initialTitle;
  final String initialArtist;
  final String initialArtworkUrl;
  final String initialTrackId;

  const PlayerScreen({
    super.key,
    required this.initialUrl,
    required this.initialTitle,
    required this.initialArtist,
    required this.initialArtworkUrl,
    required this.initialTrackId,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // <<< CHANGE >>>: Helper function to format Duration (MM:SS)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // <<< CHANGE >>>: Added BlocProvider to create and provide the BLoC
    return BlocProvider(
      create: (context) => PlayerBloc()
        ..add(LoadSong(
            url: widget.initialUrl,
            title: widget.initialTitle,
            artist: widget.initialArtist,
            artworkUrl: widget.initialArtworkUrl)),
      child: Scaffold(
        body: AppBg(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              // <<< CHANGE >>>: Removed SingleChildScrollView if not desired, otherwise keep it
              // For adaptive layout, keep Column as direct child of Padding
              // For scrollable, wrap Column with SingleChildScrollView
              // Assuming non-scrollable based on previous discussion:
              child: BlocBuilder<PlayerBloc, PlayerState>( // <<< CHANGE >>>: Added BlocBuilder
                builder: (context, state) {
                  // <<< CHANGE >>>: Determine current state details
                  Duration currentPosition = Duration.zero;
                  Duration totalDuration = Duration.zero;
                  String currentTitle = widget.initialTitle;
                  String currentArtist = widget.initialArtist;
                  String currentArtworkUrl = widget.initialArtworkUrl;
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
                  // Handle PlayerInitial state if needed (e.g., show loading or default)

                  // <<< CHANGE >>>: Build the Column using state data
                  return Column(
                    children: [
                      _buildAppBar(context),
                      // Use Expanded for adaptive layout, remove if scrolling
                      Expanded(
                        child: _buildAlbumArt(currentArtworkUrl), // Pass data
                      ),
                      _buildSongInfo(currentTitle, currentArtist, widget.initialTrackId),
                      const SizedBox(height: 16),
                      _buildProgressBar(
                          context, currentPosition, totalDuration), // Pass data
                      _buildPlayerControls(context, isPlaying), // Pass data
                      _buildSocialActions(),
                      // Use Spacer for adaptive layout, remove if scrolling
                      // const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: const Color(0xFF1E1E1E),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            builder: (ctx) { // Use different context name
                              // Consider passing song details to the sheet if needed
                              return const MoreOptionsSheet();
                            },
                          );
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.keyboard_arrow_up),
                            Text('More'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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

  // --- Helper Methods moved inside _PlayerScreenState ---

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
    // Decide whether to use Image.asset or Image.network based on the source
    ImageProvider imageProvider;
    if (artworkUrl.startsWith('http')) {
        imageProvider = NetworkImage(artworkUrl);
    } else {
        imageProvider = AssetImage(artworkUrl); // Assuming local asset path
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Reduced padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image(
           image: imageProvider,
           fit: BoxFit.contain, // Use contain to prevent distortion
        ),
      ),
    );
  }


  Widget _buildSongInfo(String title, String artist, String trackId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Not logged in
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                artist,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
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
        .doc(widget.initialTrackId);

    return StreamBuilder<DocumentSnapshot>(
      stream: favRef.snapshots(), // 🔁 listens in real-time
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  artist,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : Colors.white,
                size: 32,
              ),
              onPressed: toggleFavorite,
            ),
          ],
        );
      },
    );
  }
  Widget _buildProgressBar(
      BuildContext context, Duration position, Duration duration) {
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
            value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()), // Use state data
            min: 0,
            max: duration.inSeconds.toDouble() + 1.0, // Use state data (+1 avoids potential clamp issue)
            onChanged: (value) {
              // <<< CHANGE >>>: Send Seek event to BLoC
              context.read<PlayerBloc>().add(SeekSong(Duration(seconds: value.toInt())));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // <<< CHANGE >>>: Format time dynamically
            children: [Text(_formatDuration(position)), Text(_formatDuration(duration))],
          ),
        ),
      ],
    );
  }

  // <<< CHANGE >>>: Takes isPlaying from state, adds BLoC events
  Widget _buildPlayerControls(BuildContext context, bool isPlaying) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 40),
            onPressed: () {
               // TODO: Add SkipPrevious event later
            },
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purpleAccent,
            ),
            child: IconButton(
              // <<< CHANGE >>>: Toggle icon based on state
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 60, color: Colors.white),
              onPressed: () {
                // <<< CHANGE >>>: Send Pause or Resume event to BLoC
                if (isPlaying) {
                  context.read<PlayerBloc>().add(PauseSong());
                } else {
                  context.read<PlayerBloc>().add(ResumeSong());
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, size: 40),
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialActions() {
    Widget buildSocialButton(IconData icon, String label) {
      return Column(
        children: [Icon(icon, size: 28), const SizedBox(height: 4), Text(label)],
      );
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
} // End of _PlayerScreenState