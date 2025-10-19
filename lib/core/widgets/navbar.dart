import 'dart:ui';

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
                IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}),
                IconButton(icon: const Icon(Icons.replay_outlined), onPressed: () {}),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.music_note, color: Colors.black),
                ),
                IconButton(icon: const Icon(Icons.notifications_none_outlined), onPressed: () {}),
                IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}