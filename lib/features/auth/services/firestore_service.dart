import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/song_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create user profile if first login
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String name = "",
  })
  async
  {
    final userRef = _firestore.collection('users').doc(uid);
    final doc = await userRef.get();
    if (!doc.exists)
    {
      await userRef.set({
        'uid': uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Log user interaction with a song
  Future<void> logInteraction({
    required String userId,
    required String trackId,
    required int interactionStrength,
  })
  async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('interactions')
        .doc(trackId);

    await ref.set({
      'trackId': trackId,
      'strength': interactionStrength,
      'lastInteracted': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Add a song to the 'songs' collection
  Future<void> song({
    required String songurl,
    required String trackId,
    required String trackName,
    required String artistName,
    required String genre,
    required String url,
  }) async {
    await _firestore.collection('songs').doc(trackId).set({
      'songurl':songurl,
      'track_id': trackId,
      'track_name': trackName,
      'artist_name': artistName,
      'genre': genre,
      'url': url,
    });
  }
  Future<List<Song>> getSongs() async {
    final snapshot = await _firestore.collection('songs').get();
    return snapshot.docs.map((doc) => Song.fromFirestore(doc.data())).toList();
  }
}
