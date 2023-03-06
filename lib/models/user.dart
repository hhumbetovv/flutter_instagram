import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String avatarUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const UserModel({
    required this.email,
    required this.uid,
    required this.avatarUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot['username'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      avatarUrl: snapshot['avatarUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
