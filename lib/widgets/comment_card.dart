import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/colors.dart';
import 'package:flutter_instagram/utils/utils.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(randomImageUrl()),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Username',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' Some Description...',
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '21/23/2023',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              CupertinoIcons.heart_fill,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
