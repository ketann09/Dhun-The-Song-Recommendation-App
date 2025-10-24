import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SongService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch songs from Firestore
  Future<List<Map<String, dynamic>>> getSongs() async {
    try {
      final snapshot = await _firestore.collection('songs').limit(20).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching songs from Firestore: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not logged in");
      return [];
    }

    final url = "http://10.0.2.2:8000/recommend_hybrid";
    final body = jsonEncode({"user_id": user.uid});
    print("POST $url with body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print("Recommendations: $data");
      return data;
    } else {
      print("Failed to load recommendations");
      return [];
    }
  }
}