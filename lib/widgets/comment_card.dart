import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          // PROFILE PIC
          const CircleAvatar(
            backgroundImage: NetworkImage(defaultProfilePicUrl),
          ),
          // DISPLAY CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // RichText
                  RichText(
                    text: TextSpan(
                      children: [
                        // USERNAME IN BOLD
                        TextSpan(
                          text: widget.comment.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${widget.comment.content}",
                        ),
                      ],
                    ),
                  ),
                  // DATE OF COMMENT
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(DateTime.parse(
                          widget.comment.datePublished.toString())),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // LIKE BUTTON
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // LIKE BTN
                const Icon(
                  Icons.favorite,
                  size: 18,
                ),
                const SizedBox(
                  height: 2,
                ),
                // LIKE COUNT
                Text(widget.comment.likes.length.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
