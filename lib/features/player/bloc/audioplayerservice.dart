import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._privateConstructor();
  static final AudioPlayerService instance = AudioPlayerService._privateConstructor();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSong(String url, String title, String artist, String artworkUrl) async {
    await _player.setUrl(url);
    await _player.play();     
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

  Future<void> stop() async {
    await _player.stop();
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
}
