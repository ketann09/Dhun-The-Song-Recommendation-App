import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SongService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Fetch songs from Firestore (e.g. new releases)
  Future<List<Map<String, dynamic>>> getSongs() async {
    final snapshot = await _firestore.collection('songs').limit(10).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ✅ Fetch recommendations from ML API
  Future<List<Map<String, dynamic>>> getRecommendations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = await http.get(
      Uri.parse("https://your-backend.com/recommendations?userId=${user.uid}"),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load recommendations");
    }
  }
}
