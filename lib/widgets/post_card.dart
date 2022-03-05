import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/comments_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final QueryDocumentSnapshot postData;

  const PostCard({Key? key, required this.postData}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  // WHEN USER LIKES POST
  onLikePressed(String userId, Post postClicked) async {
    await FirestoreMethods()
        .likePost(postClicked.postId, userId, postClicked.likes);
  }

  // ON DELETE POST
  deletePost(String postId) async {
    await FirestoreMethods().deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    final Post post = Post.fromSnapshot(widget.postData);

    // Get the current user's data
    final User user = Provider.of<UserProvider>(context).getUser!;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Profile pic and 3 dots if this post was created by the current user
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(post.profImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // This button will only appear if the current user is the owner of this post

                post.uid == user.uid
                    ? IconButton(
                        onPressed: () {
                          // Shows a simple dialog, prompting user to edit, delete or cancel
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: ['Edit', 'Delete', 'Cancel']
                                          .map((e) => InkWell(
                                                onTap: () {
                                                  if (e == 'Delete') {
                                                    // Launch delete post function
                                                    deletePost(post.postId);
                                                  }

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),

          // IMAGE SECTION
          GestureDetector(
            // On double tap of post image
            // Show like animation too
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
              onLikePressed(user.uid, post);
            },

            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    post.postUrl,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),

                // POSITIONED LIKE ANIMATION IN CENTER
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        // Set the isLikeAnimating to false
                        setState(() {
                          isLikeAnimating = false;
                        });
                      }),
                ),
              ],
            ),
          ),

          // LIKE COMMENT SECTION
          Row(
            children: [
              // LIKE BUTTON
              LikeAnimation(
                isAnimating: post.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () => onLikePressed(user.uid, post),
                  icon: Icon(
                    post.likes.contains(user.uid)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    // Will be red when this post is liked by user
                    // If not liked, then its just going to have a white border
                    color: post.likes.contains(user.uid)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),

              // COMMENT BUTTON
              IconButton(
                onPressed: () {
                  // Navigate to CommentsScreen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: post.postId,
                    ),
                  ));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),

              // SHARE BUTTON
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),

              // SAVE POST ICON
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                      // Color will be white(filled) if this post was saved by user
                    ),
                  )
                ],
              )),
            ],
          ),

          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LIKES
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: InkWell(
                    onTap: () {},
                    child: Text(post.likes.length.toString() + ' likes'),
                  ),
                ),

                // USERNAME AND DESCRIPTION
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            // Take the const out later
                            text: TextSpan(
                                style: const TextStyle(
                                  color: primaryColor,
                                ),
                                children: [
                                  // Username
                                  TextSpan(
                                    text: post.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // DESCRIPTION
                                  TextSpan(
                                    text: '  ${post.description}',
                                  ),
                                ]),
                          ),
                        ),
                        // Show more button when description is too big
                        Expanded(
                            child: TextButton(
                                onPressed: () {},
                                child: const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'more',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
                // SHOW ALL COMMENTS BUTTON
                InkWell(
                  onTap: () {
                    // Navigate to post page comment's
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: const Text(
                      'View all 100 comments',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(post.datePublished)),
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
