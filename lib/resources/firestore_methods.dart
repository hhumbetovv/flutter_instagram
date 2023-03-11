import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/comment.dart';
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
        publishDate: Timestamp.fromDate(DateTime.now()),
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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name, String avatar) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        CommentModel comment = CommentModel(
          avatar: avatar,
          name: name,
          uid: uid,
          text: text,
          commentId: commentId,
          publishDate: Timestamp.fromDate(DateTime.now()),
        );

        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(comment.toJson());
      } else {
        debugPrint('Text is empty');
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
