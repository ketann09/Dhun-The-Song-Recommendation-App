import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerService {
  AudioPlayerService._privateConstructor();
  static final AudioPlayerService instance = AudioPlayerService._privateConstructor();
  
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSong(String url, String title, String artist, String artworkUrl) async {
    try {
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          album: "Unknown Album",
          title: title,
          artist: artist,
          artUri: Uri.parse(artworkUrl),
        ),
      );
      await _audioPlayer.setAudioSource(audioSource);
      await _audioPlayer.play();  // <-- await here
    } catch (e) {
      print("Error loading or playing song: $e");
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }


  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  // You might want to dispose the player when the app closes,
  // though for a music app, it might run indefinitely.
  // void dispose() {
  //   _audioPlayer.dispose();
  // }
}