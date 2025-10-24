import 'package:cloud_firestore/cloud_firestore.dart';
final List<Map<String, dynamic>> initialSongs = [
  {
    "track_id": "song_001",
    "track_name": "Anti-Hero",
    "artist_name": "Taylor Swift",
    "genre": "Pop",
    "url": "https://i.scdn.co/image/ab67616d0000b2735a3f22c6821e8f25a8d36a50",
  },
  {
    "track_id": "song_002",
    "track_name": "Shivers",
    "artist_name": "Ed Sheeran",
    "genre": "Pop",
    "url": "https://i.scdn.co/image/ab67616d0000b2731d0fbb7c5db8d6e2c4c8b3e1",
  },
  {
    "track_id": "song_003",
    "track_name": "Levitating",
    "artist_name": "Dua Lipa",
    "genre": "Dance",
    "url": "https://i.scdn.co/image/ab67616d0000b27321a3e8f3e1f6c8c90b6e2d4a",
  },
  {
    "track_id": "song_004",
    "track_name": "Blinding Lights",
    "artist_name": "The Weeknd",
    "genre": "R&B",
    "url": "https://i.scdn.co/image/ab67616d0000b2730f3a8f3d7b7d6c8a90e2c1f7",
  },
  {
    "track_id": "song_005",
    "track_name": "Easy On Me",
    "artist_name": "Adele",
    "genre": "Soul",
    "url": "https://i.scdn.co/image/ab67616d0000b2738a3f0b9f8c8e2f1a4d3e5b7f",
  },
  {
    "track_id": "song_006",
    "track_name": "Enemy",
    "artist_name": "Imagine Dragons",
    "genre": "Rock",
    "url": "https://i.scdn.co/image/ab67616d0000b2734a8f2d5b9e2f3d6b1c2e4a8f",
  },
  {
    "track_id": "song_007",
    "track_name": "Happier Than Ever",
    "artist_name": "Billie Eilish",
    "genre": "Alternative",
    "url": "https://i.scdn.co/image/ab67616d0000b2735c2f3a6d7b2e4c8f1a9e5b7c",
  },
  {
    "track_id": "song_008",
    "track_name": "Leave The Door Open",
    "artist_name": "Bruno Mars",
    "genre": "Funk",
    "url": "https://i.scdn.co/image/ab67616d0000b2737b2f5c8d9e1a4f3b6c2d7e8f",
  },
];


Future<void> uploadSongsToFirestore() async {
  final firestore = FirebaseFirestore.instance;

  for (var song in initialSongs) {
    await firestore.collection('songs').doc(song['track_id']).set({
      'track_id': song['track_id'],
      'track_name': song['track_name'],
      'artist_name': song['artist_name'],
      'genre': song['genre'],
      'url': song['url'],
    });
  }

  print("✅ All songs uploaded as separate documents in 'songs' collection!");
}
