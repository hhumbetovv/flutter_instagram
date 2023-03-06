import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/add_post.screen.dart';

const int webScreenSize = 600;

const List<Widget> screenItems = [
  Center(child: Text('Home')),
  Center(child: Text('Search')),
  AddPostScreen(),
  Center(child: Text('Feed')),
  Center(child: Text('Profile')),
];
