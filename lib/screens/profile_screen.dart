import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/post.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/resources/auth_methods.dart';
import 'package:flutter_instagram/resources/firestore_methods.dart';
import 'package:flutter_instagram/screens/login_screen.dart';
import 'package:flutter_instagram/utils/colors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _user;
  final List<PostModel> _posts = [];
  int _followersLength = 0;
  int _followingLength = 0;
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => _isLoading = true);
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      QuerySnapshot postSnaps = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .orderBy('publishDate', descending: true)
          .get();
      _user = UserModel.fromSnap(userSnap);
      if (postSnaps.docs.isNotEmpty) {
        for (var postSnap in postSnaps.docs) {
          _posts.add(PostModel.fromSnap(postSnap));
        }
      }
      _isFollowing = _user.followers.contains(FirebaseAuth.instance.currentUser!.uid);
      _followersLength = _user.followers.length;
      _followingLength = _user.following.length;
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(_user.avatarUrl),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatus(_posts.length, 'posts'),
                                    buildStatus(_followersLength, 'followers'),
                                    buildStatus(_followingLength, 'following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                                        ? CustomButton(
                                            text: 'Sign out',
                                            backgroundColor: mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              String res = await AuthMethods().signOut();
                                              if (res != 'success' && mounted) {
                                                showSnackBar(res, context);
                                              } else {
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) => const LoginScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : _isFollowing
                                            ? CustomButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  String res = await FirestoreMethods()
                                                      .followUser(FirebaseAuth.instance.currentUser!.uid, _user.uid);
                                                  if (res != 'success' && mounted) {
                                                    showSnackBar(res, context);
                                                  } else {
                                                    setState(() {
                                                      _isFollowing = false;
                                                      _followersLength--;
                                                    });
                                                  }
                                                },
                                              )
                                            : CustomButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: primaryColor,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  String res = await FirestoreMethods()
                                                      .followUser(FirebaseAuth.instance.currentUser!.uid, _user.uid);
                                                  if (res != 'success' && mounted) {
                                                    showSnackBar(res, context);
                                                  } else {
                                                    setState(() {
                                                      _isFollowing = true;
                                                      _followersLength++;
                                                    });
                                                  }
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          _user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _user.bio,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GridView.builder(
                  itemCount: _posts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final PostModel post = _posts[index];
                    return CachedNetworkImage(
                      imageUrl: post.postUrl,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatus(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
