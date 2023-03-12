import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/add_post.screen.dart';
import 'package:flutter_instagram/screens/feed_screen.dart';
import 'package:flutter_instagram/screens/profile_screen.dart';
import 'package:flutter_instagram/screens/search_screen.dart';

const int webScreenSize = 600;

List<Widget> screenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(child: Text('Notification')),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
