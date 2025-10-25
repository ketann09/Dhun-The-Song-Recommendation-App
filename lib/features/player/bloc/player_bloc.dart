import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dhun/data/services/audio_player.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService.instance;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playbackEventSubscription;

  String _currentTitle = '';
  String _currentArtist = '';
  String _currentArtworkUrl = '';

  PlayerBloc() : super(PlayerInitial()) {
    on<LoadSong>((event, emit) {
      _currentTitle = event.title;
      _currentArtist = event.artist;
      _currentArtworkUrl = event.artworkUrl;
      _audioPlayerService.playSong(
        event.url, event.title, event.artist, event.artworkUrl);
      _listenToPlayerState();
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

    _listenToPlayerState();
  }

  void _listenToPlayerState() {
    _playerStateSubscription?.cancel();
    _playbackEventSubscription?.cancel();

    _playbackEventSubscription = Rx.combineLatest3(
      _audioPlayerService.playerStateStream,
      _audioPlayerService.positionStream,
      _audioPlayerService.durationStream,
      (playerState, position, duration) =>
          {'state': playerState, 'position': position, 'duration': duration}
    ).listen((event) {
      final playerState = event['state'] as ja.PlayerState; // from just_audio
      final position = event['position'] as Duration;
      final duration = event['duration'] as Duration? ?? Duration.zero;

      if (playerState.playing) {
        add(_PlayerStatusChanged(
          position: position,
          duration: duration,
          playerState: playerState
        ));
      } else {
        if (state is PlayerPlaying || state is PlayerPaused) {
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
    return super.close();
  }
}