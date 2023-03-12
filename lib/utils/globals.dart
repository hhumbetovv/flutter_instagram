import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/add_post.screen.dart';
import 'package:flutter_instagram/screens/feed_screen.dart';
import 'package:flutter_instagram/screens/search_screen.dart';

const int webScreenSize = 600;

const List<Widget> screenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text('Notification')),
  Center(child: Text('Profile')),
];
