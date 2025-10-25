part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}

// Event to load and start playing a new song
class LoadSong extends PlayerEvent {
  final String url;
  final String title;
  final String artist;
  final String artworkUrl;

  LoadSong({
    required this.url,
    required this.title,
    required this.artist,
    required this.artworkUrl,
  });
}

class PauseSong extends PlayerEvent {}

class ResumeSong extends PlayerEvent {}

// Event to seek to a specific position
class SeekSong extends PlayerEvent {
  final Duration position;

  SeekSong(this.position);
}

class _PlayerStatusChanged extends PlayerEvent {
  final ja.PlayerState playerState; // from just_audio
  final Duration position;
  final Duration duration;

  _PlayerStatusChanged({
    required this.playerState,
    required this.position,
    required this.duration,
  });
}
class StopSong extends PlayerEvent {}
