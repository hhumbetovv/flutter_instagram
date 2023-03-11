import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String avatar;
  final String name;
  final String uid;
  final String text;
  final String commentId;
  final Timestamp publishDate;

  CommentModel({
    required this.avatar,
    required this.name,
    required this.uid,
    required this.text,
    required this.commentId,
    required this.publishDate,
  });

  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'name': name,
        'uid': uid,
        'text': text,
        'commentId': commentId,
        'publishDate': publishDate,
      };

  static CommentModel fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      avatar: snapshot['avatar'],
      name: snapshot['name'],
      uid: snapshot['uid'],
      text: snapshot['text'],
      commentId: snapshot['commentId'],
      publishDate: snapshot['publishDate'],
    );
  }
}
