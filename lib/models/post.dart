import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final publishDate;
  final String postUrl;
  final String avatarUrl;
  final likes;

  PostModel({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.publishDate,
    required this.postUrl,
    required this.avatarUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'publishDate': publishDate,
        'avatarUrl': avatarUrl,
        'postUrl': postUrl,
        'likes': likes,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      publishDate: snapshot['publishDate'],
      postUrl: snapshot['postUrl'],
      avatarUrl: snapshot['avatarUrl'],
      likes: snapshot['likes'],
    );
  }
}
