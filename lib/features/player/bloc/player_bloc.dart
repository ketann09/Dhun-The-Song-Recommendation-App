import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dhun/data/services/audio_player.dart';
import 'package:just_audio/just_audio.dart' as ja; // Import this for PlayerStateStream
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart'; // Import rxdart for combining streams
part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService.instance;

  // Store subscriptions to cancel them later
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playbackEventSubscription;

  // Keep track of current song details
  String _currentTitle = '';
  String _currentArtist = '';
  String _currentArtworkUrl = '';

  PlayerBloc() : super(PlayerInitial()) {
    on<StopSong>((event, emit) async {
      // Stop any currently playing song
      await _audioPlayerService.stop();

      // Emit paused state so UI updates
      emit(PlayerPaused(
        position: Duration.zero,
        duration: Duration.zero,
        title: _currentTitle,
        artist: _currentArtist,
        artworkUrl: _currentArtworkUrl,
      ));
    });
    on<LoadSong>((event, emit) async {
      // Stop any currently playing song first
      await _audioPlayerService.stop();

      // Update metadata
      _currentTitle = event.title;
      _currentArtist = event.artist;
      _currentArtworkUrl = event.artworkUrl;

      // Load and play the new song
      await _audioPlayerService.playSong(
        event.url,
        event.title,
        event.artist,
        event.artworkUrl,
      );

      // Re-subscribe to the player streams
      _listenToPlayerState();

      // Emit initial playing state right away
      emit(PlayerPlaying(
        position: Duration.zero,
        duration: Duration.zero,
        title: _currentTitle,
        artist: _currentArtist,
        artworkUrl: _currentArtworkUrl,
      ));
    });

    on<PauseSong>((event, emit) {
      _audioPlayerService.pause();
    });

    on<ResumeSong>((event, emit) {
      _audioPlayerService.resume();
    });

    on<SeekSong>((event, emit) {
      _audioPlayerService.seek(event.position);
    });

    on<_PlayerStatusChanged>((event, emit) {
      // Now we can safely call emit here!
      if (event.playerState.playing) {
        emit(PlayerPlaying(
          position: event.position,
          duration: event.duration,
          title: _currentTitle,
          artist: _currentArtist,
          artworkUrl: _currentArtworkUrl,
        ));
      } else {
        if (state is PlayerPlaying || state is PlayerPaused) {
          emit(PlayerPaused(
            position: event.position,
            duration: event.duration,
            title: _currentTitle,
            artist: _currentArtist,
            artworkUrl: _currentArtworkUrl,
          ));
        }
      }
    });

    // --- Stream Listening (The Core Logic) ---
    _listenToPlayerState(); // Start listening immediately
  }

  void _listenToPlayerState() {
    // Cancel previous listeners if they exist
    _playerStateSubscription?.cancel();
    _playbackEventSubscription?.cancel();

    // Combine player state, position, and duration into one stream
    _playbackEventSubscription = Rx.combineLatest3(
      _audioPlayerService.playerStateStream, // Stream of play/pause/loading etc.
      _audioPlayerService.positionStream,    // Stream of current position
      _audioPlayerService.durationStream,    // Stream of total duration
      (playerState, position, duration) =>
          {'state': playerState, 'position': position, 'duration': duration}
    ).listen((event) {
      final playerState = event['state'] as ja.PlayerState; // from just_audio
      final position = event['position'] as Duration;
      final duration = event['duration'] as Duration? ?? Duration.zero;

      // Based on the player's state, emit our BLoC's state
      if (playerState.playing) {
        add(_PlayerStatusChanged(
          position: position,
          duration: duration,
          playerState: playerState
        ));
      } else {
        // Handle other states like buffering, completed, etc. if needed
        // For simplicity, we'll treat non-playing as paused for now
        if (state is PlayerPlaying || state is PlayerPaused) { // Only emit if a song was loaded
             add(_PlayerStatusChanged(
                playerState: playerState,
                position: position,
                duration: duration,
             ));
        }
      }
    });
  }


  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _playbackEventSubscription?.cancel();
    // _audioPlayerService.stop(); // Optional: Stop player on close
    return super.close();
  }
}