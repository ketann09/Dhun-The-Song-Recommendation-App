import 'package:cloud_firestore/cloud_firestore.dart';
final List<Map<String, dynamic>> initialSongs = [
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/anti_hero.mp3?alt=media&token=3b8f98ca-f839-45fc-a7ed-aa02133cb3df",
    "track_id": "song_001",
    "track_name": "Anti-Hero",
    "artist_name": "Taylor Swift",
    "genre": "Pop",
    "url": "https://imgs.search.brave.com/1TCJuK2blO5fmsKXufl2GMGofxJDdgIV-y77X3fCXH8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLmRp/c2NvZ3MuY29tL3dv/a3RZUnR0MW9aVFZH/VVF3SnRPZ2dZb1M5/WTdkOTJHcjQ3M2ls/b1o4T2svcnM6Zml0/L2c6c20vcTo0MC9o/OjMwMC93OjMwMC9j/ek02THk5a2FYTmpi/MmR6L0xXUmhkR0Zp/WVhObExXbHQvWVdk/bGN5OVNMVEkwT1RJ/ei9Nakk0TFRFMk56/STJORFV3L05UUXRN/VFl4TWk1cWNHVm4u/anBlZw",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/shivers.mp3?alt=media&token=7199234c-67f6-4a44-a468-960eae886192",
    "track_id": "song_002",
    "track_name": "Shivers",
    "artist_name": "Ed Sheeran",
    "genre": "Pop",
    "url": "https://imgs.search.brave.com/Bk4qO3y_Kei6HmKkB5EvEcj_mQVMJnkLpTGkRjjr-u0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pMS5z/bmRjZG4uY29tL2Fy/dHdvcmtzLXJWU08y/UG54S0VUeUZFeUwt/SXdGZ1hRLXQxMDgw/eDEwODAuanBn",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/levitating.unknown?alt=media&token=4c13ad22-0824-4167-af46-891208168f05",
    "track_id": "song_003",
    "track_name": "Levitating",
    "artist_name": "Dua Lipa",
    "genre": "Dance",
    "url": "https://imgs.search.brave.com/bsRodm4OmlHTLsyv3B4o2slyP7rMaMZQ04iCIm8jpSE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pMS5z/bmRjZG4uY29tL2Fy/dHdvcmtzLWhTWVkz/TTF6M0lpRFJyRkst/N3ZUTk1BLXQxMDgw/eDEwODAuanBn",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/blinding.unknown?alt=media&token=7c8fb14f-ae8c-44c5-a16b-bf4db9359fda",
    "track_id": "song_004",
    "track_name": "Blinding Lights",
    "artist_name": "The Weeknd",
    "genre": "R&B",
    "url": "https://imgs.search.brave.com/Tf5xI5T2QiYgSi5w8ZQv1a6WiCTk0UYtdQdg3O85yMQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jLnNh/YXZuY2RuLmNvbS8w/NzcvQWZ0ZXItSG91/cnMtRW5nbGlzaC0y/MDIwLTIwMjQwMjA3/MDcwMzMwLTUwMHg1/MDAuanBn",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/easyonme.unknown?alt=media&token=03adb463-f182-43fc-9daf-1e9a51699e3f",
    "track_id": "song_005",
    "track_name": "Easy On Me",
    "artist_name": "Adele",
    "genre": "Soul",
    "url": "https://imgs.search.brave.com/TpTIAiio__ANXij7TdjYT805mDD58WH_c_XrieiDhGs/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90cmVu/ZHliZWF0ei5jb20v/aW1hZ2VzL0FkZWxl/LUVhc3ktT24tTWUt/QXJ0d29yay5qcGc",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/enemy.unknown?alt=media&token=ba4b8811-475f-4a86-86e9-8a27e5aeefa8",
    "track_id": "song_006",
    "track_name": "Enemy",
    "artist_name": "Imagine Dragons",
    "genre": "Rock",
    "url": "https://imgs.search.brave.com/GYS3vbbMOmJQcsFnZvls3ep1YKlrjwD-0IRwcCMJzCw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvZW4vdGh1bWIv/NS81Yy9FbmVteV9J/bWFnaW5lX0RyYWdv/bnMuanBnLzI1MHB4/LUVuZW15X0ltYWdp/bmVfRHJhZ29ucy5q/cGc",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/happythatever.unknown?alt=media&token=68daf5f7-0eea-4d44-81c8-cd32c1ebf5f2",
    "track_id": "song_007",
    "track_name": "Happier Than Ever",
    "artist_name": "Billie Eilish",
    "genre": "Alternative",
    "url": "https://imgs.search.brave.com/lplxAMJjwooK1X0EcuK4H_2lOh8QeYPdx9wiFQ_um0I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9odHRw/Mi5tbHN0YXRpYy5j/b20vRF9RX05QXzJY/Xzc1NTg3My1NTE00/OTMzODU0MjQyNl8w/MzIwMjItVi1iaWxs/aWUtZWlsaXNoLWhh/cHBpZXItdGhhbi1l/dmVyLWRpc2NvLWNk/LTE2LWNhbmNpb25l/cy53ZWJw",
  },
  {
    "songurl":"https://firebasestorage.googleapis.com/v0/b/song-app-55d7b.firebasestorage.app/o/leavethedooropen.unknown?alt=media&token=36f26a70-5845-4ca7-af13-05f8fe1f3200",
    "track_id": "song_008",
    "track_name": "Leave The Door Open",
    "artist_name": "Bruno Mars",
    "genre": "Funk",
    "url": "https://imgs.search.brave.com/DIpxgFRhSnsQ8Y5zMX1AwoO_LVcpLfFLuiLykrsdne0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pMS5z/bmRjZG4uY29tL2Fy/dHdvcmtzLW5ad3Vj/U2kwZGR4Si0wLXQx/MDgweDEwODAuanBn",
  },
];


Future<void> uploadSongsToFirestore() async
{
  final firestore = FirebaseFirestore.instance;

  for (var song in initialSongs)
  {
    await firestore.collection('songs').doc(song['track_id']).set(
        {
          'songurl':song['songurl'],
      'track_id': song['track_id'],
      'track_name': song['track_name'],
      'artist_name': song['artist_name'],
      'genre': song['genre'],
      'url': song['url'],
    }
    );
  }

  print("✅ All songs uploaded as separate documents in 'songs' collection!");
}
