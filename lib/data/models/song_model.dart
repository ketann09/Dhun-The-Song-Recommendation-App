class Song {
  final String songurl;
  final String trackId;
  final String trackName;
  final String artistName;
  final String songUrl;
  final String artworkUrl;

  Song({
    required this.songurl,
    required this.trackId,
    required this.trackName,
    required this.artistName,
    required this.songUrl,
    required this.artworkUrl,
  });

  factory Song.fromFirestore(Map<String, dynamic> data) {
    return Song(
      songurl: data['songurl'] ?? '',
      trackId: data['track_id'],
      trackName: data['track_name'],
      artistName: data['artist_name'],
      songUrl: data['songurl'],
      artworkUrl: data['url'],
    );
  }
}
