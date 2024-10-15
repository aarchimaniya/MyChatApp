import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> sendMessage(String friendId, String content,
      {bool isImage = false}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final messageData = {
        'senderId': user.uid,
        'receiverId': friendId,
        'content': content,
        'isImage': isImage,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('messages').add(messageData);
    }
  }

  Future<void> deleteChat(String friendId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final messages = await _firestore
          .collection('messages')
          .where('senderId', isEqualTo: user.uid)
          .where('receiverId', isEqualTo: friendId)
          .get();

      for (var doc in messages.docs) {
        await _firestore.collection('messages').doc(doc.id).delete();
      }
    }
  }

  Future<void> changeProfilePicture(String filePath) async {
    final user = _auth.currentUser;
    if (user != null) {
      final ref = _storage.ref().child('profile_pictures').child(user.uid);
      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();

      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': url,
      });
    }
  }
}
