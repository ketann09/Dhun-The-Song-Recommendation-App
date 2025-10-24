import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String email,
    String name = "",
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'favorites': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logInteraction({
    required String userId,
    required String trackId,
    required int interactionStrength,
  }) async {
    await _firestore.collection('interactions').add({
      'userId': userId,
      'trackId': trackId,
      'strength': interactionStrength,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
