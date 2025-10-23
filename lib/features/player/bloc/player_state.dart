part of 'player_bloc.dart';

@immutable
abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

// --- Updated State ---
class PlayerPlaying extends PlayerState {
  final Duration position;
  final Duration duration;
  final String title;
  final String artist;
  final String artworkUrl;

  PlayerPlaying({
    required this.position,
    required this.duration,
    required this.title,
    required this.artist,
    required this.artworkUrl,
  });
}

// --- Updated State ---
class PlayerPaused extends PlayerState {
  final Duration position;
  final Duration duration;
  final String title;
  final String artist;
  final String artworkUrl;

  PlayerPaused({
    required this.position,
    required this.duration,
    required this.title,
    required this.artist,
    required this.artworkUrl,
  });
}

// Optional: Add PlayerLoading, PlayerError states if needed