import 'dart:ui';
import 'package:dhun/features/home/view/home_screen.dart';
import 'package:dhun/features/player/view/player_screen.dart';
import 'package:dhun/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(26),

              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  HomeScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.folder_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.music_note),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PlayerScreen(
                          initialUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                          initialTitle: "Test Song",
                          initialArtist: "Test Artist",
                          initialArtworkUrl: "https://via.placeholder.com/300",
                          initialTrackId: "song_009",
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
