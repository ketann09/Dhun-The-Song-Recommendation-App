import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._privateConstructor();
  static final AudioPlayerService instance = AudioPlayerService._privateConstructor();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSong(String url, String title, String artist, String artworkUrl) async {
    await _player.setUrl(url);  // load the song
    await _player.play();        // start playback
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // ✅ Add this method
  Future<void> stop() async {
    await _player.stop();
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
}
