import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/post.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/resources/firestore_methods.dart';
import 'package:flutter_instagram/screens/comments_screen.dart';
import 'package:flutter_instagram/utils/colors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLikeAnimating = false;
  int commentsLength = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection('posts').doc(widget.post.postId).collection('comments').get();
      commentsLength = snap.docs.length;
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //! Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post.avatarUrl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                widget.post.uid == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: const [
                                    'Delete',
                                  ].map((item) {
                                    return InkWell(
                                      onTap: () async {
                                        String res = await FirestoreMethods().deletePost(widget.post.postId);
                                        if (res != 'success' && mounted) {
                                          showSnackBar(res, context);
                                        }
                                        if (mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        child: Text(item),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(CupertinoIcons.ellipsis_vertical),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),

          //! Image
          GestureDetector(
            onDoubleTap: () async {
              setState(() => _isLikeAnimating = true);
              String res = await FirestoreMethods().likePost(
                widget.post.postId,
                user.uid,
                widget.post.likes,
              );
              if (res != 'success' && mounted) {
                showSnackBar(res, context);
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    minHeight: MediaQuery.of(context).size.height * 0.30,
                  ),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.post.postUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorWidget: (context, url, error) => const Icon(Icons.error, size: 100),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _isLikeAnimating ? 0.9 : 0,
                  child: LikeAnimation(
                    isAnimating: _isLikeAnimating,
                    duration: const Duration(milliseconds: 50),
                    onEnd: () {
                      setState(() => _isLikeAnimating = false);
                    },
                    child: const Icon(CupertinoIcons.heart_fill, size: 100),
                  ),
                )
              ],
            ),
          ),

          //! Footer
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.post.likes.contains(user.uid),
                smallLike: true,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  onPressed: () async {
                    String res = await FirestoreMethods().likePost(
                      widget.post.postId,
                      user.uid,
                      widget.post.likes,
                    );
                    if (res != 'success' && mounted) {
                      showSnackBar(res, context);
                    }
                  },
                  iconSize: 30,
                  icon: widget.post.likes.contains(user.uid)
                      ? const Icon(CupertinoIcons.heart_fill, color: Colors.red)
                      : const Icon(CupertinoIcons.heart),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        post: widget.post,
                      ),
                    ),
                  );
                },
                iconSize: 30,
                icon: const Icon(
                  CupertinoIcons.chat_bubble_2,
                ),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                icon: const Icon(
                  CupertinoIcons.arrowshape_turn_up_right,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    iconSize: 30,
                    icon: const Icon(
                      CupertinoIcons.bookmark,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //! Description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.post.likes.length} likes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.post.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: widget.post.description,
                        ),
                      ],
                    ),
                  ),
                ),
                commentsLength != 0
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                post: widget.post,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'View all $commentsLength comments',
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.post.publishDate.toDate()),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
