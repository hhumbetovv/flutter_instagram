import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/models/post.dart';
import 'package:flutter_instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! Upload post

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String avatarUrl,
  ) async {
    String res = 'Some error occurred';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      PostModel post = PostModel(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        publishDate: DateTime.now(),
        postUrl: photoUrl,
        avatarUrl: avatarUrl,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
