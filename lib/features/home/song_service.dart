import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SongService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all songs from Firestore
  Future<List<Map<String, dynamic>>> getSongs() async {
    try {
      final snapshot = await _firestore.collection('songs').limit(20).get();
      return snapshot.docs
          .map((doc) => Map<String, dynamic>.from(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching songs from Firestore: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async
  {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final url = "https://song-recommender-4.onrender.com/recommend_hybrid?user_id=${user.uid}&top_k=10&alpha=0.5";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return [];

      final body = jsonDecode(response.body);

      // Extract recommendations
      final recs = body['data']['recommendations'] as List<dynamic>;

      // Map ML recommendations to your PlayerScreen format
      final mapped = recs.map((rec) => {
        'track_id': rec['song_id'],
        'track_name': rec['title'],
        'artist_name': rec['artist'],
        'url': rec['cover_image'],   // artwork
        'songurl': rec['url'],       // audio
      }).toList();

      return List<Map<String, dynamic>>.from(mapped);
    } catch (e) {
      print("Error fetching recommendations: $e");
      return [];
    }
  }
}
